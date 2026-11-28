
/datum/sex_controller/update_erect_state()
	..()
	if(user.mind)
		var/datum/antagonist/werewolf/W = user.mind.has_antag_datum(/datum/antagonist/werewolf/)
		if(W && W.transformed == TRUE)
			user.regenerate_icons()

/datum/species/werewolf/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'modular_tidi/sexcon/icons/werewolf.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	if(H.gender == MALE)
		H.icon_state = "wwolf_m"
	else
		H.icon_state = "wwolf_f"
	if(H.getorganslot(ORGAN_SLOT_PENIS)) //gock compatible
		if(H.sexcon.arousal >= 20 && H.sexcon.manual_arousal == 1 || H.sexcon.manual_arousal == 4)
			H.icon_state = "wwolf_m-e"
		else if(H.sexcon.arousal >= 10 && H.sexcon.manual_arousal == 1 || H.sexcon.manual_arousal == 3)
			H.icon_state = "wwolf_m-p"
		else
			H.icon_state = "wwolf_m"
	H.update_damage_overlays()
	return TRUE
//Gnoll genitals shim, called at the beginning and end of a gnoll equip becuase becoming a gnoll strips your organs and I don't actually know how to check someone's preferences.

/datum/outfit/job/roguetown/proc/add_gnoll_sexcon(mob/living/carbon/C, list/mygenitals)
	if(!mygenitals)
		mygenitals = list()
		if(C.getorganslot(ORGAN_SLOT_PENIS))
			mygenitals[ORGAN_SLOT_PENIS] = TRUE
		if(C.getorganslot(ORGAN_SLOT_TESTICLES))
			mygenitals[ORGAN_SLOT_TESTICLES] = TRUE
		if(C.getorganslot(ORGAN_SLOT_BREASTS))
			mygenitals[ORGAN_SLOT_BREASTS] = TRUE
		if(C.getorganslot(ORGAN_SLOT_VAGINA))
			mygenitals[ORGAN_SLOT_VAGINA] = TRUE
		return mygenitals
	else
		if(mygenitals[ORGAN_SLOT_PENIS])
			var/obj/item/organ/penis/barbed_knotted/big/knot = new
			knot.Insert(C, TRUE, TRUE)
		if(mygenitals[ORGAN_SLOT_TESTICLES])
			var/obj/item/organ/testicles/balls = new
			balls.Insert(C, TRUE, TRUE)
		if(mygenitals[ORGAN_SLOT_BREASTS])
			var/obj/item/organ/breasts/boobs = new
			boobs.Insert(C, TRUE, TRUE)
		if(mygenitals[ORGAN_SLOT_VAGINA])
			var/obj/item/organ/vagina/pussy = new
			pussy.Insert(C, TRUE, TRUE)
//	C.regenerate_icons() //TODO: sprites
	ADD_TRAIT(C, TRAIT_DEATHBYSNUSNU, TRAIT_GENERIC)
