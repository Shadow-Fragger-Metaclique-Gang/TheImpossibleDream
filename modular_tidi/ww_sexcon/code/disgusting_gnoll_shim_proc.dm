//Gnoll genitals shim, called at the beginning and end of a gnoll equip becuase becoming a gnoll strips your organs and I don't actually know how to check someone's preferences.

/datum/outfit/job/roguetown/proc/disgusting_gnoll_shim_proc(mob/living/carbon/C, list/mygenitals)
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
