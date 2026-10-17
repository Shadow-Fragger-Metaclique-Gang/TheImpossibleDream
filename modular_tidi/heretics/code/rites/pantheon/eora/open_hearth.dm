/datum/runeritual/god/eora/open_hearth
	name = "Rite of the Open Hearth"
	desc = "Binds an Eoran beside the rune to the calming aura."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/eora/open_hearth/perform(mob/living/user, obj/structure/ritualcircle/eora/circle)
	var/onrune = view(1, circle.loc)
	var/list/folksonrune = list()
	for(var/mob/living/carbon/human/persononrune in onrune)
		if(HAS_TRAIT(persononrune, TRAIT_EXTEROCEPTION))//Only works on Eorans
			folksonrune += persononrune
	var/target = input(user, "Choose a host") as null|anything in folksonrune
	if(!target)
		return FALSE
	user.say("I stand before you Mother to beg your ear and swear an oath!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("To stoke no anguish! To cause no pain!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("To mend what is frayed and redeem what has strayed!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("To shelter the lost and warm the forgotten!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	var/mob/living/carbon/human/host = target
	if(!HAS_TRAIT(host, TRAIT_EXTEROCEPTION))
		deny(user, circle, "[host] lacks the pure heart this oath demands.")
		return FALSE
	circle.icon_state = "eora_active"
	circle.eoranaura(target)
	addtimer(VARSET_CALLBACK(circle, icon_state, "eora_chalky"), 12 SECONDS)
	return TRUE
