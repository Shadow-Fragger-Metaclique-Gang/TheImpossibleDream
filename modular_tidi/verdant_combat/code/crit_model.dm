/obj/item/clothing
	var/list/prevent_crits

/obj/item
	var/embed_bleed_contribution = 0

/obj/item/bodypart
	var/last_bleed_increase = 0
	var/spell_crit_halved = FALSE
	var/projectile_crit = FALSE

GLOBAL_LIST_INIT(clamping_tool_behaviors, list(TOOL_HEMOSTAT, TOOL_WIRECUTTER, TOOL_IMPROVISED_HEMOSTAT))

/obj/item/proc/set_embed_bleed_contribution(amount)
	embed_bleed_contribution = amount
	var/obj/item/bodypart/host = embedded_host
	if(istype(host))
		host.invalidate_owner_bleed_cache()

/obj/item/bodypart/proc/add_grab(obj/item/grabbing/grab)
	LAZYADD(grabbedby, grab)
	invalidate_owner_bleed_cache()

/obj/item/bodypart/proc/remove_grab(obj/item/grabbing/grab)
	LAZYREMOVE(grabbedby, grab)
	invalidate_owner_bleed_cache()

/obj/item/bodypart/proc/is_clamped()
	for(var/obj/item/embedded as anything in embedded_objects)
		if((embedded.tool_behaviour in GLOB.clamping_tool_behaviors) || embedded.embedding?.clamp_limbs)
			return TRUE
	return FALSE

/obj/item/grabbing/proc/set_bleed_suppressing(amount)
	bleed_suppressing = amount
	limb_grabbed?.invalidate_owner_bleed_cache()

/obj/item/bodypart/proc/calculate_crit_chance(damage_dividend, dam, resistance, base_multiplier = 10, dam_divisor = 5, resistance_penalty = 10, bonus = 0, armor_resistance = 0)
	var/chance = base_crit_chance(damage_dividend, dam, resistance, base_multiplier, dam_divisor, resistance_penalty, bonus, armor_resistance)
#ifndef HUGBOX
	chance = round(chance * crit_curve_mult(damage_dividend, dam) * CRIT_CHANCE_GLOBAL_MULT * (spell_crit_halved ? CRIT_SPELL_MULT : 1), 1)
#endif
	return chance

/obj/item/bodypart/proc/base_crit_chance(damage_dividend, dam, resistance, base_multiplier = 10, dam_divisor = 5, resistance_penalty = 10, bonus = 0, armor_resistance = 0)
	var/con_modifier = STAT_MOD(owner.STACON)
	var/base_chance = round(damage_dividend * base_multiplier + dam * (dam_divisor / 5) - resistance_penalty * resistance + bonus, 1)
	if(con_modifier > 0)
		base_chance *= 1 - (con_modifier / 10)
	else
		base_chance *= 1 + (abs(con_modifier) / 10)
	if(armor_resistance > 0)
		base_chance *= 1 - (armor_resistance / 100) * 0.5
	return round(base_chance, 1)

#ifndef HUGBOX
/obj/item/bodypart/proc/crit_curve_mult(damage_dividend, dam)
	if(!projectile_crit && dam >= CRIT_CURVE_OVERKILL + owner.STACON)
		return 1
	var/prior_fraction = max(0, damage_dividend - (dam / max_damage))
	var/readiness = min(1, prior_fraction / CRIT_CURVE_FULL_FRACTION) ** CRIT_CURVE_EXPONENT
	return CRIT_CURVE_FRESH_MULT + (1 - CRIT_CURVE_FRESH_MULT) * readiness
#endif

/obj/item/bodypart/proc/check_crit_threshold(damage_dividend, dam, resistance, divisor, overkill_difficulty)
	if(damage_dividend >= divisor)
		return TRUE
	if(!overkill_difficulty)
		return FALSE
	return get_overkill_threshold(overkill_difficulty, damage_dividend, dam, resistance)

/obj/item/bodypart/proc/try_add_crit_wound(wound_type, damage_dividend, dam, resistance, crit_chance, divisor, overkill_difficulty)
	if(!check_crit_threshold(damage_dividend, dam, resistance, divisor, overkill_difficulty))
		return null
	if(!prob(crit_chance))
		return null
	return wound_type

/obj/item/bodypart/proc/get_overkill_threshold(difficulty, damage_dividend, damage, resistance)
	return damage >= (difficulty + owner.STACON)

