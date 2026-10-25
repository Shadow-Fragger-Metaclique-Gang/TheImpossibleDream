/datum/objective/heretic/baotha/clergy
	name = "Corruption"
	heretic_tier = 3
	needs_indulgence = FALSE

/datum/objective/heretic/baotha/clergy/update_explanation_text()
	explanation_text = "Make a noble, a member of the clergy, or a member of the inquisition bearing Baotha's brand climax while they are affected by drugs or emberwine."

/datum/objective/heretic/baotha/clergy/on_climax(mob/living/carbon/human/climaxer)
	if(!HAS_TRAIT(climaxer, TRAIT_BAOTHA_FERTILITY_BOON) || (!climaxer.is_noble() && !climaxer.is_clergy_or_inquisition()))
		return
	if(!heretic_is_drugged(climaxer.reagents) && !climaxer.has_status_effect(/datum/status_effect/debuff/emberwine))
		return
	complete()
