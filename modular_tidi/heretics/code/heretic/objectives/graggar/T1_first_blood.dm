/datum/objective/heretic/graggar/wound
	name = "FIRST BLOOD"
	heretic_tier = 1

/datum/objective/heretic/graggar/wound/update_explanation_text()
	explanation_text = "Deal a critical wound to another person."

/datum/objective/heretic/graggar/wound/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HERETIC_CRIT_DEALT, PROC_REF(on_crit))
	update_explanation_text()

/datum/objective/heretic/graggar/wound/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HERETIC_CRIT_DEALT)
	return ..()

/datum/objective/heretic/graggar/wound/proc/on_crit(datum/source, mob/living/victim, datum/wound/applied)
	SIGNAL_HANDLER
	if(completed || victim == owner.current || !victim.client)
		return
	complete()
	UnregisterSignal(owner.current, COMSIG_HERETIC_CRIT_DEALT)
