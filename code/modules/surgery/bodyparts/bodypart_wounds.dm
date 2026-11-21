/obj/item/bodypart
	/// List of /datum/wound instances affecting this bodypart
	var/list/datum/wound/wounds
	/// List of items embedded in this bodypart
	var/list/obj/item/embedded_objects = list()
	/// Bandage, if this ever hard dels thats fucking silly lol
	var/obj/item/bandage

/// Checks if we have any embedded objects whatsoever
/obj/item/bodypart/proc/has_embedded_objects()
	return length(embedded_objects)

/// Checks if we have an embedded object of a specific type
/obj/item/bodypart/proc/has_embedded_object(path, specific = FALSE)
	if(!path)
		return
	for(var/obj/item/embedder as anything in embedded_objects)
		if((specific && embedder.type != path) || !istype(embedder, path))
			continue
		return embedder

/// Checks if an object is embedded in us
/obj/item/bodypart/proc/is_object_embedded(obj/item/embedder)
	if(!embedder)
		return FALSE
	return (embedder in embedded_objects)

/// Returns all wounds on this limb that can be sewn
/obj/item/bodypart/proc/get_sewable_wounds()
	var/list/woundies = list()
	for(var/datum/wound/wound as anything in wounds)
		if(wound == null)
			listclearnulls(wounds) //Putting this somewhere useful but low intensity
			continue
		if(!wound.can_sew)
			continue
		woundies += wound
	return woundies

/// Returns the first wound of the specified type on this bodypart
/obj/item/bodypart/proc/has_wound(path, specific = FALSE)
	if(!path)
		return
	for(var/datum/wound/wound as anything in wounds)
		if((specific && wound.type != path) || !istype(wound, path))
			continue
		return wound

/// Heals wounds on this bodypart by the specified amount
/obj/item/bodypart/proc/heal_wounds(heal_amount)
	if(!length(wounds))
		return FALSE
	if(HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && owner.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || owner.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
		return
	var/healed_any = FALSE
	for(var/datum/wound/wound as anything in wounds)
		if(heal_amount <= 0)
			continue
		var/amount_healed = wound.heal_wound(heal_amount)
		heal_amount -= amount_healed
		healed_any = TRUE
	return healed_any

/// Adds a wound to this bodypart, applying any necessary effects
// [SURREALIS-EDIT] - VRCOMBAT
// /obj/item/bodypart/proc/add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE) // SURREALIS-EDIT - ORIGINAL
/obj/item/bodypart/proc/add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE, damage, mob/living/user, obj/item/weapon)
// [/SURREALIS-EDIT]
	if(!wound || !owner || (owner.status_flags & GODMODE))
		return
	if(isooze(owner) && wound.severity >= WOUND_SEVERITY_MODERATE) // Handles wounds for murklings.
		if(ispath(wound, /datum/wound))
			wound = new wound()
		if(is_ooze_wound(wound))
			handle_ooze_wounds(wound, silent, crit_message)
			return
	// [SURREALIS-EDIT] - VRCOMBAT
	// if(ispath(wound, /datum/wound)) // SURREALIS-EDIT - ORIGINAL
	if(ispath(wound, /datum/wound/lethal))
		wound = new wound(damage)
	else if(ispath(wound, /datum/wound))
	// [/SURREALIS-EDIT]
		var/datum/wound/primordial_wound = GLOB.primordial_wounds[wound]
		if(!primordial_wound.can_apply_to_bodypart(src))
			return
		wound = new wound()
	else if(!istype(wound))
		return
	if(!wound.can_apply_to_bodypart(src))
		qdel(wound)
		return
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	/*
	if(!wound.apply_to_bodypart(src, silent, crit_message))
		qdel(wound)
		return
	*/
	if(!wound.apply_to_bodypart(src, silent, crit_message, damage))
		qdel(wound)
		return
	// [/SURREALIS-EDIT]
	return wound

/// Removes a wound from this bodypart, removing any associated effects
/obj/item/bodypart/proc/remove_wound(datum/wound/wound)
	if(ispath(wound))
		wound = has_wound(wound)
	if(!istype(wound))
		return FALSE
	. = wound.remove_from_bodypart()
	if(.)
		qdel(wound)

/// Check to see if we can apply a bleeding wound on this bodypart
/obj/item/bodypart/proc/can_bloody_wound()
	if(skeletonized)
		return FALSE
	if(!is_organic_limb())
		return FALSE
	if(NOBLOOD in owner?.dna?.species?.species_traits)
		return FALSE
	return TRUE

/// Returns the total bleed rate on this bodypart
/obj/item/bodypart/proc/get_bleed_rate()
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	// var/bleed_rate = bleeding
	// if(bandage && !HAS_BLOOD_DNA(bandage))
	// 	var/obj/item/natural/cloth/cloth = bandage
	// 	bleed_rate *= cloth.bandage_effectiveness
	// 	if(bleed_rate <= 1) //if the bleeding is below this after being bandaged, bleeding stops completely
	// 		return 0
	// 	return bleed_rate
	// /*
	// for(var/datum/wound/wound in wounds)
	// 	if(istype(wound, /datum/wound))
	// 		bleed_rate += wound.bleed_rate*/
	if(bandage && !HAS_BLOOD_DNA(bandage))
		try_bandage_expire()
		return 0
	var/bleed_rate = bleeding
	// [/SURREALIS-EDIT]
	// [SURREALIS-ADD] - PLASMA_OPTS
	if(!bleed_rate && !length(embedded_objects))
		grabbedby = SANITIZE_LIST(grabbedby)
		return 0
	// [/SURREALIS-ADD]
	for(var/obj/item/embedded as anything in embedded_objects)
		if(!embedded.embedding.embedded_bloodloss)
			continue
		bleed_rate += embedded.embedding.embedded_bloodloss

	grabbedby = SANITIZE_LIST(grabbedby)
	for(var/obj/item/grabbing/grab in grabbedby)
		bleed_rate *= grab.bleed_suppressing
	bleed_rate = max(round(bleed_rate, 0.1), 0)
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	// 	// temporarily disabling below because it is niche use and a LOT of performance drain
	// 	/*var/surgery_flags = get_surgery_flags()
	// 	if(surgery_flags & SURGERY_CLAMPED)
	// 		return min(bleed_rate, 0.5)*/
	// 	return bleed_rate
	//
	// /// Called after a bodypart is attacked so that wounds and critical effects can be applied
	// /obj/item/bodypart/proc/bodypart_attacked_by(bclass = BCLASS_BLUNT, dam, mob/living/user, zone_precise = src.body_zone, silent = FALSE, crit_message = FALSE, armor, obj/item/weapon, pen_info, no_crit = FALSE, no_debuff = FALSE)
	if(is_clamped())
		return min(bleed_rate, 0.5)
	return bleed_rate

/// Returns TRUE if this bodypart has an effective bandage
/obj/item/bodypart/proc/is_bandaged()
	return bandage && !HAS_BLOOD_DNA(bandage)