/obj/item/bodypart/proc/calculate_lethal_death_chance(raw_damage, armor_block, mob/living/user)
	if(!owner || !raw_damage)
		return 0
	var/death_chance = min(raw_damage, 100)
	death_chance += (get_damage() / max_damage) * 100 * 0.5
	if(armor_block > 0)
		death_chance *= 1 - (armor_block / (raw_damage + armor_block))
	death_chance -= (owner.STACON - 10) * 5
	if(user?.goodluck(3))
		death_chance += user.STALUC * 2
	return clamp(death_chance, 1, 40)

/// Werewolves resist crits unless sundered or hit with silver.
/obj/item/bodypart/proc/crit_immune_to(obj/item/weapon, bclass)
	if(!owner || !istype(owner.dna?.species, /datum/species/werewolf))
		return FALSE
	if(bclass in GLOB.sunder_bclasses)
		return FALSE
	if(owner.has_wound(/datum/wound/sunder) || owner.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || owner.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed) || owner.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/lesser))
		return FALSE
	if(istype(weapon, /obj/projectile))
		var/obj/projectile/shot = weapon
		return !shot.is_silver_proj
	return !(istype(weapon) && weapon.is_silver)

/mob/living/carbon/human/proc/checkcritarmor(def_zone, bclass)
	if(!bclass)
		return 0
	if(isbodypart(def_zone))
		var/obj/item/bodypart/CBP = def_zone
		def_zone = CBP.body_zone
	. = 0
	for(var/obj/item/clothing/C in worn_armor_slots())
		if(!(bclass in C.prevent_crits))
			continue
		if(!zone2covered(def_zone, C.body_parts_covered_dynamic))
			continue
		var/zone_integrity = C.get_zone_integrity(def_zone)
		if(zone_integrity <= 1)
			continue
		. = max(., (zone_integrity / C.get_zone_max_integrity(def_zone)) * 100)

/obj/item/bodypart/proc/transfer_wounds(obj/item/bodypart/recipient)
	if(!recipient)
		return FALSE
	for(var/datum/wound/transferred_wound as anything in wounds?.Copy())
		var/old_bleeding = transferred_wound.bleed_rate
		transferred_wound.apply_to_bodypart(recipient, silent = TRUE, crit_message = FALSE)
		transferred_wound.set_bleed_rate(old_bleeding)
	recipient.owner?.update_damage_overlays()
	return TRUE

/obj/item/bodypart/proc/apply_burn_wound(damage, bclass = BCLASS_BURN)
	if(!owner || (owner.status_flags & GODMODE) || damage <= 0)
		return
	bodypart_attacked_by(bclass, damage, null, body_zone, raw_damage = damage)

/// Burns a limb for cauterizing without crits.
/obj/item/bodypart/proc/cauterize_burn(damage)
	if(receive_damage(burn = damage, wounds_handled = TRUE))
		owner?.update_damage_overlays()
	if(!owner || (owner.status_flags & GODMODE) || damage <= 0)
		return
	cauterizing = TRUE
	bodypart_attacked_by(BCLASS_BURN, damage, null, body_zone, raw_damage = damage, no_crit = TRUE, no_debuff = TRUE)
	cauterizing = FALSE

GLOBAL_LIST_INIT(brain_penetration_zones, list(BODY_ZONE_PRECISE_SKULL, BODY_ZONE_HEAD, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_R_EYE))

/datum/wound/scarring
	name = "permanent scarring"
	check_name = span_userdanger("<B>SCARRED</B>")
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"The whiplash cuts deep!",
		"The tissue is irreversibly rended!",
		"The %BODYPART is thoroughly disfigured!",
	)
	sound_effect = 'sound/combat/crit.ogg'
	whp = 80
	woundpain = 30
	can_sew = FALSE
	can_cauterize = FALSE
	disabling = TRUE
	critical = TRUE
	sleep_healing = 0

/datum/wound/scarring/on_mob_gain(mob/living/affected, damage)
	. = ..()
	affected.emote("scream", TRUE)
	affected.Slowdown(20)
	shake_camera(affected, 2, 2)

/datum/wound/scarring/can_stack_with(datum/wound/other)
	return !istype(other, /datum/wound/scarring)

/datum/wound
	var/silent_progress = FALSE

/datum/wound/dynamic
	silent_progress = TRUE

/datum/wound/fracture/set_bone()
	. = ..()
	if(.)
		set_bleed_rate(0)

/datum/wound/fracture/head/set_bone()
	. = ..()
	if(!. || !paralysis || !owner)
		return
	paralysis = FALSE
	REMOVE_TRAIT(owner, TRAIT_NO_BITE, "[type]")
	REMOVE_TRAIT(owner, TRAIT_PARALYSIS, "[type]")
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, "[type]")
	if(iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		carbon_owner.update_disabled_bodyparts()
