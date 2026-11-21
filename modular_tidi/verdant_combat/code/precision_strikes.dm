GLOBAL_LIST_INIT(precision_vulnerable_zones, list(BODY_ZONE_L_ARM = 5,
										BODY_ZONE_R_ARM = 5,
										BODY_ZONE_L_LEG = 5,
										BODY_ZONE_R_LEG = 5,
										BODY_ZONE_PRECISE_NECK = 15,
										BODY_ZONE_PRECISE_L_EYE = 20,
										BODY_ZONE_PRECISE_R_EYE = 20,
										BODY_ZONE_PRECISE_GROIN = 10))

/obj/item
	var/can_precision_strike = FALSE

/mob/living
	var/last_attack_was_blunted = FALSE

/datum/intent
	var/never_penetrates = FALSE

/proc/melee_armor_penetration(obj/item/I, mob/living/user)
	if(user.used_intent?.never_penetrates)
		return 0
	var/pen = I.armor_penetration
	if(I.d_type == "blunt")
		pen = BLUNT_DEFAULT_PENFACTOR
	else
		pen += (user.used_intent?.penfactor || 0) * INTENT_BASE_AP
#ifdef COMBAT_TEST_TUNING
	var/stat_delta = 0
	switch(I.wbalance)
		if(WBALANCE_HEAVY)
			stat_delta = user.STASTR - 10
		if(WBALANCE_NORMAL)
			stat_delta = ((user.STASTR - 10) + (user.STAPER - 10)) / 2
		if(WBALANCE_SWIFT)
			stat_delta = user.STAPER - 10
	pen *= 1 + stat_delta * AP_STAT_SCALING
#else
	var/stat_ap_multiplier = 1.0
	if(user.used_intent?.penfactor)
		stat_ap_multiplier = user.used_intent.penfactor
	switch(I.wbalance)
		if(WBALANCE_HEAVY)
			pen += (user.STASTR - 10) * STR_PEN_FACTOR * stat_ap_multiplier
		if(WBALANCE_NORMAL)
			pen += (((user.STASTR - 10) + (user.STAPER - 10)) / 2) * floor((STR_PEN_FACTOR + PER_PEN_FACTOR) / 2) * stat_ap_multiplier
		if(WBALANCE_SWIFT)
			pen += (user.STAPER - 10) * PER_PEN_FACTOR * stat_ap_multiplier
#endif
	return max(pen, 0)

/obj/item/proc/can_do_precision_strikes()
	if(wbalance == WBALANCE_HEAVY && !can_precision_strike)
		return FALSE
	for(var/intent in possible_item_intents)
		var/blade_class = ispath(intent, /datum/intent) ? initial(intent:blade_class) : (istype(intent, /datum/intent) ? intent:blade_class : null)
		if(blade_class in GLOB.stab_bclasses)
			return TRUE
	return FALSE

/obj/item/examine(mob/user)
	. = ..()
	if(item_flags & GIANT_WEAPON)
		. += span_warning("This weapon is designed for giants. Those without giant strength will require double the normal strength to wield it effectively.")
	if(force && can_do_precision_strikes())
		. += span_info("This weapon can perform precision thrusts through the gaps in heavy armor.")

/proc/precision_strike_chance(pen, rating, zone_penalty, skill_level, grappling, wlength, wbalance, can_precision_strike, attacker_per, target_spd, target_con)
	var/precision_chance = max(pen - rating - zone_penalty, 0)
	precision_chance += skill_level * 10
	if(grappling && (wbalance == WBALANCE_SWIFT || can_precision_strike))
		precision_chance += 50
	if(wlength > WLENGTH_SHORT && !can_precision_strike)
		precision_chance -= 10 * wlength
	if(wbalance == WBALANCE_NORMAL && !can_precision_strike)
		precision_chance -= 25
	precision_chance += (attacker_per - 10) * 5
	precision_chance -= max(target_spd, target_con)
	return clamp(precision_chance, 1, 95)

