/datum/objective/heretic/baotha/brand
	name = "Marked"
	heretic_tier = 2
	baotha_objective_text = "bring someone bearing Baotha's brand to climax, so long as they aren't of the clergy or the inquisition"

/datum/objective/heretic/baotha/brand/on_climax(mob/living/carbon/human/climaxer)
	if(baotha_objective_done || !HAS_TRAIT(climaxer, TRAIT_BAOTHA_FERTILITY_BOON) || climaxer.is_clergy_or_inquisition())
		return
	baotha_objective_done = TRUE
	check_progress()
