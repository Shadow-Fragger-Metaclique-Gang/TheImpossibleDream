/datum/objective/heretic/matthios/noble_wound
	name = "Blue Blood"
	heretic_tier = 2

/datum/objective/heretic/matthios/noble_wound/update_explanation_text()
	explanation_text = "Deal a critical wound to a noble."

/datum/objective/heretic/matthios/noble_wound/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HERETIC_CRIT_DEALT, PROC_REF(on_crit))
	update_explanation_text()

/datum/objective/heretic/matthios/noble_wound/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HERETIC_CRIT_DEALT)
	return ..()

/datum/objective/heretic/matthios/noble_wound/proc/on_crit(datum/source, mob/living/carbon/human/victim, datum/wound/applied)
	SIGNAL_HANDLER
	if(completed || !istype(victim) || !victim.is_noble())
		return
	complete()
	UnregisterSignal(owner.current, COMSIG_HERETIC_CRIT_DEALT)
