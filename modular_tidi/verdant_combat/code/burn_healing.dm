/obj/item/natural/burn_treatment
	name = "burn treatment"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "salt"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_range = 3
	var/uses = 5
	var/heal_amount = 15
	var/burn_damage_heal = 10
	var/specialty_wound
	var/off_type_mult = 1
	var/pain_reduction = 0
	var/specialty_message
	var/apply_sound = 'sound/foley/bandage.ogg'

/obj/item/natural/burn_treatment/examine(mob/user)
	. = ..()
	. += span_info("It has [uses] use\s remaining.")

/obj/item/natural/burn_treatment/attack(mob/living/M, mob/living/user)
	if(!iscarbon(M))
		to_chat(user, span_warning("I can't treat [M] with this!"))
		return
	if(uses <= 0)
		to_chat(user, span_warning("[src] is all used up!"))
		return
	var/obj/item/bodypart/affecting = M.get_bodypart(check_zone(user.zone_selected))
	if(!affecting)
		to_chat(user, span_warning("I can't find that bodypart!"))
		return
	var/list/burns = list()
	for(var/datum/wound/wound as anything in affecting.wounds)
		if(istype(wound, /datum/wound/burn) || istype(wound, /datum/wound/dynamic/burn))
			burns += wound
	if(!length(burns) && affecting.burn_dam <= 0)
		to_chat(user, span_warning("[M]'s [affecting.name] has no burns to treat!"))
		return
	user.visible_message(span_notice("[user] applies [src] to [M]'s [affecting.name]."), span_notice("I apply [src] to [M]'s [affecting.name]."))
	playsound(user, apply_sound, 100, FALSE)
	for(var/datum/wound/burn as anything in burns)
		if(specialty_wound && istype(burn, specialty_wound))
			burn.woundpain = max(burn.woundpain - pain_reduction, 5)
			burn.heal_wound(heal_amount)
			if(specialty_message)
				to_chat(M, span_nicegreen(specialty_message))
		else
			burn.heal_wound(heal_amount * off_type_mult)
	affecting.heal_damage(0, burn_damage_heal)
	if(length(burns) && !specialty_wound)
		to_chat(M, span_nicegreen("The salve soothes my burns."))
	uses--
	if(uses <= 0)
		to_chat(user, span_warning("[src] is used up."))
		qdel(src)
	return TRUE

/obj/item/natural/burn_treatment/salve
	name = "burn salve"
	desc = "A waxy ointment made from healing herbs. Soothes burns and promotes healing."
	color = "#f5deb3"

/obj/item/natural/burn_treatment/warming_poultice
	name = "warming poultice"
	desc = "A heated compress infused with spices. Restores circulation to frostbitten flesh."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "cloth"
	color = "#ff8c00"
	uses = 3
	heal_amount = 20
	burn_damage_heal = 12
	specialty_wound = /datum/wound/burn/frostbite
	off_type_mult = 0.5
	specialty_message = "Warmth returns to my frozen flesh!"

/obj/item/natural/burn_treatment/neutralizing_powder
	name = "neutralizing powder"
	desc = "A fine alkaline powder. Neutralizes acids and soothes chemical burns."
	color = "#e0e0e0"
	uses = 4
	heal_amount = 18
	specialty_wound = /datum/wound/burn/acid
	off_type_mult = 0.6
	pain_reduction = 5
	specialty_message = "The acid burn stops stinging!"
	apply_sound = 'sound/items/seedextract.ogg'

/obj/item/natural/cloth/burn_bandage
	name = "medicated bandage"
	desc = "A cloth treated with soothing aloe. Effective on burns but less so on bleeding wounds."
	bandage_effectiveness = 0.6
	color = "#c8dcc8"
	var/burn_heal_bonus = 8

/obj/item/natural/cloth/burn_bandage/examine(mob/user)
	. = ..()
	. += span_info("Especially effective against burns.")

/obj/item/bodypart/try_bandage(obj/item/new_bandage)
	. = ..()
	if(!. || !istype(new_bandage, /obj/item/natural/cloth/burn_bandage))
		return
	var/obj/item/natural/cloth/burn_bandage/burn_bandage = new_bandage
	for(var/datum/wound/wound as anything in wounds?.Copy())
		if(istype(wound, /datum/wound/burn) || istype(wound, /datum/wound/dynamic/burn))
			wound.heal_wound(burn_bandage.burn_heal_bonus)

/datum/crafting_recipe/roguetown/alchemy/burn_salve
	name = "burn salve"
	result = /obj/item/natural/burn_treatment/salve
	reqs = list(/obj/item/alch/berrypowder = 2, /obj/item/reagent_containers/food/snacks/fat = 1)
	craftdiff = 0
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/alchemy/burn_salve_swampweed
	name = "burn salve (swampweed)"
	result = /obj/item/natural/burn_treatment/salve
	reqs = list(/obj/item/alch/swampdust = 2, /obj/item/reagent_containers/food/snacks/fat = 1)
	craftdiff = 0
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/alchemy/warming_poultice
	name = "warming poultice"
	result = /obj/item/natural/burn_treatment/warming_poultice
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/reagent_containers/powder/salt = 1, /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	craftdiff = 1
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/alchemy/neutralizing_powder
	name = "neutralizing powder"
	result = /obj/item/natural/burn_treatment/neutralizing_powder
	reqs = list(/obj/item/natural/ash = 2, /obj/item/reagent_containers/powder/salt = 1)
	craftdiff = 0
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/alchemy/neutralizing_powder_bone
	name = "neutralizing powder (bone)"
	result = /obj/item/natural/burn_treatment/neutralizing_powder
	reqs = list(/obj/item/alch/bonemeal = 1, /obj/item/natural/ash = 1)
	craftdiff = 1
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/alchemy/burn_bandage
	name = "burn-cleansing bandage"
	result = /obj/item/natural/cloth/burn_bandage
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/alch/berrypowder = 1)
	craftdiff = 0
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/alchemy/burn_bandage_swampweed
	name = "burn-cleansing bandage (swampweed)"
	result = /obj/item/natural/cloth/burn_bandage
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/alch/swampdust = 1)
	craftdiff = 0
	subtype_reqs = TRUE
