/datum/runeritual/god/abyssor/tides
	name = "Rite of the Tides"
	desc = "Forms a tidal abyssal marker, which opens a tidal spire wherever it is set."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/abyssor/tides/perform(mob/living/user, obj/structure/ritualcircle/abyssor/circle)
	if(do_after(user, 50))
		user.say("Deep Father, hear my call!")
		if(do_after(user, 50))
			user.say("I beg thee! A deluge upon your anointed!")
			if(do_after(user, 50))
				circle.icon_state = "abyssor_active"
				user.say("Let your waters swallow the land!")
				to_chat(user, span_cultsmall("<i>A crystalline shard forms at the center of the rune, humming with Abyssor's power.</i>"))
				new /obj/item/abyssal_marker/tidal(circle.loc)
				. = TRUE
				addtimer(VARSET_CALLBACK(circle, icon_state, "abyssor_chalky"), 24 SECONDS)
