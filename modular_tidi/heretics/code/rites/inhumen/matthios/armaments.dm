/datum/runeritual/god/matthios/armaments
	name = "Rite of Armaments"
	desc = "Clads the Freeman standing upon the rune in gilded armor and teaches them the flail."
	layout = list(
		"NW" = list(/obj/item/roguecoin/gold, /obj/item/roguecoin/silver),
		"NE" = list(/obj/item/roguecoin/gold, /obj/item/roguecoin/silver),
		"W" = /obj/item/ingot/steel,
		"C" = /mob/living/carbon/human,
		"E" = /obj/item/ingot/steel,
		"S" = list(
			/obj/item/clothing/ring/gold,
			/obj/item/clothing/ring/silver,
			/obj/item/clothing/ring/band/gold,
			/obj/item/reagent_containers/glass/cup/golden,
			/obj/item/reagent_containers/glass/cup/silver,
			/obj/item/reagent_containers/glass/carafe/gold,
			/obj/item/reagent_containers/glass/carafe/silver,
			/obj/item/ingot/gold,
			/obj/item/ingot/silver,
		), // Something kind of expensive
	)
	tier = SKILL_LEVEL_EXPERT
	cooldown = 30 MINUTES

/datum/runeritual/god/matthios/armaments/perform(mob/living/user, obj/structure/ritualcircle/matthios/circle)
	if(!check_layout(user, circle))
		return FALSE
	var/list/hosting = match_layout(circle)
	var/mob/living/carbon/human/target = hosting["C"]
	if(!HAS_TRAIT(target, TRAIT_FREEMAN))
		deny(user, circle, "[target] is no Freeman.")
		return FALSE
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Gold and Silver, He feeds!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Pieces o' tens, hundreds, thousands; o', the Flame feeds 'pon them all!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("Arms to claim, Arms to TAAAAAAAKE!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	var/list/selected_atoms = check_layout(user, circle)
	if(!selected_atoms)
		return FALSE
	if(selected_atoms["C"] != target)
		deny(user, circle, "The arrangement was disturbed, and the rite falls apart.")
		return FALSE
	cleanup_atoms(selected_atoms)
	circle.icon_state = "matthios_active"
	circle.matthiosarmaments(target)
	addtimer(VARSET_CALLBACK(circle, icon_state, "matthios_chalky"), 12 SECONDS)
	return TRUE
