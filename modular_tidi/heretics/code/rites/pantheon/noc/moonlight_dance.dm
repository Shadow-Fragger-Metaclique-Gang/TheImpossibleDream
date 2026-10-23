/datum/runeritual/god/noc/moonlight_dance
	name = "Moonlight Dance"
	desc = "Draws Noc's eye upon everyone within seven paces of the rune, granting the moonlight dance."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/noc/moonlight_dance/perform(mob/living/user, obj/structure/ritualcircle/noc/circle)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("I beseech the guidance of the Moon!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("To bring Wisdom to a world of naught!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Place your gaze upon me, oh wise one!!")
	to_chat(user,span_cultsmall("<i>The waning half of the Twin-God carries but one eye. With some effort, it can be drawn upon supplicants.</i>"))
	playsound(circle.loc, 'sound/magic/holyshield.ogg', 80, FALSE, -1)
	circle.moonlightdance(circle)
	return TRUE
