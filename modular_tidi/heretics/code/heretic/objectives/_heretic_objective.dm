/datum/objective/heretic
	name = "heretic objective"
	triumph_count = 0
	flavor = "Objective"
	var/heretic_patron
	var/heretic_tier
	var/heretic_branch
	var/rite_offering
	var/list/rite_chant_lines

/datum/objective/heretic/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_QDELETING, PROC_REF(on_body_deleted))

/datum/objective/heretic/proc/on_body_deleted(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, signal_procs[source])

/datum/objective/heretic/proc/check_offering(mob/living/user, atom/movable/offering)
	return

/datum/objective/heretic/proc/take_offering(mob/living/user, atom/movable/offering, turf/loc)
	return

/datum/objective/heretic/proc/complete()
	if(completed)
		return
	completed = TRUE
	if(owner?.current)
		owner.current.playsound_local(owner.current, 'modular_tidi/heretics/sound/heretic_complete.ogg', 100, FALSE)
		to_chat(owner.current, span_cult("<i>Done. The Rite of Ascension awaits me.</i>"))

/datum/objective/heretic/proc/progress_text()
	return
