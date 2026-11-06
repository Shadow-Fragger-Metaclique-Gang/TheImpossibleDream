/datum/objective/heretic/baotha/climax
	name = "Shared Pleasure"
	heretic_tier = 1
	baotha_objective_text = "make a non-heretic climax"

/datum/objective/heretic/baotha/climax/on_climax(mob/living/carbon/human/climaxer)
	if(baotha_objective_done || istype(climaxer.patron, /datum/patron/inhumen))
		return
	baotha_objective_done = TRUE
	record_victim(climaxer)
	check_progress()
