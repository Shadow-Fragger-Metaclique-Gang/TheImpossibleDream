/datum/objective/heretic/baotha/emberwine
	name = "Embers of Desire"
	heretic_tier = 4
	needs_indulgence = FALSE

/datum/objective/heretic/baotha/emberwine/update_explanation_text()
	explanation_text = "Make a member of the high nobility, a member of the clergy, a member of the inquisition, the Pontifex, or the Martyr climax while they are affected by drugs or emberwine."

/datum/objective/heretic/baotha/emberwine/on_climax(mob/living/carbon/human/climaxer)
	if(!climaxer.is_heretic_prize())
		return
	if(!heretic_is_drugged(climaxer.reagents) && !climaxer.has_status_effect(/datum/status_effect/debuff/emberwine))
		return
	record_victim(climaxer)
	complete()