/// Called after a bodypart is attacked so that wounds and critical effects can be applied
/obj/item/bodypart/proc/bodypart_attacked_by(bclass = BCLASS_BLUNT, dam, mob/living/user, zone_precise = src.body_zone, silent = FALSE, crit_message = FALSE, armor, was_blunted = FALSE, raw_damage = 0, armor_block = 0, obj/item/weapon, no_crit = FALSE, no_debuff = FALSE)
	// [/SURREALIS-EDIT]
	RETURN_TYPE(/datum/wound)
	if(!bclass || !dam || !owner || (owner.status_flags & GODMODE))
		return null
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	/*
	var/do_crit = TRUE
	var/debuff_applies = !no_debuff && !istype(weapon, /obj/projectile)
	var/acheck_dflag = bclass_to_armor_rating(bclass)
	if(!armor)
		armor = owner.run_armor_check(zone_precise, acheck_dflag, damage = 0)
	if(ishuman(owner) && bclass != BCLASS_PICK)
		var/mob/living/carbon/human/H = owner
		var/obj/item/clothing/worn_armor = H.get_best_worn_armor(zone_precise, acheck_dflag)
		if(worn_armor && !worn_armor.obj_broken)
			var/ratio = (worn_armor.obj_integrity / worn_armor.max_integrity)
			if(ratio <= CRIT_ARMOUR_THRESHOLD)
				do_crit = TRUE
	if(do_crit && get_damage() <= (max_damage * CRIT_DISMEMBER_DAMAGE_THRESHOLD)) //No crits unless the limb is at 90%+ damage.
		do_crit = FALSE
	if(user)
		if(user.goodluck(2))
			dam += 10
		if(istype(user.rmb_intent, /datum/rmb_intent/weak))
			do_crit = FALSE
	if(no_crit)
		do_crit = FALSE

	var/datum/wound/dynwound = manage_dynamic_wound(bclass, dam, armor, pen_info, debuff_applies)
	*/
	var/do_crit = !no_crit && !crit_immune_to(weapon, bclass)
	var/crit_resistance = 0
	var/debuff_applies = !no_debuff && !istype(weapon, /obj/projectile)
	if(ishuman(owner) && do_crit)
		if(was_blunted)
			do_crit = FALSE
		else if(!(bclass in GLOB.charring_bclasses))
			var/mob/living/carbon/human/human_owner = owner
			crit_resistance = human_owner.checkcritarmor(zone_precise, bclass)
			if(user?.goodluck(2))
				crit_resistance -= user.STALUC * 2

	var/datum/wound/dynwound = manage_dynamic_wound(bclass, dam, armor, user, weapon)
	// [/SURREALIS-EDIT]
	if((bclass in GLOB.splatter_bclasses) && !istype(weapon, /obj/projectile) && prob(dam * 2))
		var/turf/from = get_turf(user || weapon)
		if(from)
			owner.blood_spray(get_dir(from, owner))

	if(do_crit)
		var/datum/component/silverbless/psyblessed = weapon?.GetComponent(/datum/component/silverbless)
		var/sundering = HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && istype(weapon) && weapon?.is_silver && psyblessed?.is_blessed
		// [SURREALIS-EDIT] - VRCOMBAT
		// var/crit_attempt = try_crit(sundering ? BCLASS_SUNDER : bclass, dam, user, zone_precise, silent, crit_message) // SURREALIS-EDIT - ORIGINAL
		var/crit_attempt = try_crit(sundering ? BCLASS_SUNDER : bclass, dam, user, zone_precise, silent, crit_message, raw_damage, armor_block, crit_resistance, was_blunted, weapon)
		// [/SURREALIS-EDIT]
		if(crit_attempt)
			if((bclass in GLOB.gore_bclasses) && istype(crit_attempt, /datum/wound))
				owner.blood_squirt()
			if(bclass == BCLASS_BURN && user && user != owner)
				shake_camera(user, 2, 2)
				flash_color(user, "#a83c1a", 15)
				playsound(user, 'sound/combat/crit.ogg', 70, FALSE)
			if(ishuman(owner))
				var/mob/living/carbon/human/human_owner = owner
				human_owner.hud_used?.stressies?.flick_pain(TRUE)
				var/suppress_attack_blip = FALSE //At 'Always' we're guaranteed to have already emoted due to a successful attack.
				if(user?.client?.prefs?.attack_blip_frequency == ATTACK_BLIP_PREF_ALWAYS || user?.client?.prefs?.attack_blip_frequency == ATTACK_BLIP_PREF_NEVER)
					suppress_attack_blip = TRUE
				if(!suppress_attack_blip)
					if(user)
						user.emote("attack", forced = TRUE)
				if(bclass != BCLASS_BURN)
					human_owner.emote("paincrit", forced = TRUE)

			if(user)
				// [SURREALIS-EDIT] - SEXCON - (New proc in modular_tidi/sexcon/code/overrides/addictions.dm)
				// SURREALIS-EDIT - ORIGINAL
				/*
				if(user.has_flaw(/datum/charflaw/addiction/thrillseeker))
					var/datum/component/arousal/CAR = user.GetComponent(/datum/component/arousal)
					if(CAR)
						user.sate_addiction(/datum/charflaw/addiction/thrillseeker)
						user.add_stress(/datum/stressevent/thrill)
						CAR.ejaculate_special()

				if(owner.has_flaw(/datum/charflaw/addiction/thrillseeker))
					var/datum/component/arousal/CAR = owner.GetComponent(/datum/component/arousal)
					if(CAR)
						owner.sate_addiction(/datum/charflaw/addiction/thrillseeker)
						owner.add_stress(/datum/stressevent/thrill)
						CAR.ejaculate_special()
				*/
				user.sexcon?.thrill_climax()
				owner.sexcon?.thrill_climax()
				// [/SURREALIS-EDIT]

			return crit_attempt
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.hud_used?.stressies?.flick_pain(FALSE)

	if(debuff_applies)
		if(owner?.has_status_effect(/datum/status_effect/debuff/exposed))
			playsound(owner, 'sound/combat/exposed_pop.ogg', 100, TRUE)
			owner.remove_status_effect(/datum/status_effect/debuff/exposed)
			visible_message(span_danger("[src] suffers a savage hit while exposed!"))
			if(!do_crit)	//We aren't already screaming from a crit.
				owner.emote("painmoan", forced = TRUE)
		else if(owner?.has_status_effect(/datum/status_effect/debuff/vulnerable))
			playsound(owner, 'sound/combat/vulnerable_pop.ogg', 100, TRUE)
			owner.remove_status_effect(/datum/status_effect/debuff/vulnerable)
			visible_message(span_combatprimary("[src] is struck while vulnerable!"))
			if(!do_crit)	//We aren't already screaming from a crit.
				owner.emote("pain", forced = TRUE)

	return dynwound

// [SURREALIS-EDIT] - VRCOMBAT
// /obj/item/bodypart/proc/manage_dynamic_wound(bclass, dam, armor, pen_info, debuff_applies = TRUE) // SURREALIS-EDIT - ORIGINAL
/obj/item/bodypart/proc/manage_dynamic_wound(bclass, dam, armor, mob/living/user, obj/item/weapon)
// [/SURREALIS-EDIT]
	var/woundtype
	switch(bclass)
		if(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PUNCH, BCLASS_TWIST)
			woundtype = /datum/wound/dynamic/bruise
		if(BCLASS_BITE)
			woundtype = /datum/wound/dynamic/bite
		if(BCLASS_CHOP, BCLASS_CUT)
			woundtype = /datum/wound/dynamic/slash
		if(BCLASS_STAB)
			woundtype = /datum/wound/dynamic/puncture
		if(BCLASS_PICK, BCLASS_PIERCE)
			woundtype = /datum/wound/dynamic/gouge
		// [SURREALIS-EDIT] - VRCOMBAT
		// if(BCLASS_BURN) // SURREALIS-EDIT - ORIGINAL
		if(BCLASS_BURN, BCLASS_FROST, BCLASS_ELECTRICAL, BCLASS_ACID)
		// [/SURREALIS-EDIT]
			woundtype = /datum/wound/dynamic/burn
		if(BCLASS_LASHING)
			woundtype = /datum/wound/dynamic/lashing
		if(BCLASS_PUNISH)
			woundtype = /datum/wound/dynamic/punish
		else	//Wrong bclass type for wounds, skip adding this.
			return
	if(isooze(owner) && is_ooze_wound(woundtype))
		woundtype = /datum/wound/dynamic/ooze
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	/*
	var/datum/wound/dynwound = has_wound(woundtype)
	var/exposed = debuff_applies && owner.has_status_effect(/datum/status_effect/debuff/exposed)
	if(!isnull(dynwound))
		dynwound.upgrade(dam, armor, exposed, pen_info)
	else
		if(ispath(woundtype) && woundtype)
			if(!isnull(woundtype))
				var/datum/wound/newwound = add_wound(woundtype)
				dynwound = newwound
				if(newwound && !isnull(newwound))	//don't even ask - Free
					owner.visible_message(span_red("A new [newwound.name] appears on [owner]'s [LOWER_TEXT(bodyzone2readablezone(bodypart_to_zone(newwound.bodypart_owner)))]!"))
					newwound.upgrade(dam, armor, exposed, pen_info)
	return dynwound

/// Behemoth of a proc used to apply a wound after a bodypart is damaged in an attack
/obj/item/bodypart/proc/try_crit(bclass = BCLASS_BLUNT, dam, mob/living/user, zone_precise = src.body_zone, silent = FALSE, crit_message = FALSE)
	*/

	var/list/worsenable_wounds = list()
	var/list/same_type_wounds = list()
	for(var/datum/wound/dynamic/existing in wounds)
		if(!istype(existing, woundtype))
			continue
		same_type_wounds += existing
		if(existing.can_worsen(dam))
			worsenable_wounds += existing
	if(length(worsenable_wounds) && prob(clamp(50 + (length(same_type_wounds) - 1) * 10, 50, 90)))
		var/datum/wound/dynamic/target = pick(worsenable_wounds)
		target.upgrade(dam, armor)
		return target

	var/datum/wound/dynamic/newwound = add_wound(woundtype, FALSE, FALSE, dam, user, weapon)
	if(!newwound)
		return null
	if(!newwound.silent_progress)
		owner.visible_message(span_red("A new [newwound.name] appears on [owner]'s [LOWER_TEXT(bodyzone2readablezone(bodypart_to_zone(newwound.bodypart_owner)))]!"))
	newwound.upgrade(dam, armor)
	if(!istype(newwound, /datum/wound/dynamic/burn) && newwound.bleed_rate > 0)
		check_wound_infection(newwound, user, weapon)
	for(var/datum/wound/dynamic/existing as anything in same_type_wounds)
		if(existing.can_merge(newwound))
			existing.merge_wound(newwound)
			return existing
	return newwound

