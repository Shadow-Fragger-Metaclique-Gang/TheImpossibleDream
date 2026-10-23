/datum/runeritual/god/noc/moonlight_inspiration
	name = "Moonlight Inspiration"
	desc = "Grants everyone within two paces of the rune a share of Noc's wisdom as dream points."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/noc/moonlight_inspiration/perform(mob/living/user, obj/structure/ritualcircle/noc/circle)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("I seek the guidance of the Moon!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Grant us your wisdom!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Place your gaze upon me, oh wise one!!")
	to_chat(user,span_cultsmall("<i>The waning half of the Twin-God carries but one eye. With some effort, it can be drawn upon supplicants.</i>"))
	playsound(circle.loc, 'sound/magic/holyshield.ogg', 80, FALSE, -1)
	circle.mooninspiration(circle)
	return TRUE
