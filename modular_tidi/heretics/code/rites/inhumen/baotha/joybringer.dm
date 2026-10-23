/datum/runeritual/god/baotha/joybringer
	name = "Joybringer"
	desc = "Fills the ritualist's cup with Baotha's endless mirth."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/baotha/joybringer/perform(mob/living/user, obj/structure/ritualcircle/baotha/circle)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Let the wine flow, let the music crash!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Away with tears, away with shame!")
	to_chat(user, span_notice("<i>The memory of sorrow fades into a haze of bliss.</i>"))
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Grant me the bliss, grant me the rush!")
	if(!do_after(user, 3 SECONDS))
		return FALSE
	user.say("Baotha, fill my cup with endless mirth!")
	playsound(circle.loc, 'sound/misc/evilevent.ogg', 100, FALSE, -1)
	user.apply_status_effect(/datum/status_effect/joybringer)
	return TRUE
