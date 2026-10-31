/datum/objective/heretic/graggar/wound
	name = "FIRST BLOOD"
	heretic_tier = 1

/datum/objective/heretic/graggar/wound/update_explanation_text()
	explanation_text = "Wound another person, drawing blood. Hylics do not count."

/datum/objective/heretic/graggar/wound/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HERETIC_WOUND_DEALT, PROC_REF(on_wound))
	update_explanation_text()

/datum/objective/heretic/graggar/wound/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HERETIC_WOUND_DEALT)
	return ..()

/datum/objective/heretic/graggar/wound/proc/on_wound(datum/source, mob/living/victim, datum/wound/applied)
	SIGNAL_HANDLER
	if(completed || victim == owner.current || !victim.client)
		return
	record_victim(victim)
	complete()
	UnregisterSignal(owner.current, COMSIG_HERETIC_WOUND_DEALT)
