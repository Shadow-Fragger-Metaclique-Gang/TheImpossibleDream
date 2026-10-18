/datum/objective/heretic/graggar/organs
	name = "GOREFEAST"
	heretic_tier = 1

/datum/objective/heretic/graggar/organs/update_explanation_text()
	explanation_text = "Eat an organ in view of another."

/datum/objective/heretic/graggar/organs/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_ORGAN_CONSUMED, PROC_REF(on_organ_consumed))
	update_explanation_text()

/datum/objective/heretic/graggar/organs/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ORGAN_CONSUMED)
	return ..()

/datum/objective/heretic/graggar/organs/proc/on_organ_consumed(datum/source, organ_type, obj/item/organ/organ_inside)
	SIGNAL_HANDLER
	if(completed)
		return
	for(var/mob/living/carbon/human/witness in get_hearers_in_view(7, owner.current))
		if(witness != owner.current && witness.client && witness.stat == CONSCIOUS)
			complete()
			UnregisterSignal(owner.current, COMSIG_ORGAN_CONSUMED)
			return
