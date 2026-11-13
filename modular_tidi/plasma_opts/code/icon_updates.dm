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

/datum/controller/subsystem/iconupdates/Recover()
	dirty_slates = SSiconupdates.dirty_slates
	queued_mobs = SSiconupdates.queued_mobs
	currentrun = SSiconupdates.currentrun

/datum/controller/subsystem/iconupdates/stat_entry(msg)
	msg = "S:[length(dirty_slates)]|Q:[length(queued_mobs) + length(currentrun)]"
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
