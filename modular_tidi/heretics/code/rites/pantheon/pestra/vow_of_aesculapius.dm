/datum/runeritual/god/pestra/vow_of_aesculapius
	name = "Vow of Aesculapius"
	desc = "Binds a Pestran beside the rune with journeyman miracles or better to the plaguebringer aura."
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/pestra/vow_of_aesculapius/perform(mob/living/user, obj/structure/ritualcircle/pestra/circle)
	var/onrune = view(1, circle.loc)
	var/list/folksonrune = list()
	for(var/mob/living/carbon/human/persononrune in onrune)
		if(HAS_TRAIT(persononrune, TRAIT_ROT_EATER))
			folksonrune += persononrune
	var/target = input(user, "Choose a host") as null|anything in folksonrune
	if(!target)
		return FALSE
	user.say("Before your greatness, I swear a vow!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("To do no harm!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("To take care of those in need!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("To be your shining beacon in the darkness!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	var/mob/living/carbon/human/host = target
	if(!HAS_TRAIT(host, TRAIT_ROT_EATER) || host.get_skill_level(/datum/skill/magic/holy) < SKILL_LEVEL_JOURNEYMAN)
		deny(user, circle, "[host] lacks the pure heart this vow demands.")
		return FALSE
	circle.icon_state = "pestra_active"
	circle.pestraaura(target)
	addtimer(VARSET_CALLBACK(circle, icon_state, "pestra_chalky"), 12 SECONDS)
	return TRUE
