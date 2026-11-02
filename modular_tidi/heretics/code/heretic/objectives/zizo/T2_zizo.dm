/datum/objective/heretic/zizo/apostasy
	name = "ZIZO!"
	heretic_tier = 2
	var/list/affected = list()
	var/affected_needed = 4

/datum/objective/heretic/zizo/apostasy/update_explanation_text()
	explanation_text = "Speak ZIZO's name to four different people. You must be visible to them, but your identity may be obscured. The listeners may not be of heretical faith."

/datum/objective/heretic/zizo/apostasy/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HERETIC_APOSTASY_HEARD, PROC_REF(on_apostasy_heard))
	update_explanation_text()

/datum/objective/heretic/zizo/apostasy/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HERETIC_APOSTASY_HEARD)
	return ..()

/datum/objective/heretic/zizo/apostasy/proc/on_apostasy_heard(datum/source, mob/living/hearer)
	SIGNAL_HANDLER
	if(completed)
		return
	var/datum/weakref/hearer_ref = WEAKREF(hearer)
	if((hearer_ref in affected) || !(owner.current in view(7, hearer)))
		return
	affected += hearer_ref
	if(length(affected) < affected_needed)
		return
	complete()
	UnregisterSignal(owner.current, COMSIG_HERETIC_APOSTASY_HEARD)

/datum/objective/heretic/zizo/apostasy/progress_text()
	return "[length(affected)] of [affected_needed] people."