/mob/living/carbon/human/proc/try_precision_strike(obj/item/I, mob/living/user, selzone, bladec, pen)
	var/list/bypassed_armors = list()
	if(!((I.wbalance != WBALANCE_HEAVY || I.can_precision_strike) && (bladec in GLOB.stab_bclasses)))
		return bypassed_armors
	if(!user.cmode || !istype(user.rmb_intent, /datum/rmb_intent/aimed))
		return bypassed_armors
	if(!(selzone in GLOB.precision_vulnerable_zones))
		return bypassed_armors
	var/obj/item/clothing/outer_armor = get_best_armor(selzone, I.d_type, bladec, pen, user)
	if(!outer_armor)
		return bypassed_armors
	var/armor_class = outer_armor.armor_class == ARMOR_CLASS_NONE && outer_armor.integ_armor_mod != ARMOR_CLASS_NONE ? outer_armor.integ_armor_mod : outer_armor.armor_class
	if(!(armor_class == ARMOR_CLASS_HEAVY || (istype(outer_armor, /obj/item/clothing/head/roguetown/helmet) && (outer_armor.flags_cover & HEADCOVERSEYES))))
		return bypassed_armors
	var/precision_chance = 100
	var/guaranteed_strike = FALSE
	if(!cmode || incapacitated() || IsImmobilized())
		guaranteed_strike = TRUE
	else
		var/grappling = (user in grabbedby) || (src in user.grabbedby)
		precision_chance = precision_strike_chance(pen, outer_armor.armor.getRating(I.d_type), GLOB.precision_vulnerable_zones[selzone], I.associated_skill ? user.get_skill_level(I.associated_skill) : 0, grappling, I.wlength, I.wbalance, I.can_precision_strike, user.STAPER, STASPD, STACON)
	if(user.client?.prefs?.showrolls)
		to_chat(user, span_info("Precision strike: [precision_chance]%"))
	if(!prob(precision_chance))
		visible_message(span_warning("[user] attempts to strike through a gap in [src]'s armor, but fails!"), span_warning("[user] searches for a gap in my armor, but fails to find one!"))
		user.filtered_balloon_alert(TRAIT_COMBAT_AWARE, "No gap!")
		return bypassed_armors
	bypassed_armors += outer_armor
	if(!(outer_armor.body_parts_covered & CHEST))
		if(wear_armor && outer_armor != wear_armor)
			bypassed_armors += wear_armor
	switch(selzone)
		if(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM)
			var/obj/item/clothing/wrists = wear_wrists
			if(istype(wrists) && wrists != outer_armor && (wrists.armor_class == ARMOR_CLASS_HEAVY || wrists.integ_armor_mod == ARMOR_CLASS_HEAVY))
				bypassed_armors += wrists
		if(BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_GROIN)
			var/obj/item/clothing/pants = wear_pants
			if(istype(pants) && pants != outer_armor && (pants.armor_class == ARMOR_CLASS_HEAVY || pants.integ_armor_mod == ARMOR_CLASS_HEAVY))
				bypassed_armors += pants
		if(BODY_ZONE_PRECISE_NECK)
			var/obj/item/clothing/neck = wear_neck
			if(istype(neck) && neck != outer_armor && (neck.armor_class == ARMOR_CLASS_HEAVY || neck.integ_armor_mod == ARMOR_CLASS_HEAVY))
				bypassed_armors += neck
		if(BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_R_EYE)
			var/obj/item/clothing/helm = head
			if(istype(helm) && helm != outer_armor && (helm.armor_class == ARMOR_CLASS_HEAVY || helm.integ_armor_mod == ARMOR_CLASS_HEAVY))
				bypassed_armors += helm
	if(guaranteed_strike)
		visible_message(span_danger("[user] effortlessly strikes through a gap in [src]'s armor! [p_theyre()] defenseless!"), span_userdanger("[user] effortlessly finds a gap in my armor! I'm defenseless!"))
		user.filtered_balloon_alert(TRAIT_COMBAT_AWARE, "Auto gap!")
	else
		visible_message(span_danger("[user] strikes through a gap in [src]'s armor!"), span_userdanger("[user] finds a gap in my armor!"))
		user.filtered_balloon_alert(TRAIT_COMBAT_AWARE, "Gap found!")
	return bypassed_armors

/obj/item/rogueweapon/sword/long
	can_precision_strike = TRUE

/obj/item/rogueweapon/greatsword
	can_precision_strike = TRUE

/obj/item/rogueweapon/estoc
	can_precision_strike = TRUE

/mob/living/proc/armor_sounded_blunted_hit()
	last_attack_was_blunted = FALSE
	return FALSE

/mob/living/carbon/human/armor_sounded_blunted_hit()
	if(!last_attack_was_blunted)
		return FALSE
	last_attack_was_blunted = FALSE
	var/obj/item/clothing/struck = last_armor_hit?.resolve()
	return !!struck?.blocksound

/proc/limb_smash_penetration(mob/living/user)
	return max(BLUNT_DEFAULT_PENFACTOR * (user.STASTR - 10), 0)