/obj/item/bodypart/proc/apply_crit_wounds(list/attempted_wounds, silent, crit_message, dam, mob/living/user, obj/item/weapon)
	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message, dam, user, weapon)
		if(applied)
			if(user?.client)
				record_round_statistic(STATS_CRITS_MADE)
			return applied
	return FALSE

/// Behemoth of a proc used to apply a wound after a bodypart is damaged in an attack
/obj/item/bodypart/proc/try_crit(bclass = BCLASS_BLUNT, dam, mob/living/user, zone_precise = src.body_zone, silent = FALSE, crit_message = FALSE, raw_damage = 0, armor_block = 0, armor_resistance = 0, was_blunted = FALSE, obj/item/weapon)
	// [/SURREALIS-EDIT]
	if(!bclass || !dam || (owner.status_flags & GODMODE))
		return FALSE
	var/list/attempted_wounds = list()
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	/*
	var/used
	var/total_dam = get_damage()
	var/damage_dividend = (total_dam / max_damage)

	if(user && dam)
		if(user.goodluck(2))
			dam += 10
	if(bclass in GLOB.charring_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(prob(used))
			attempted_wounds += /datum/wound/charring
	if(bclass in GLOB.dislocation_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
			used += 10
		if(prob(used))
			if(HAS_TRAIT(src, TRAIT_BRITTLE))
				attempted_wounds += /datum/wound/fracture
			else
				attempted_wounds += /datum/wound/dislocation
	if(bclass in GLOB.fracture_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(user)
			if(istype(user.rmb_intent, /datum/rmb_intent/strong))
				used += 10
		if(HAS_TRAIT(src, TRAIT_BRITTLE))
			used += 10
		if(prob(used))
			if(damage_dividend >= 0.6)
				attempted_wounds += /datum/wound/fracture		//More sevre wound
			else
				attempted_wounds += /datum/wound/dislocation	//Less sevre wound
	if(bclass in GLOB.artery_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(user)
			if((bclass in GLOB.artery_strong_bclasses) && istype(user.rmb_intent, /datum/rmb_intent/strong))
				used += 10
			else if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
				used += 10
		if(prob(used))
			if(HAS_TRAIT(src, TRAIT_IRONMAN))
				attempted_wounds += /datum/wound/integrity
			else
				attempted_wounds += /datum/wound/artery

	if(bclass in GLOB.whipping_bclasses)
		if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
			dam += 10
		if(HAS_TRAIT(src, TRAIT_CRITICAL_WEAKNESS))
			if(HAS_TRAIT(src, TRAIT_IRONMAN))
				attempted_wounds += /datum/wound/integrity
			else
				attempted_wounds += /datum/wound/artery		//basically does sword-tier wounds.
	if((bclass in GLOB.sunder_bclasses))
		if(HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && !owner.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
			used = round(damage_dividend * 20 + (dam / 2))
			if(prob(used))
				attempted_wounds += /datum/wound/sunder
				owner.add_stress(/datum/stressevent/sundercritted) //You're still being sundered, sire.
	// Check if critical resistance applies
	var/has_crit_attempt = length(attempted_wounds)
	if(!has_crit_attempt)
		return FALSE

	if(owner.try_resist_critical())
		if(crit_message)
			owner.next_attack_msg.Cut()
			owner.next_attack_msg += span_crit(" Critical resistance! [owner] resists a wound!</span>")
		return TRUE

	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message)
		if(applied)
			if(user?.client)
				record_round_statistic(STATS_CRITS_MADE)
			return applied
	return FALSE

/obj/item/bodypart/chest/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	*/
	var/damage_dividend = get_damage() / max_damage
	var/resistance = HAS_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE)
	if(user?.goodluck(2))
		dam += 10
	if(bclass == BCLASS_PUNCH && user && HAS_TRAIT(user, TRAIT_CIVILIZEDBARBARIAN))
		dam += 15
	if(dam < owner.STACON * (1 - (damage_dividend * 0.5)))
		return FALSE

	var/strong_bonus = istype(user?.rmb_intent, /datum/rmb_intent/strong) ? 10 : 0
	var/aimed_bonus = istype(user?.rmb_intent, /datum/rmb_intent/aimed) ? 10 : 0
	var/brittle = HAS_TRAIT(src, TRAIT_BRITTLE)
	var/ironman = HAS_TRAIT(owner, TRAIT_IRONMAN)

	if(bclass in GLOB.dislocation_bclasses)
		var/disloc_chance = calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, bonus = strong_bonus)
		attempted_wounds += try_add_crit_wound(brittle ? /datum/wound/fracture : /datum/wound/dislocation, damage_dividend, dam, resistance, disloc_chance, CRIT_LIMB_DISLOCATION_DIVISOR, CRIT_LIMB_DISLOCATION_THRESHOLD)

	if(bclass in GLOB.fracture_bclasses)
		var/frac_chance = calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, bonus = strong_bonus + (brittle ? 10 : 0))
		var/frac_type = (damage_dividend >= CRIT_LIMB_FRACTURE_DIVISOR) ? /datum/wound/fracture : /datum/wound/dislocation
		attempted_wounds += try_add_crit_wound(frac_type, damage_dividend, dam, resistance, frac_chance, CRIT_LIMB_DISLOCATION_DIVISOR, CRIT_LIMB_DISLOCATION_THRESHOLD)

	if(bclass in GLOB.artery_bclasses)
		var/artery_bonus = ((bclass in GLOB.artery_strong_bclasses) && strong_bonus) ? strong_bonus : aimed_bonus
		var/artery_chance = calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, bonus = artery_bonus)
		attempted_wounds += try_add_crit_wound(ironman ? /datum/wound/integrity : /datum/wound/artery, damage_dividend, dam, resistance, artery_chance, CRIT_ARTERY_DIVISOR, CRIT_ARTERY_THRESHOLD)

	if(bclass in GLOB.whipping_bclasses)
		if(strong_bonus)
			dam += 10
		if(HAS_TRAIT(src, TRAIT_CRITICAL_WEAKNESS))
			attempted_wounds += ironman ? /datum/wound/integrity : /datum/wound/artery
		var/scar_chance = calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance)
		attempted_wounds += try_add_crit_wound(/datum/wound/scarring, damage_dividend, dam, resistance, scar_chance, CRIT_SCARRING_DIVISOR, CRIT_SCARRING_THRESHOLD)

	if((bclass in GLOB.sunder_bclasses) && !was_blunted && HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && !owner.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
		if(prob(calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, dam_divisor = 2)))
			attempted_wounds += /datum/wound/sunder
			owner.add_stress(/datum/stressevent/sundercritted)

	if(bclass in GLOB.charring_bclasses)
		var/burn_chance = calculate_crit_chance(damage_dividend, dam, resistance, base_multiplier = 25, dam_divisor = 2.5, resistance_penalty = 12, armor_resistance = armor_resistance)
		attempted_wounds += try_add_crit_wound(elemental_burn_wound(bclass), damage_dividend, dam, resistance, burn_chance, CRIT_BURN_DIVISOR, CRIT_BURN_THRESHOLD)

	listclearnulls(attempted_wounds)
	return apply_crit_wounds(attempted_wounds, silent, crit_message, dam, user, weapon)

/proc/elemental_burn_wound(bclass)
	switch(bclass)
		if(BCLASS_FROST)
			return /datum/wound/burn/frostbite
		if(BCLASS_ELECTRICAL)
			return /datum/wound/burn/electrical
		if(BCLASS_ACID)
			return /datum/wound/burn/acid
	return /datum/wound/burn/charred

