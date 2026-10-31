/datum/objective/heretic/zizo/sacrifice
	name = "Last Rites"
	heretic_tier = 5
	heretic_branch = HERETIC_PATH_AMBITION

/datum/objective/heretic/zizo/sacrifice/update_explanation_text()
	explanation_text = "Use the Raise Deadite ritual to raise a member of the high nobility, the inquisition, the Pontifex, or the Martyr as an empowered deadite."

/datum/objective/heretic/zizo/sacrifice/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HERETIC_DEADITE_RAISED, PROC_REF(on_deadite_raised))
	update_explanation_text()

/datum/objective/heretic/zizo/sacrifice/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HERETIC_DEADITE_RAISED)
	return ..()

/datum/objective/heretic/zizo/sacrifice/proc/on_deadite_raised(datum/source, mob/living/carbon/human/vessel)
	SIGNAL_HANDLER
	if(completed || !vessel.is_heretic_prize())
		return
	record_victim(vessel)
	complete()
	UnregisterSignal(owner.current, COMSIG_HERETIC_DEADITE_RAISED)
