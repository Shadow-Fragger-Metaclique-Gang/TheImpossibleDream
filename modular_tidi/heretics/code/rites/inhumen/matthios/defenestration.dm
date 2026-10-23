/datum/runeritual/god/matthios/defenestration
	name = "Defenestration"
	desc = "Strips Astrata's gift of nobility from a noble standing on the rune, minting their lux into coin."
	cooldown = 30 MINUTES

/datum/runeritual/god/matthios/defenestration/perform(mob/living/user, obj/structure/ritualcircle/matthios/circle)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("The window is open, the sacrifice is made!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Pieces o' tens, hundreds, thousands; o', the Grin feeds 'pon them all!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Accept my gift o' unmatched value, and let me wield your heat, your hate, and burn all that remains!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	circle.icon_state = "matthios_active"
	var/list/undefiled = list()
	for(var/mob/living/carbon/human/noble in get_turf(circle))
		if(!HAS_TRAIT(noble, TRAIT_DEFILED_NOBLE))
			undefiled += noble
	if(circle.defenestration())
		to_chat(user, span_cultsmall("<i>The ritual is complete, and the noble gift of Astrata has been taken!</i>"))
		for(var/mob/living/carbon/human/victim as anything in undefiled)
			if(HAS_TRAIT(victim, TRAIT_DEFILED_NOBLE))
				SEND_SIGNAL(user, COMSIG_HERETIC_DEFENESTRATED, victim)
		. = TRUE
	else
		to_chat(user, span_cultsmall("<i>The ritual fails. A noble must be in the center of the circle!</i>"))
		circle.fail_invoke()
	addtimer(VARSET_CALLBACK(circle, icon_state, "matthios_chalky"), 12 SECONDS)
