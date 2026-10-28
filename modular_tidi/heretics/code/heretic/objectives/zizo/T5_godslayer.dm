/datum/objective/heretic/zizo/avantyne/godslayer
	name = "Godslayer"
	heretic_tier = 5

/datum/objective/heretic/zizo/avantyne/godslayer/update_explanation_text()
	explanation_text = "Clad in avantyne, land the killing blow against a member of the high nobility, the inquisition, the Pontifex, or the Martyr."

/datum/objective/heretic/zizo/avantyne/godslayer/is_quarry(mob/living/carbon/human/victim)
	return victim.is_heretic_prize()
