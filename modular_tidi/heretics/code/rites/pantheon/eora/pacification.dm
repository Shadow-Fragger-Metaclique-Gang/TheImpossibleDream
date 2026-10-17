/datum/runeritual/god/eora/pacification
	name = "Rite of Pacification"
	desc = "Eases the burdens of whoever stands on the rune, pacifying them."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/eora/pacification/perform(mob/living/user, obj/structure/ritualcircle/eora/circle)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("#Blessed be your weary head...")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("#Full of strife and pain...")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("#Let Her ease your fear...")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	circle.icon_state = "eora_active"
	circle.pacify(circle)
	addtimer(VARSET_CALLBACK(circle, icon_state, "eora_chalky"), 12 SECONDS)
	return TRUE
