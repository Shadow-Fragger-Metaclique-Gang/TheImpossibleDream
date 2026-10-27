/datum/objective/heretic/zizo/avantyne/garrison
	name = "Breaking the Garrison"
	heretic_tier = 4
	kills_required = 2

/datum/objective/heretic/zizo/avantyne/garrison/update_explanation_text()
	explanation_text = "Clad in avantyne, land the killing blow against two members of the garrison."

/datum/objective/heretic/zizo/avantyne/garrison/is_quarry(mob/living/carbon/human/victim)
	var/job_title = victim.mind?.assigned_role
	return (job_title in GLOB.garrison_positions) || (job_title in GLOB.retinue_positions)
