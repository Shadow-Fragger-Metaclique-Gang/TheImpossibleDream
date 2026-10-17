/datum/runeritual/god/graggar/war_ritual
	name = "War Ritual"
	desc = "Defiles a noble, clergy or Inquisition member standing on the rune and tears goblin portals open across the land."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 1 HOURS

/datum/runeritual/god/graggar/war_ritual/perform(mob/living/user, obj/structure/ritualcircle/graggar/circle)
	to_chat(user, span_userdanger("<i>This rite will get me more tired than usual... I wonder, should I proceed?</i>"))
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Blood for the blooded, the circle is drawn!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Let noble flesh be the price for the horde!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Let portals open, let the goblins swarm!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	circle.icon_state = "graggar_active"
	if(circle.perform_warritual())
		. = TRUE
	else
		deny(user, circle, "The ritual fails. A noble, a member of the Inquisition or a Pantheonic clergy member must be in the center of the circle!")
	addtimer(VARSET_CALLBACK(circle, icon_state, "graggar_chalky"), 12 SECONDS)
