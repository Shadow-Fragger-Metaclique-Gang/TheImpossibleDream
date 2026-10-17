/datum/objective/heretic/zizo/avantyne/godslayer
	name = "Godslayer"
	heretic_tier = 5

/datum/objective/heretic/zizo/avantyne/godslayer/update_explanation_text()
	explanation_text = "Clad in avantyne, lethally slit the throat of a member of the high nobility, the Pontifex, the Martyr or the inquisition."

/datum/objective/heretic/zizo/avantyne/godslayer/is_quarry(mob/living/carbon/human/victim)
	return victim.is_heretic_prize()
