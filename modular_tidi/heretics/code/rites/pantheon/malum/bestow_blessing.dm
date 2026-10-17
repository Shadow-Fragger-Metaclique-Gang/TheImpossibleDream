/datum/runeritual/god/malum/bestow_blessing
	name = "Bestow Blessing"
	desc = "Blesses everyone within four paces of the rune with Malum's persistence."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/malum/bestow_blessing/perform(mob/living/user, obj/structure/ritualcircle/malum/circle)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("I am a Wallbuilder. Let my walls endure, from season to season, year to year, and age to age.")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Let my walls stand, while families toil, armies march, and empires fall.")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("I am a Wallbuilder, and my walls will stand always as a shield against evil.")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("This I pray, that will the Forgefather grant.")
	circle.icon_state = "malum_active"
	circle.malumblessing(circle)
	playsound(user, 'sound/magic/magearmorup.ogg', 60, FALSE, -1)
	addtimer(VARSET_CALLBACK(circle, icon_state, "malum_chalky"), 12 SECONDS)
	return TRUE
