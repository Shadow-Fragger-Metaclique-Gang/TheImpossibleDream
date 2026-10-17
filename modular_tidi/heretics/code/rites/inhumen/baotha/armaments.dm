/datum/runeritual/god/baotha/armaments
	name = "Rite of Armaments"
	desc = "Clads the one of the Depraved standing upon the rune in saccharine armor, numbs their pain and teaches them the polearm."
	layout = list(
		"NW" = /obj/item/reagent_containers/powder,
		"NE" = /obj/item/reagent_containers/powder,
		"W" = /obj/item/ingot/steel,
		"C" = /mob/living/carbon/human,
		"E" = /obj/item/ingot/steel,
		"S" = /obj/effect/decal/cleanable/coom, // Lmao
	)
	banned_atom_types = list(
		/obj/item/reagent_containers/powder/flour,
		/obj/item/reagent_containers/powder/salt,
		/obj/item/reagent_containers/powder/rocknut,
		/obj/item/reagent_containers/powder/coarse_salt,
		/obj/item/reagent_containers/powder/mineral,
		/obj/item/reagent_containers/powder/black_ichor,
	)
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/baotha/armaments/perform(mob/living/user, obj/structure/ritualcircle/baotha/circle)
	if(!check_layout(user, circle))
		return FALSE
	var/list/hosting = match_layout(circle)
	var/mob/living/carbon/human/target = hosting["C"]
	if(!HAS_TRAIT(target, TRAIT_DEPRAVED))
		deny(user, circle, "[target] is not among the Depraved.")
		return FALSE
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("OPUS-OPIA, BLESSED WEAVER, ORGASMIC AND EVER-LOVED, HEED MY PLEA OF SUCCOR!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("TAKE THIS CUP FROM ME, ALONE AND BURDENED WITH ANGUISH AND HEARTBREAK...")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("...AND IN ITS STEAD, BESTOW UPON ME... EEEEVEEERRRYTHIIIIIIING!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	var/list/selected_atoms = check_layout(user, circle)
	if(!selected_atoms)
		return FALSE
	if(selected_atoms["C"] != target)
		deny(user, circle, "The arrangement was disturbed, and the rite falls apart.")
		return FALSE
	cleanup_atoms(selected_atoms)
	circle.icon_state = "baotha_active"
	ADD_TRAIT(target, TRAIT_NOPAIN, TRAIT_RITUAL)
	ADD_TRAIT(target, TRAIT_DODGEEXPERT, TRAIT_RITUAL)
	circle.baothaarmaments(target)
	addtimer(VARSET_CALLBACK(circle, icon_state, "baotha_chalky"), 12 SECONDS)
	return TRUE
