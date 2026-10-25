/datum/wound
	/// Override the default % chance for werewolf infection to always trigger an infection
	werewolf_infection_probability = 100

/mob/living/death(gibbed, nocutscene = FALSE) // we want to remove the curse on death
	if(!isnull(mind))
		mind.remove_antag_datum(/datum/antagonist/werewolf)
		mind.remove_antag_datum(/datum/antagonist/werewolf/lesser)
	return ..()
