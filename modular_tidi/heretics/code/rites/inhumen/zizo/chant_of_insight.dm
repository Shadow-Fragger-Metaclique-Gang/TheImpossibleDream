/datum/runeritual/god/zizo/chant_of_insight
	name = "Chant of Insight"
	desc = "Snuffs the lights around the rune and grants Zizo's insight to everyone within seven paces, at the price of the sun's favor."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/zizo/chant_of_insight/perform(mob/living/user, obj/structure/ritualcircle/zizo/circle) //+2 int and perfect nitevision, at the price of sunlight sensitivity
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("ZIZO! ZIZO! BRINGER OF NITE, REAPER OF DAY!")
	playsound(user, 'sound/misc/carriage4.ogg', 100, FALSE, -1)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("ZIZO! ZIZO! HEED MY CALL!")
	playsound(user, 'sound/misc/carriage2.ogg', 100, FALSE, -1)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("ZIZO! ZIZO! EYES ATTUNED TO DARK, WISDOM BEYOND THE MOON!")
	circle.icon_state = "zizo_active"
	to_chat(user,span_cultsmall("<i>Her Inzanity although incomprehensible to the ignorant, is invaluable to the enlightened. Her darkness now guides you, for the light now spurns you.</i>"))
	circle.zizolightsnuff(circle)
	addtimer(VARSET_CALLBACK(circle, icon_state, "zizo_chalky"), 12 SECONDS)
	sleep(1 SECONDS)
	playsound(circle.loc, 'sound/magic/shadowstep.ogg', 200, FALSE, -1)
	circle.knowledgerituos(circle)
	return TRUE
