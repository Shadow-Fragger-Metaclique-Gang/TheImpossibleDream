/datum/runeritual/god/zizo/dance_of_the_demiurge
	name = "Dance of the Demiurge"
	desc = "Snuffs the lights around the rune and guides the hands of everyone within seven paces."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/zizo/dance_of_the_demiurge/perform(mob/living/user, obj/structure/ritualcircle/zizo/circle) //Jack of all trades
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("ZIZO! ZIZO! DIVINE IS-NOT!")
	playsound(user, 'sound/misc/carriage4.ogg', 100, FALSE, -1)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("ZIZO! ZIZO! HEED MY CALL!")
	playsound(user, 'sound/misc/carriage2.ogg', 100, FALSE, -1)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("ZIZO! ZIZO! RENDER MY AMBITIONS REAL!")
	circle.icon_state = "zizo_active"
	to_chat(user,span_cultsmall("<i>Her Inzanity although incomprehensible to the ignorant, is invaluable to the enlightened. Their hands guide your mynd and dreamed talent to rapidly enact change.</i>"))
	circle.zizolightsnuff(circle)
	addtimer(VARSET_CALLBACK(circle, icon_state, "zizo_chalky"), 12 SECONDS)
	sleep(1 SECONDS)
	playsound(circle.loc, 'sound/magic/shadowstep.ogg', 200, FALSE, -1)
	circle.utilityrituos(circle)
	return TRUE
