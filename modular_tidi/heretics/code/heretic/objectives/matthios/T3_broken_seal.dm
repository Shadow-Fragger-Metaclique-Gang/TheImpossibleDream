/datum/objective/heretic/matthios/churn/signet
	name = "Broken Seal"
	heretic_tier = 3
	heretic_branch = HERETIC_PATH_THIEF

/datum/objective/heretic/matthios/churn/signet/update_explanation_text()
	explanation_text = "Use CHURN VALUE on a signet ring in view of another."

/datum/objective/heretic/matthios/churn/signet/progress_text()
	return

/datum/objective/heretic/matthios/churn/signet/is_worthy(obj/item/churned, value)
	if(!istype(churned, /obj/item/clothing/ring/signet))
		return FALSE
	for(var/mob/living/carbon/human/witness in get_hearers_in_view(7, owner.current))
		if(witness != owner.current && witness.client && witness.stat == CONSCIOUS)
			return TRUE
	return FALSE
