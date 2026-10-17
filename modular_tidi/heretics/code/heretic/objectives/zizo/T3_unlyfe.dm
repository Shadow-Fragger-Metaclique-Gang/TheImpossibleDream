/datum/objective/heretic/zizo/deadite
	name = "Unlyfe"
	heretic_tier = 3
	heretic_branch = HERETIC_PATH_AMBITION

/datum/objective/heretic/zizo/deadite/update_explanation_text()
	explanation_text = "Use the Raise Deadite ritual to raise a corpse as an empowered deadite."

/datum/objective/heretic/zizo/deadite/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HERETIC_DEADITE_RAISED, PROC_REF(on_deadite_raised))
	update_explanation_text()

/datum/objective/heretic/zizo/deadite/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HERETIC_DEADITE_RAISED)
	return ..()

/datum/objective/heretic/zizo/deadite/proc/on_deadite_raised(datum/source, mob/living/carbon/human/vessel)
	SIGNAL_HANDLER
	if(completed)
		return
	complete()
	UnregisterSignal(owner.current, COMSIG_HERETIC_DEADITE_RAISED)
