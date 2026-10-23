/datum/runeritual/god/astrata/guiding_light
	name = "Guiding Light"
	desc = "Turns Astrata's gaze upon everyone within seven paces of the rune, granting her guiding light. The ritualist bursts into flames unless they are Chosen."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/astrata/guiding_light/perform(mob/living/user, obj/structure/ritualcircle/astrata/circle)
	if(!do_after(user, 5 SECONDS)) // just flavor stuff before activation
		return FALSE
	user.say("I beseech the guidance of the Sun!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("To bring Order to a world of naught!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Place your gaze upon me, oh Radiant one!!")
	to_chat(user,span_danger("<i>You feel the eye of Astrata turned upon you. Her warmth dances upon your cheek. You feel yourself warming up...</i>")) // A bunch of flavor stuff, slow incanting.
	circle.icon_state = "astrata_active"
	if(!HAS_TRAIT(user, TRAIT_CHOSEN)) //Priests don't burst into flames.
		circle.loc.visible_message(span_warning("[user]'s bursts to flames! Embraced by Her Warmth wholly!"))
		playsound(circle.loc, 'sound/combat/hits/burn (1).ogg', 100, FALSE, -1)
		user.adjust_fire_stacks(10)
		user.ignite_mob()
		user.flash_fullscreen("redflash3")
		user.emote("firescream")
	circle.guidinglight(circle) // Actually starts the proc for applying the buff
	playsound(user, 'sound/magic/holyshield.ogg', 60, FALSE, -1) // Cool sound! But it blows out eardrums with large groups so we move it here.
	addtimer(VARSET_CALLBACK(circle, icon_state, "astrata_chalky"), 12 SECONDS)
	return TRUE