/obj/item/bodypart/proc/sunder_stack_crit(used, list/attempted_wounds, wound_type, mob/living/user)
	if(prob(used) && !owner.mind) //mindless always die to one critical sunder
		attempted_wounds += wound_type
	if(prob(used) && owner.sunder_stacks > 100 && owner.mind) //over 100 sunder_stacks opens us to lethality
		attempted_wounds += wound_type
	if(prob(used) && owner.sunder_stacks < 150 && owner.mind) //We don't want too many stacks or we'll never recover.
		owner.sunder_stacks += 40
		owner.visible_message(span_silver("[owner]'s body visibly wilts away at the blow, a blessed sunder!"), span_userdanger("A CRITICAL BLOW SUNDERS ME WITH SACRED FLAME!"))
		owner.add_stress(/datum/stressevent/sundercritted)
	if(user?.mind?.has_antag_datum(/datum/antagonist/vampire) || user?.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
		owner.sunder_stacks += 20 //vamps take (20) additional sunderstacks totaling to 60, this means two strikes will kill a vampire if they strike true.

/obj/item/bodypart/proc/organ_penetration_wound(zone_precise, heart_chance)
	var/is_construct = isconstruct(owner)
	if(zone_precise == BODY_ZONE_CHEST)
		if(prob(heart_chance) && owner.getorganslot(ORGAN_SLOT_HEART))
			return /datum/wound/lethal/heart_penetration
		if(!is_construct && owner.getorganslot(ORGAN_SLOT_LUNGS))
			return /datum/wound/lethal/lung_penetration
	else if(zone_precise == BODY_ZONE_PRECISE_STOMACH && !is_construct)
		if(prob(50) && owner.getorganslot(ORGAN_SLOT_LIVER))
			return /datum/wound/lethal/liver_penetration
		if(owner.getorganslot(ORGAN_SLOT_STOMACH))
			return /datum/wound/lethal/stomach_penetration
	return null

/obj/item/bodypart/chest/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE, raw_damage = 0, armor_block = 0, armor_resistance = 0, was_blunted = FALSE, obj/item/weapon)
	// [/SURREALIS-EDIT]
	if(!bclass || !dam || (owner.status_flags & GODMODE))
		return FALSE
	var/list/attempted_wounds = list()
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	/*
	var/used
	var/total_dam = get_damage()
	var/damage_dividend = (total_dam / max_damage)
	if(user && dam)
		if(user.goodluck(2))
			dam += 10
	if(bclass in GLOB.charring_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(prob(used))
			attempted_wounds += /datum/wound/charring/chest
	if((bclass in GLOB.cbt_classes) && (zone_precise == BODY_ZONE_PRECISE_GROIN))
		var/cbt_multiplier = 1
		if(user && HAS_TRAIT(user, TRAIT_NUTCRACKER))
			cbt_multiplier = 2
		if(prob(round(dam/5) * cbt_multiplier))
			attempted_wounds += /datum/wound/cbt
	*/
	var/damage_dividend = get_damage() / max_damage
	var/resistance = HAS_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE)
	if(user?.goodluck(2))
		dam += 10
	if(dam < owner.STACON * (1 - (damage_dividend * 0.5)))
		return FALSE

	var/strong_bonus = istype(user?.rmb_intent, /datum/rmb_intent/strong) ? 10 : 0
	var/aimed_bonus = istype(user?.rmb_intent, /datum/rmb_intent/aimed) ? 10 : 0
	var/brittle_bonus = HAS_TRAIT(src, TRAIT_BRITTLE) ? 10 : 0
	var/ironman = HAS_TRAIT(owner, TRAIT_IRONMAN)

	if((bclass in GLOB.cbt_classes) && (zone_precise == BODY_ZONE_PRECISE_GROIN))
		var/cbt_multiplier = (user && HAS_TRAIT(user, TRAIT_NUTCRACKER)) ? 2 : 1
		if(!resistance)
			attempted_wounds += try_add_crit_wound(/datum/wound/cbt, damage_dividend, dam, resistance, round(dam / 5) * cbt_multiplier, CRIT_CBT_DIVISOR, CRIT_CBT_THRESHOLD)
	// [/SURREALIS-EDIT]
		if(prob(dam * cbt_multiplier))
			owner.emote("groin", TRUE)
			owner.Stun(10)
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	/*
	if((bclass in GLOB.fracture_bclasses) && (zone_precise != BODY_ZONE_PRECISE_STOMACH))
		used = round(damage_dividend * 20 + (dam / 3))
		if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
			used += 10
		if(HAS_TRAIT(src, TRAIT_BRITTLE))
			used += 10
		var/fracture_type = /datum/wound/fracture/chest
		if(zone_precise == BODY_ZONE_PRECISE_GROIN)
			if(damage_dividend >= 0.7)
				fracture_type = /datum/wound/fracture/groin	//Paralyzes lower body
		if(prob(used))
			attempted_wounds += fracture_type
	if(bclass in GLOB.artery_bclasses)
		used = round(damage_dividend * 20 + (dam / 4))
		if(user)
			if((bclass in GLOB.artery_strong_bclasses) && istype(user.rmb_intent, /datum/rmb_intent/strong))
				used += 10
			else if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
				used += 10
		if(prob(used))
			if(zone_precise == BODY_ZONE_PRECISE_STOMACH)
				if(!HAS_TRAIT(owner, TRAIT_IRONMAN)) // pointless to disembowel them, as they don't die to tox anyway
					attempted_wounds += /datum/wound/slash/disembowel
			if(owner.has_wound(/datum/wound/fracture/chest) || (bclass in GLOB.artery_heart_bclasses) || HAS_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS))
				if(HAS_TRAIT(owner, TRAIT_IRONMAN))
					attempted_wounds += /datum/wound/integrity/chest
				else
					attempted_wounds += /datum/wound/artery/chest
			else
				if(HAS_TRAIT(owner, TRAIT_IRONMAN))
					attempted_wounds += /datum/wound/integrity
				else
					attempted_wounds += /datum/wound/artery
	if(bclass in GLOB.whipping_bclasses)
		used = round(damage_dividend * 20 + (dam / 4))
		if(user)
			if(istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
		if(prob(used))
			if(HAS_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS))
				if(HAS_TRAIT(owner, TRAIT_IRONMAN))
					attempted_wounds += /datum/wound/integrity/chest
				else
					attempted_wounds += /datum/wound/artery/chest
	if(bclass in GLOB.sunder_bclasses)
		if(HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && !owner.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
			used = round(damage_dividend * 20 + (dam / 2))
			if(prob(used) && !owner.mind) //mindless always die to one critical sunder
				attempted_wounds += /datum/wound/sunder/chest
			if(prob(used) && owner.sunder_stacks > 100 && owner.mind) //over 100 sunder_stacks opens us to lethality
				attempted_wounds += /datum/wound/sunder/chest
			if(prob(used) && owner.sunder_stacks < 150 && owner.mind) //We don't want too many stacks or we'll never recover.
				owner.sunder_stacks += 40
				owner.visible_message(span_silver("[owner]'s body visibly wilts away at the blow, a blessed sunder!"), span_userdanger("A CRITICAL BLOW SUNDERS ME WITH SACRED FLAME!"))
				owner.add_stress(/datum/stressevent/sundercritted)
			if(user?.mind?.has_antag_datum(/datum/antagonist/vampire) || user?.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
				owner.sunder_stacks += 20 //vamps take (20) additional sunderstacks totaling to 60, this means two strikes will kill a vampire if they strike true.
	// Check if critical resistance applies
	var/has_crit_attempt = length(attempted_wounds)
	if(!has_crit_attempt)
		return FALSE

	if(owner.try_resist_critical())
		if(crit_message)
			owner.next_attack_msg.Cut()
			owner.next_attack_msg += span_crit(" Critical resistance! [owner] resists a wound!</span>")
		return TRUE

	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message)
		if(applied)
			if(user?.client)
				record_round_statistic(STATS_CRITS_MADE)
			return applied
	return FALSE

/obj/item/bodypart/head/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	var/static/list/eyestab_zones = list(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE)
	var/static/list/tonguestab_zones = list(BODY_ZONE_PRECISE_MOUTH)
	var/static/list/nosestab_zones = list(BODY_ZONE_PRECISE_NOSE)
	var/static/list/earstab_zones = list(BODY_ZONE_PRECISE_EARS)
	var/static/list/knockout_zones = list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_SKULL)
	var/list/attempted_wounds = list()
	var/used
	var/total_dam = get_damage()
	var/damage_dividend = (total_dam / max_damage)
	var/from_behind = FALSE
	var/try_knockout = FALSE
	if(user && (owner.dir == turn(get_dir(owner,user), 180)))
		from_behind = TRUE
	if(user && dam)
		if(user.goodluck(2))
			dam += 10
	if(bclass in GLOB.charring_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(prob(used))
			attempted_wounds += /datum/wound/charring/head
	if((bclass in GLOB.dislocation_bclasses) && (total_dam >= max_damage))
		used = round(damage_dividend * 20 + (dam / 3))
		if(prob(used))
			if(HAS_TRAIT(src, TRAIT_BRITTLE))
				attempted_wounds += /datum/wound/fracture/neck
			else
				attempted_wounds += /datum/wound/dislocation/neck
	if(bclass in GLOB.fracture_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(HAS_TRAIT(src, TRAIT_BRITTLE))
			used += 20
		if(user)
			if(istype(user.rmb_intent, /datum/rmb_intent/strong) || (user.m_intent == MOVE_INTENT_SNEAK))
				used += 10
		if(!owner.stat && (zone_precise in knockout_zones) && (bclass != BCLASS_CHOP && bclass != BCLASS_PIERCE) && prob(used))
			try_knockout = TRUE
		var/dislocation_type
		var/fracture_type = /datum/wound/fracture/head
		var/necessary_damage = 1
		if(zone_precise == BODY_ZONE_HEAD)
			if(owner.has_wound(/datum/wound/fracture/head))
				fracture_type = /datum/wound/fracture/head/shatter
			else
				fracture_type = /datum/wound/fracture/head
		else if(zone_precise == BODY_ZONE_PRECISE_SKULL)
			if(owner.has_wound(/datum/wound/fracture/head/brain))
				fracture_type = /datum/wound/fracture/head/brain/shatter
			else
				fracture_type = /datum/wound/fracture/head/brain
		else if(zone_precise== BODY_ZONE_PRECISE_EARS)
			fracture_type = /datum/wound/fracture/head/ears
			necessary_damage = 0.9
		else if(zone_precise == BODY_ZONE_PRECISE_NOSE)
			fracture_type = /datum/wound/fracture/head/nose
			necessary_damage = 0.8
		else if(zone_precise == BODY_ZONE_PRECISE_MOUTH)
			fracture_type = /datum/wound/fracture/mouth
			necessary_damage = 0.8
		else if(zone_precise == BODY_ZONE_PRECISE_NECK)
			if(owner.has_wound(/datum/wound/fracture/neck))
				fracture_type = /datum/wound/fracture/neck/shatter
			else
				fracture_type = /datum/wound/fracture/neck
		if(prob(used) && (damage_dividend >= necessary_damage))
			if(dislocation_type)
				attempted_wounds += dislocation_type
			attempted_wounds += fracture_type
	if(bclass in GLOB.artery_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(user)
			if(bclass == BCLASS_CHOP)
				if(istype(user.rmb_intent, /datum/rmb_intent/strong))
					used += 10
			else
				if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
					used += 10
		var/artery_type = /datum/wound/artery
		if(zone_precise == BODY_ZONE_PRECISE_NECK)
			if(HAS_TRAIT(owner, TRAIT_IRONMAN))
				artery_type = /datum/wound/integrity/neck
			else
				artery_type = /datum/wound/artery/neck
		if(prob(used))
			attempted_wounds += artery_type
			if(bclass in GLOB.stab_bclasses)
				if(zone_precise in earstab_zones)
					var/obj/item/organ/ears/my_ears = owner.getorganslot(ORGAN_SLOT_EARS)
					if(!my_ears || has_wound(/datum/wound/facial/ears))
						attempted_wounds += /datum/wound/fracture/head/ears
					else
						attempted_wounds += /datum/wound/facial/ears
				else if(zone_precise in eyestab_zones)
					var/obj/item/organ/my_eyes = owner.getorganslot(ORGAN_SLOT_EYES)
					if(!my_eyes || (has_wound(/datum/wound/facial/eyes/left) && has_wound(/datum/wound/facial/eyes/right)))
						attempted_wounds += /datum/wound/fracture/head/eyes
					else if(my_eyes)
						if(zone_precise == BODY_ZONE_PRECISE_R_EYE)
							attempted_wounds += /datum/wound/facial/eyes/right
						else if(zone_precise == BODY_ZONE_PRECISE_L_EYE)
							attempted_wounds += /datum/wound/facial/eyes/left
				else if(zone_precise in tonguestab_zones)
					var/obj/item/organ/tongue/tongue_up_my_asshole = owner.getorganslot(ORGAN_SLOT_TONGUE)		//..hello?
					if(!tongue_up_my_asshole || has_wound(/datum/wound/facial/tongue))
						attempted_wounds += /datum/wound/fracture/mouth
					else
						attempted_wounds += /datum/wound/facial/tongue
				else if(zone_precise in nosestab_zones)
					if(has_wound(/datum/wound/facial/disfigurement/nose))
						attempted_wounds +=/datum/wound/fracture/head/nose
					else
						attempted_wounds += /datum/wound/facial/disfigurement/nose
				else if(zone_precise in knockout_zones) //because vampires/skeletons exist
					if(has_wound(/datum/wound/fracture/head/brain))
						attempted_wounds += /datum/wound/fracture/head/brain/shatter
					else
						attempted_wounds += /datum/wound/fracture/head/brain
	if(bclass in GLOB.sunder_bclasses)
		if(HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && !owner.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
			used = round(damage_dividend * 20 + (dam / 2), 1)
			if(prob(used) && !owner.mind) //mindless always die in one critical sunder
				attempted_wounds += /datum/wound/sunder/head
			if(prob(used) && owner.sunder_stacks > 100 && owner.mind) //over 100 sunderstacks opens to lethality
				attempted_wounds += /datum/wound/sunder/head
			if(prob(used) && owner.sunder_stacks < 150 && owner.mind) //We don't want too many stacks or we'll never recover.
				owner.sunder_stacks += 40
				owner.visible_message(span_silver("[owner]'s body visibly wilts away at the blow, a blessed sunder!"), span_userdanger("A CRITICAL BLOW SUNDERS ME WITH SACRED FLAME!"))
				owner.add_stress(/datum/stressevent/sundercritted)
			if(user?.mind?.has_antag_datum(/datum/antagonist/vampire) || user?.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
				owner.sunder_stacks += 20 //vamps take (20) additional sunderstacks totaling to 60, this means two strikes will kill a vampire if they strike true.
	var/has_crit_attempt = length(attempted_wounds) || try_knockout
	if(!has_crit_attempt)
		return FALSE

	var/resist_msg = " [owner] resists"
	if(attempted_wounds && try_knockout)
		resist_msg += " a wound and a knockout!</span>"
	else if(attempted_wounds)
		resist_msg += " a wound!</span>"
	else if(try_knockout)
		resist_msg += " a knockout!</span>"

	if(owner.try_resist_critical())
		if(crit_message)
			owner.next_attack_msg.Cut()
			owner.next_attack_msg += span_crit(" Critical resistance!" + resist_msg)
		return TRUE

	// We want to apply knockout AFTER resistance check so you don't need two rolls to resist.
	if(try_knockout)
		owner.next_attack_msg += " <span class='crit'><b>Critical hit!</b> [owner] is knocked out[from_behind ? " FROM BEHIND" : ""]!</span>"
		owner.flash_fullscreen("whiteflash3")
		owner.Unconscious(5 SECONDS + (from_behind * 10 SECONDS))
		if(owner.client)
			winset(owner.client, "outputwindow.output", "max-lines=1")
			winset(owner.client, "outputwindow.output", "max-lines=100")

	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message)
		if(applied)
			if(user?.client)
				record_round_statistic(STATS_CRITS_MADE)
			return applied
	return FALSE
	*/

	if((bclass in GLOB.fracture_bclasses) && (zone_precise != BODY_ZONE_PRECISE_STOMACH))
		var/frac_chance = calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, bonus = strong_bonus + brittle_bonus)
		var/fracture_type = /datum/wound/fracture/chest
		var/frac_divisor = CRIT_CHEST_FRACTURE_DIVISOR
		var/frac_threshold = CRIT_CHEST_FRACTURE_THRESHOLD
		if(zone_precise == BODY_ZONE_PRECISE_GROIN)
			if(damage_dividend >= CRIT_GROIN_FRACTURE_DIVISOR)
				fracture_type = /datum/wound/fracture/groin
			frac_divisor = CRIT_GROIN_FRACTURE_DIVISOR
			frac_threshold = CRIT_GROIN_FRACTURE_THRESHOLD
		attempted_wounds += try_add_crit_wound(fracture_type, damage_dividend, dam, resistance, frac_chance, frac_divisor, frac_threshold)

	if(bclass in GLOB.artery_bclasses)
		var/artery_bonus = ((bclass in GLOB.artery_strong_bclasses) && strong_bonus) ? strong_bonus : aimed_bonus
		var/artery_chance = calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, dam_divisor = 10, bonus = artery_bonus)
		if((zone_precise == BODY_ZONE_PRECISE_STOMACH) && !resistance && !ironman && (bclass in GLOB.disembowel_bclasses))
			attempted_wounds += try_add_crit_wound(/datum/wound/slash/disembowel, damage_dividend, dam, resistance, artery_chance, CRIT_DISEMBOWEL_DIVISOR, CRIT_DISEMBOWEL_THRESHOLD)
		var/artery_type = ironman ? /datum/wound/integrity : /datum/wound/artery
		var/artery_divisor = CRIT_ARTERY_DIVISOR
		var/artery_threshold = CRIT_ARTERY_THRESHOLD
		if(owner.has_wound(/datum/wound/fracture/chest) || (bclass in GLOB.artery_heart_bclasses) || HAS_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS))
			artery_type = ironman ? /datum/wound/integrity/chest : /datum/wound/artery/chest
			artery_divisor = CRIT_ARTERY_CHEST_DIVISOR
			artery_threshold = CRIT_ARTERY_CHEST_THRESHOLD
		attempted_wounds += try_add_crit_wound(artery_type, damage_dividend, dam, resistance, artery_chance, artery_divisor, artery_threshold)

	if(bclass in GLOB.whipping_bclasses)
		if(strong_bonus)
			dam += 10
		if(HAS_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS))
			attempted_wounds += ironman ? /datum/wound/integrity/chest : /datum/wound/artery/chest
		else
			var/scar_chance = calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, dam_divisor = 10)
			attempted_wounds += try_add_crit_wound(/datum/wound/scarring, damage_dividend, dam, resistance, scar_chance, CRIT_SCARRING_DIVISOR, CRIT_SCARRING_THRESHOLD)

	if(bclass in GLOB.stab_bclasses)
		var/stab_projectile = istype(weapon, /obj/projectile)
		var/stab_chance = calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, dam_divisor = 2, resistance_penalty = 12, bonus = (aimed_bonus && !stab_projectile) ? 12 : 0)
