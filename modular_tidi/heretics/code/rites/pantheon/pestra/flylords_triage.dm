/datum/runeritual/god/pestra/flylords_triage
	name = "Flylord's Triage"
	desc = "Disgorges a swarm of flies into whoever stands on the rune, agonisingly tending to their wounds."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/pestra/flylords_triage/perform(mob/living/user, obj/structure/ritualcircle/pestra/circle)
	if(do_after(user, 50))
		user.say("Buboes, phlegm, blood and guts!!")
		if(do_after(user, 50))
			user.say("Boils, bogeys, rots and pus!!")
			if(do_after(user, 50))
				user.say("Blisters, fevers, weeping sores!!")
				to_chat(user,span_danger("<i>You feel something crawling up your throat, humming and scratching...</i>"))
				if(do_after(user, 30))
					circle.icon_state = "pestra_active"
					user.say("From your wounds, the fester pours!!")
					to_chat(user,span_cultsmall("<i>My devotion to the Plague Queen allowing, her servants crawl up from my throat. Come now, father fly...</i>"))
					circle.loc.visible_message(span_warning("[user] opens their mouth, disgorging a great swarm of flies!"))
					playsound(circle.loc, 'sound/misc/fliesloop.ogg', 100, FALSE, -1)
					circle.flylordstriage(circle)
					. = TRUE
					addtimer(VARSET_CALLBACK(circle, icon_state, "pestra_chalky"), 12 SECONDS)
