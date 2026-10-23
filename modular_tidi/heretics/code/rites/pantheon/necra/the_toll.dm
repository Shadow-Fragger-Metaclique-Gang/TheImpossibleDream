/datum/runeritual/god/necra/the_toll
	name = "The Toll"
	desc = "Spends a toll shattered over the rune to pull a dead soul beside it back into their body."

/datum/runeritual/god/necra/the_toll/perform(mob/living/user, obj/structure/ritualcircle/necra/circle)
	if(!circle.coinslot)
		to_chat(user, "<i>This rite requires the toll to be prepared...</i>")
		return FALSE
	var/onrune = view(1, circle.loc)
	var/list/folksonrune = list()
	for(var/mob/living/carbon/human/persononrune in onrune)
		if(persononrune.stat == DEAD)
			folksonrune += persononrune
	var/target = input(user, "Choose a supplicant") as null|anything in folksonrune
	if(target)
		circle.loc.visible_message(span_warning("[user] draws spectral strands of Lux up through the air, tearing the veil between lyfe and death!"))
		playsound(user, 'sound/vo/mobs/ghost/whisper (3).ogg', 100, FALSE, -1)
		if(do_after(user, 60))
			playsound(user, 'sound/vo/mobs/ghost/whisper (1).ogg', 100, FALSE, -1)
			if(do_after(user, 60))
				circle.loc.visible_message(span_warning("[user] moves their lips but no words can be heard, speaking to a massive spectral figure on the other side!"))
				playsound(user, 'sound/vo/mobs/ghost/death.ogg', 100, FALSE, -1)
				if(do_after(user, 20))
					circle.icon_state = "necra_active"
					user.say("For this toll, a soul!!")
					to_chat(user,span_cultsmall("<i>[user] grasps the strands of Lux and attempts to pull a soul through the rift!</i>"))
					circle.thetoll(target, user)
					. = TRUE
					addtimer(VARSET_CALLBACK(circle, icon_state, "necra_chalky"), 12 SECONDS)