#ifndef HUGBOX
		if(stab_projectile)
			stab_chance = round(stab_chance * CRIT_PROJECTILE_ORGAN_MULT, 1)
#endif
		if(check_crit_threshold(damage_dividend, dam, resistance, CRIT_CHEST_ORGAN_STAB_DIVISOR, CRIT_CHEST_ORGAN_STAB_THRESHOLD) && prob(stab_chance))
			attempted_wounds += organ_penetration_wound(zone_precise, 20)

	if(bclass in GLOB.artery_bclasses)
		var/slash_chance = calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, base_multiplier = 15, resistance_penalty = 15, bonus = strong_bonus)
		if(check_crit_threshold(damage_dividend, dam, resistance, CRIT_CHEST_ORGAN_SLASH_DIVISOR, CRIT_CHEST_ORGAN_SLASH_THRESHOLD) && prob(slash_chance))
			attempted_wounds += organ_penetration_wound(zone_precise, 10)

	if((bclass in GLOB.fracture_bclasses) && owner.has_wound(/datum/wound/fracture/chest) && (zone_precise == BODY_ZONE_CHEST))
		var/blunt_chance = calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, base_multiplier = 18, resistance_penalty = 12, bonus = strong_bonus)
		if(check_crit_threshold(damage_dividend, dam, resistance, CRIT_CHEST_ORGAN_BLUNT_DIVISOR, CRIT_CHEST_ORGAN_BLUNT_THRESHOLD) && prob(blunt_chance))
			var/organ_wound_type = organ_penetration_wound(BODY_ZONE_CHEST, 20)
			if(organ_wound_type)
				var/datum/wound/lethal/bone_frag_wound = new organ_wound_type(dam)
				bone_frag_wound.from_fracture = TRUE
				attempted_wounds += bone_frag_wound

	if((bclass in GLOB.sunder_bclasses) && !was_blunted && HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && !owner.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
		sunder_stack_crit(calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, dam_divisor = 2), attempted_wounds, /datum/wound/sunder/chest, user)

	if(bclass in GLOB.charring_bclasses)
		var/burn_chance = calculate_crit_chance(damage_dividend, dam, resistance, base_multiplier = 25, dam_divisor = 2.5, resistance_penalty = 12, armor_resistance = armor_resistance)
		attempted_wounds += try_add_crit_wound(elemental_burn_wound(bclass), damage_dividend, dam, resistance, burn_chance, CRIT_BURN_DIVISOR, CRIT_BURN_THRESHOLD)

	listclearnulls(attempted_wounds)
	return apply_crit_wounds(attempted_wounds, silent, crit_message, dam, user, weapon)

