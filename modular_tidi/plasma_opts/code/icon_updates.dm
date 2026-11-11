SUBSYSTEM_DEF(iconupdates)
	name = "Icon Updates"
	wait = 1
	init_order = INIT_ORDER_ICON_UPDATES
	flags = SS_TICKER
	priority = FIRE_PRIORITY_ICON_UPDATES
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	var/list/dirty_slates = list()
	var/list/queued_mobs = list()
	var/list/currentrun = list()
	var/list/commit_callbacks = list()

/datum/controller/subsystem/iconupdates/Recover()
	dirty_slates = SSiconupdates.dirty_slates
	queued_mobs = SSiconupdates.queued_mobs
	currentrun = SSiconupdates.currentrun
	commit_callbacks = SSiconupdates.commit_callbacks

/datum/controller/subsystem/iconupdates/stat_entry(msg)
	msg = "S:[length(dirty_slates)]|Q:[length(queued_mobs) + length(currentrun)]|CB:[length(commit_callbacks)]"
	return ..()

/datum/controller/subsystem/iconupdates/fire(resumed = FALSE)
	commit_dirty_slates()

	if(!resumed)
		src.currentrun = queued_mobs
		queued_mobs = list()

	var/list/currentrun = src.currentrun
	while(length(currentrun))
		var/mob/living/carbon/C = currentrun[length(currentrun)]
		currentrun.len--
		process_mob(C)
		if(MC_TICK_CHECK)
			return

	run_commit_callbacks()

/datum/controller/subsystem/iconupdates/proc/process_mob(mob/living/carbon/C)
	if(QDELETED(C))
		return
	try
		C.process_pending_icon_updates()
		C.commit_overlay_slate()
	catch(var/exception/e)
		C.flushing_icon_updates = FALSE
		C.icon_updates_ran = NONE
		C.overlay_slate_dirty = FALSE
		stack_trace("Icon update processing failed for [C] ([C.type]): [e.name] at [e.file]:[e.line]")

/datum/controller/subsystem/iconupdates/proc/end_of_tick_flush()
	if(length(queued_mobs))
		var/list/to_process = queued_mobs
		queued_mobs = list()
		for(var/mob/living/carbon/C as anything in to_process)
			process_mob(C)
	commit_dirty_slates()
	run_commit_callbacks()

/datum/controller/subsystem/iconupdates/proc/commit_dirty_slates()
	if(!length(dirty_slates))
		return
	var/list/to_commit = dirty_slates
	dirty_slates = list()
	for(var/mob/M as anything in to_commit)
		if(QDELETED(M))
			continue
		try
			M.commit_overlay_slate()
		catch(var/exception/e)
			M.overlay_slate_dirty = FALSE
			stack_trace("Overlay commit failed for [M] ([M.type]): [e.name] at [e.file]:[e.line]")

/datum/controller/subsystem/iconupdates/proc/run_commit_callbacks()
	if(!length(commit_callbacks))
		return
	var/list/to_run = commit_callbacks
	commit_callbacks = list()
	for(var/atom/A as anything in to_run)
		var/list/callbacks = to_run[A]
		if(QDELETED(A))
			continue
		if(visuals_pending(A))
			commit_callbacks[A] = callbacks
			continue
		for(var/datum/callback/cb as anything in callbacks)
			cb.InvokeAsync()

/datum/controller/subsystem/iconupdates/proc/visuals_pending(atom/A)
	if(!ismob(A))
		return FALSE
	var/mob/M = A
	if(M.overlay_slate_dirty)
		return TRUE
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.pending_icon_updates)
			return TRUE
	return FALSE

/datum/controller/subsystem/iconupdates/proc/after_commit(atom/A, datum/callback/cb)
	if(!initialized || !visuals_pending(A))
		cb.InvokeAsync()
		return
	LAZYADDASSOCLIST(commit_callbacks, A, cb)

/datum/controller/subsystem/iconupdates/proc/wait_for_commit(atom/A)
	if(!initialized)
		return
	UNTIL(QDELETED(A) || !visuals_pending(A))