/obj/item/bodypart/head/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE, raw_damage = 0, armor_block = 0, armor_resistance = 0, was_blunted = FALSE, obj/item/weapon)
	var/static/list/eyestab_zones = list(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE)
	var/static/list/knockout_zones = list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_SKULL)
	if(!bclass || !dam || (owner.status_flags & GODMODE))
		return FALSE
	var/list/attempted_wounds = list()
	var/total_dam = get_damage()
	var/damage_dividend = total_dam / max_damage
	var/resistance = HAS_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE)
	if(user?.goodluck(2))
		dam += 10
	if(dam < owner.STACON * (1 - (damage_dividend * 0.5)))
		return FALSE

	var/from_behind = user && (owner.dir == turn(get_dir(owner, user), 180))
	var/strong_bonus = istype(user?.rmb_intent, /datum/rmb_intent/strong) ? 10 : 0
	var/aimed_bonus = istype(user?.rmb_intent, /datum/rmb_intent/aimed) ? 10 : 0
	var/brittle = HAS_TRAIT(src, TRAIT_BRITTLE)
	var/sneak_bonus = (user?.m_intent == MOVE_INTENT_SNEAK) ? 10 : 0
	var/is_construct = isconstruct(owner)

	if((bclass in GLOB.dislocation_bclasses) && (total_dam >= max_damage))
		if(prob(calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance)))
			if(brittle)
				attempted_wounds += /datum/wound/fracture/neck
			else if(!resistance)
				attempted_wounds += /datum/wound/dislocation/neck

	if(bclass in GLOB.fracture_bclasses)
		var/frac_chance = calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, bonus = (brittle ? 20 : 0) + strong_bonus + sneak_bonus)
		if(!owner.stat && !resistance && (zone_precise in knockout_zones) && (bclass != BCLASS_CHOP && bclass != BCLASS_PIERCE) && prob(frac_chance))
			owner.next_attack_msg += " <span class='crit'><b>Critical hit!</b> [owner] is knocked out[from_behind ? " FROM BEHIND" : ""]!</span>"
			owner.flash_fullscreen("whiteflash3")
			owner.Unconscious(5 SECONDS + (from_behind * 10 SECONDS))
			if(owner.client)
				winset(owner.client, "outputwindow.output", "max-lines=1")
				winset(owner.client, "outputwindow.output", "max-lines=100")

		var/dislocation_type
		var/fracture_type = owner.has_wound(/datum/wound/fracture/head) ? /datum/wound/fracture/head/shatter : /datum/wound/fracture/head
		var/frac_divisor = CRIT_HEAD_FRACTURE_DIVISOR
		var/frac_threshold = CRIT_HEAD_FRACTURE_THRESHOLD
		var/is_lethal_fracture = FALSE
		if(resistance)
			fracture_type = /datum/wound/fracture
		else
			switch(zone_precise)
				if(BODY_ZONE_PRECISE_SKULL)
					fracture_type = owner.has_wound(/datum/wound/fracture/head/brain) ? /datum/wound/fracture/head/brain/shatter : /datum/wound/fracture/head/brain
					frac_divisor = CRIT_SKULL_FRACTURE_DIVISOR
					frac_threshold = CRIT_SKULL_FRACTURE_THRESHOLD
					is_lethal_fracture = TRUE
				if(BODY_ZONE_PRECISE_EARS)
					fracture_type = /datum/wound/fracture/head/ears
					frac_divisor = CRIT_FACE_FRACTURE_DIVISOR
					frac_threshold = CRIT_FACE_FRACTURE_THRESHOLD
				if(BODY_ZONE_PRECISE_NOSE)
					fracture_type = /datum/wound/fracture/head/nose
					frac_divisor = CRIT_FACE_FRACTURE_DIVISOR
					frac_threshold = CRIT_FACE_FRACTURE_THRESHOLD
					is_lethal_fracture = TRUE
				if(BODY_ZONE_PRECISE_MOUTH)
					fracture_type = /datum/wound/fracture/mouth
					frac_divisor = CRIT_MOUTH_FRACTURE_DIVISOR
					frac_threshold = CRIT_MOUTH_FRACTURE_THRESHOLD
				if(BODY_ZONE_PRECISE_NECK)
					fracture_type = owner.has_wound(/datum/wound/fracture/neck) ? /datum/wound/fracture/neck/shatter : /datum/wound/fracture/neck
					dislocation_type = /datum/wound/dislocation/neck
					frac_divisor = CRIT_NECK_FRACTURE_DIVISOR
					frac_threshold = CRIT_NECK_FRACTURE_THRESHOLD
					is_lethal_fracture = TRUE
		if(check_crit_threshold(damage_dividend, dam, resistance, frac_divisor, frac_threshold) && prob(frac_chance))
			if(dislocation_type)
				attempted_wounds += dislocation_type
			if(is_lethal_fracture)
				var/datum/wound/fracture/lethal_fracture = new fracture_type()
				lethal_fracture.death_probability = calculate_lethal_death_chance(raw_damage, armor_block, user)
				attempted_wounds += lethal_fracture
			else
				attempted_wounds += fracture_type

	if(bclass in GLOB.artery_bclasses)
		var/artery_chance = calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, bonus = (bclass == BCLASS_CHOP) ? strong_bonus : aimed_bonus)
		var/artery_type = /datum/wound/artery
		var/artery_divisor = CRIT_ARTERY_DIVISOR
		var/artery_threshold = CRIT_ARTERY_THRESHOLD
		if(zone_precise == BODY_ZONE_PRECISE_NECK)
			artery_type = HAS_TRAIT(owner, TRAIT_IRONMAN) ? /datum/wound/integrity/neck : /datum/wound/artery/neck
			artery_divisor = CRIT_ARTERY_NECK_DIVISOR
			artery_threshold = CRIT_ARTERY_NECK_THRESHOLD
		attempted_wounds += try_add_crit_wound(artery_type, damage_dividend, dam, resistance, artery_chance, artery_divisor, artery_threshold)

		if((bclass in GLOB.stab_bclasses) && !resistance && prob(artery_chance) && check_crit_threshold(damage_dividend, dam, resistance, CRIT_FACIAL_STAB_DIVISOR, CRIT_FACIAL_STAB_THRESHOLD))
			if(zone_precise == BODY_ZONE_PRECISE_EARS)
				var/obj/item/organ/ears/my_ears = owner.getorganslot(ORGAN_SLOT_EARS)
				if(!my_ears || has_wound(/datum/wound/facial/ears))
					attempted_wounds += /datum/wound/fracture/head/ears
				else
					attempted_wounds += /datum/wound/facial/ears
			else if(zone_precise in eyestab_zones)
				var/obj/item/organ/my_eyes = owner.getorganslot(ORGAN_SLOT_EYES)
				if(!my_eyes || (has_wound(/datum/wound/facial/eyes/left) && has_wound(/datum/wound/facial/eyes/right)))
					attempted_wounds += /datum/wound/fracture/head/eyes
				else if(zone_precise == BODY_ZONE_PRECISE_R_EYE)
					attempted_wounds += /datum/wound/facial/eyes/right
				else
					attempted_wounds += /datum/wound/facial/eyes/left
			else if(zone_precise == BODY_ZONE_PRECISE_MOUTH)
				var/obj/item/organ/tongue/tongue_up_my_asshole = owner.getorganslot(ORGAN_SLOT_TONGUE)		//..hello?
				if(!tongue_up_my_asshole || has_wound(/datum/wound/facial/tongue))
					attempted_wounds += /datum/wound/fracture/mouth
				else
					attempted_wounds += /datum/wound/facial/tongue
			else if(zone_precise == BODY_ZONE_PRECISE_NOSE)
				if(has_wound(/datum/wound/facial/disfigurement/nose))
					attempted_wounds += /datum/wound/fracture/head/nose
				else
					attempted_wounds += /datum/wound/facial/disfigurement/nose

	if((bclass in GLOB.sunder_bclasses) && !was_blunted && HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && !owner.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
		sunder_stack_crit(calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, dam_divisor = 2), attempted_wounds, /datum/wound/sunder/head, user)

	if(!is_construct && (bclass in GLOB.stab_bclasses) && (zone_precise in GLOB.brain_penetration_zones))
		var/brain_stab_chance = calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, base_multiplier = 25, dam_divisor = 2, resistance_penalty = 15, bonus = strong_bonus ? 15 : 0)
		if(check_crit_threshold(damage_dividend, dam, resistance, CRIT_BRAIN_PENETRATION_DIVISOR, CRIT_BRAIN_PENETRATION_THRESHOLD) && prob(brain_stab_chance) && owner.getorganslot(ORGAN_SLOT_BRAIN))
			attempted_wounds += /datum/wound/lethal/brain_penetration

	if(!is_construct && (bclass in GLOB.fracture_bclasses) && owner.has_wound(/datum/wound/fracture/head))
		var/brain_blunt_chance = calculate_crit_chance(damage_dividend, dam, resistance, armor_resistance = armor_resistance, resistance_penalty = 12, bonus = strong_bonus ? 12 : 0)
		if(check_crit_threshold(damage_dividend, dam, resistance, CRIT_BRAIN_BLUNT_DIVISOR, CRIT_BRAIN_BLUNT_THRESHOLD) && prob(brain_blunt_chance) && owner.getorganslot(ORGAN_SLOT_BRAIN))
			var/datum/wound/lethal/brain_penetration/bone_frag_wound = new /datum/wound/lethal/brain_penetration(dam)
			bone_frag_wound.from_fracture = TRUE
			attempted_wounds += bone_frag_wound

	if(bclass in GLOB.charring_bclasses)
		var/burn_chance = calculate_crit_chance(damage_dividend, dam, resistance, base_multiplier = 25, dam_divisor = 2.5, resistance_penalty = 12, armor_resistance = armor_resistance)
		attempted_wounds += try_add_crit_wound(elemental_burn_wound(bclass), damage_dividend, dam, resistance, burn_chance, CRIT_BURN_DIVISOR, CRIT_BURN_THRESHOLD)

	listclearnulls(attempted_wounds)
	return apply_crit_wounds(attempted_wounds, silent, crit_message, dam, user, weapon)
	// [/SURREALIS-EDIT]

/// Embeds an object in this bodypart
/obj/item/bodypart/proc/add_embedded_object(obj/item/embedder, silent = FALSE, crit_message = FALSE, ranged = FALSE)
	if(!embedder || !can_embed(embedder))
		return FALSE
	if(owner && ((owner.status_flags & GODMODE) || HAS_TRAIT(owner, TRAIT_PIERCEIMMUNE)))
		return FALSE
	if(istype(embedder, /obj/item/natural/worms/leech))
		record_round_statistic(STATS_LEECHES_EMBEDDED)
	LAZYADD(embedded_objects, embedder)
	// [SURREALIS-ADD] - PLASMA_OPTS
	owner?.life_work |= LIFEWORK_WOUNDS
	// [/SURREALIS-ADD]
	embedder.is_embedded = TRUE
	embedder.embedded_host = src
	embedder.forceMove(src)
	if(owner)
		// [SURREALIS-ADD] - VRCOMBAT
		invalidate_owner_bleed_cache()
		// [/SURREALIS-ADD]
		embedder.add_mob_blood(owner)
		if (!silent)
			if(!ranged)
				playsound(owner, 'sound/combat/newstuck.ogg', 100, vary = TRUE)
			if (owner.has_status_effect(/datum/status_effect/buff/ozium))
				owner.emote ("exhales")
			if (owner.has_status_effect(/datum/status_effect/buff/drunk) && !owner.has_status_effect(/datum/status_effect/buff/ozium))
				owner.emote("pain")
			if (!owner.has_status_effect(/datum/status_effect/buff/drunk) && !owner.has_status_effect(/datum/status_effect/buff/ozium))
				owner.emote("embed")
		if(crit_message)
			var/embeds = pick("impales", "impales", "impales", "impales", "impales", "lodges in", "runs through", "buries inside", "sinks into", "drives into", "embeds in", "jams into", "gets stuck in", "lodges in", "burrows into", "penetrates into", "wedges into", "pierces into", "buries deep into")
			owner.next_attack_msg += " <span class='userdanger'>[embedder] [embeds] [owner]'s [src]!</span>"
			if(ranged)
				playsound(owner, 'sound/combat/brutal_impalement.ogg', 100, vary = TRUE)
		update_disabled()
		update_bleed_hud()
		if((embedder.is_silver || (embedder.is_even_lesser_silver && is_npc(owner))) && HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && !owner.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
			var/datum/component/silverbless/psyblessed = embedder.GetComponent(/datum/component/silverbless)
			owner.adjust_fire_stacks(1, psyblessed?.is_blessed ? /datum/status_effect/fire_handler/fire_stacks/sunder/blessed : /datum/status_effect/fire_handler/fire_stacks/sunder)
			owner.ignite_mob()
			to_chat(owner, span_silver("The embedded [embedder] sunders you from within!"))
	return TRUE

/// Removes an embedded object from this bodypart
/obj/item/bodypart/proc/remove_embedded_object(obj/item/embedder)
	if(!embedder)
		return FALSE
	if(ispath(embedder))
		embedder = has_embedded_object(embedder)
	if(!istype(embedder) || !is_object_embedded(embedder))
		return FALSE

	LAZYREMOVE(embedded_objects, embedder)
	embedder.is_embedded = FALSE
	embedder.embedded_host = null
	// [SURREALIS-ADD] - VRCOMBAT
	invalidate_owner_bleed_cache()
	// [/SURREALIS-ADD]
	if(QDELETED(embedder))
		if(owner)
			if(!owner.has_embedded_objects())
				owner.clear_alert("embeddedobject")
			update_disabled()
			update_bleed_hud()
		return TRUE

	var/atom/drop_loc = owner?.drop_location() || drop_location()
	if(!isatom(drop_loc) || QDELETED(drop_loc))
		drop_loc = null

	if(drop_loc)
		embedder.forceMove(drop_loc)
	else
		qdel(embedder)

	if(owner)
		if(!owner.has_embedded_objects())
			owner.clear_alert("embeddedobject")
		update_disabled()
		update_bleed_hud()
	return TRUE

// [SURREALIS-ADD] - VRCOMBAT
/obj/item/bodypart/proc/invalidate_owner_bleed_cache()
	if(iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		carbon_owner.invalidate_bleed_cache()

// [/SURREALIS-ADD]
/obj/item/bodypart/proc/update_bleed_hud()
	var/datum/hud/hud_used = owner?.hud_used
	if(hud_used?.zone_select)
		hud_used.zone_select.update_limb(body_zone)

/obj/item/bodypart/proc/try_bandage(obj/item/new_bandage)
	if(!new_bandage)
		return FALSE
	bandage = new_bandage
	new_bandage.forceMove(src)
	// [SURREALIS-ADD] - VRCOMBAT
	invalidate_owner_bleed_cache()
	// [/SURREALIS-ADD]
	var/datum/hud/hud_used = owner?.hud_used
	if(hud_used?.zone_select)
		hud_used.zone_select.update_limb(body_zone)
	return TRUE

/obj/item/bodypart/proc/process_bandage(bleed_rate)
	if(!bandage)
		return FALSE
	var/obj/item/natural/cloth/cloth = bandage
	if(istype(cloth) && cloth.medicine_quality)
		if(cloth.medicine_amount >= 0)
			heal_wounds(cloth.medicine_quality * 1)
			heal_damage(cloth.medicine_quality * 1, cloth.medicine_quality * 1, 0, null, FALSE)
			cloth.medicine_amount -= 0.25
		else
			cloth.medicine_amount = 0
			cloth.medicine_quality = 0
			cloth.detail_color = null
			cloth.desc = initial(cloth.desc)
			cloth.update_icon()
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	/*
	if(!bleed_rate)
		return FALSE
	var/bandage_health = 1
	if(istype(cloth))
		cloth.bandage_health -= bleed_rate
		bandage_health = cloth.bandage_health
	if(bandage_health <= 0)
	*/
	return try_bandage_expire()

/obj/item/bodypart/proc/try_bandage_expire()
	if(!bandage || HAS_BLOOD_DNA(bandage))
		return FALSE
	var/bandage_effectiveness = 0.5
	if(istype(bandage, /obj/item/natural/cloth))
		var/obj/item/natural/cloth/cloth = bandage
		bandage_effectiveness = cloth.bandage_effectiveness
	var/plugged = 0
	for(var/obj/item/embedded as anything in embedded_objects)
		plugged += embedded.embed_bleed_contribution
	var/highest_bleed_rate = 0
	for(var/datum/wound/wound as anything in wounds)
		if(wound.is_hidden_bleed())
			continue
		var/wound_bleed = wound.bleed_rate
		if(plugged && istype(wound, /datum/wound/dynamic/puncture))
			wound_bleed = max(wound_bleed - plugged, 0)
		highest_bleed_rate = max(highest_bleed_rate, wound_bleed)
	if(bandage_effectiveness < highest_bleed_rate)
	// [/SURREALIS-EDIT]
		return bandage_expire()
	return FALSE

/obj/item/bodypart/proc/bandage_expire()
	if(!owner)
		return FALSE
	if(!bandage)
		return FALSE
	// [SURREALIS-ADD] - VRCOMBAT
	invalidate_owner_bleed_cache()
	// [/SURREALIS-ADD]
	if(owner.stat != DEAD)
		owner.visible_message(span_warning("Blood soaks through the bandage on [owner]'s [name]."), span_warning("Blood soaks through the bandage on my [name]."), vision_distance = 3)
	. = bandage.add_mob_blood(owner)
	var/datum/hud/hud_used = owner.hud_used
	if(hud_used?.zone_select)
		hud_used.zone_select.update_limb(body_zone)
	return .

/obj/item/bodypart/proc/remove_bandage()
	if(!bandage)
		return FALSE
	var/drop_location = owner?.drop_location() || drop_location()
	if(drop_location)
		bandage.forceMove(drop_location)
	else
		qdel(bandage)
	bandage = null
	// [SURREALIS-ADD] - VRCOMBAT
	invalidate_owner_bleed_cache()
	// [/SURREALIS-ADD]
	owner?.update_damage_overlays()
	var/datum/hud/hud_used = owner?.hud_used
	if(hud_used?.zone_select)
		hud_used.zone_select.update_limb(body_zone)
	return TRUE

/// Applies a temporary paralysis effect to this bodypart
/obj/item/bodypart/proc/temporary_crit_paralysis(duration = 60 SECONDS, brittle = TRUE)
	if(HAS_TRAIT(src, TRAIT_BRITTLE))
		return FALSE
	ADD_TRAIT(src, TRAIT_PARALYSIS, CRIT_TRAIT)
	if(brittle)
		ADD_TRAIT(src, TRAIT_BRITTLE, CRIT_TRAIT)
	addtimer(CALLBACK(src, PROC_REF(remove_crit_paralysis)), duration)
	if(owner)
		update_disabled()
	return TRUE

/// Removes the temporary paralysis effect from this bodypart
/obj/item/bodypart/proc/remove_crit_paralysis()
	REMOVE_TRAIT(src, TRAIT_PARALYSIS, CRIT_TRAIT)
	REMOVE_TRAIT(src, TRAIT_BRITTLE, CRIT_TRAIT)
	if(owner)
		update_disabled()
	return TRUE

/// Returns surgery flags applicable to this bodypart
/obj/item/bodypart/proc/get_surgery_flags()
	// oh sweet mother of christ what the FUCK is this. this is called EVERY TIME BLEED RATE IS CHECKED.
	var/returned_flags = NONE
	if(can_bloody_wound())
		returned_flags |= SURGERY_BLOODY
	for(var/datum/wound/slash/incision/incision in wounds)
		if(incision.is_sewn())
			continue
		returned_flags |= SURGERY_INCISED
		break
	// [SURREALIS-ADD] - VRCOMBAT
	if(isconstruct(owner))
		returned_flags |= SURGERY_CONSTRUCT
	// [/SURREALIS-ADD]
	var/static/list/retracting_behaviors = list(
		TOOL_RETRACTOR,
		TOOL_CROWBAR,
		TOOL_IMPROVISED_RETRACTOR,
	)
	var/static/list/clamping_behaviors = list(
		TOOL_HEMOSTAT,
		TOOL_WIRECUTTER,
		TOOL_IMPROVISED_HEMOSTAT,
	)
	for(var/obj/item/embedded as anything in embedded_objects)
		if((embedded.tool_behaviour in retracting_behaviors) || embedded.embedding?.retract_limbs)
			returned_flags |= SURGERY_RETRACTED
		if((embedded.tool_behaviour in clamping_behaviors) || embedded.embedding?.clamp_limbs)
			returned_flags |= SURGERY_CLAMPED
	if(has_wound(/datum/wound/dislocation))
		returned_flags |= SURGERY_DISLOCATED
	if(has_wound(/datum/wound/fracture) || isooze(owner))
		returned_flags |= SURGERY_BROKEN
	if(has_wound(/datum/wound/slash/vein))
		returned_flags |= SURGERY_CUTVEIN
	for(var/datum/wound/puncture/drilling/drilling in wounds)
		if(drilling.is_sewn())
			continue
		returned_flags |= SURGERY_DRILLED
	if(skeletonized)
		returned_flags |= SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_DRILLED //ehh... we have access to whatever organ is there
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	// 	return returned_flags
	//
	// /* Check for critical resistance and trigger its effects.
	// 	Return TRUE if critical resistance was triggered, false if it don't work
	// */
	// /mob/living/proc/try_resist_critical()
	// 	var/resistance = HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE)
	// 	if(!resistance)
	// 		return FALSE
	//
	// 	var/crit_resist_tracker = has_status_effect(/datum/status_effect/debuff/crit_resistance_cd)
	//
	// 	if(!crit_resist_tracker)
	// 		apply_status_effect(/datum/status_effect/debuff/crit_resistance_cd)
	// 		return TRUE // One chance were used and it was added
	// 	else
	// 		var/datum/status_effect/debuff/crit_resistance_cd/crit_resist_tracker_actual = crit_resist_tracker
	// 		// Iterate stack by 1 and then see if we can crit this hit
	// 		return !crit_resist_tracker_actual.try_crit()
	return returned_flags

	// [/SURREALIS-EDIT]
/obj/item/bodypart/proc/handle_ooze_wounds(datum/wound/wound, silent = FALSE, crit_message = FALSE)
	if(!wound.handle_ooze_wound(src))
		return
	if(!istype(src, /obj/item/bodypart/head/))
		if(crit_message)
			var/message = "<span class='crit'><b>Critical hit!</b> The [src] melts apart into goop!</span>"
			if(message)
				owner.next_attack_msg += " [message]"
		src.dismember()
	else
		if(has_wound(/datum/wound/slime/knockout))
			add_wound(/datum/wound/slime/paralyze, silent, crit_message)
		else
			add_wound(/datum/wound/slime/knockout, silent, crit_message)
