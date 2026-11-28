/mob/living/carbon/human/proc/interrupt_ranged_draw(damage_amount)
	if(damage_amount <= 0 || !client?.charging)
		return
	var/obj/item/held_item = get_active_held_item()
	if(istype(held_item, /obj/item/gun/ballistic/revolver/grenadelauncher/bow))
		var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/bow = held_item
		if(bow.chambered)
			bow.chambered = null
			var/num_unloaded = 0
			for(var/obj/item/ammo_casing/CB in bow.get_ammo_list(FALSE, TRUE))
				CB.forceMove(get_turf(src))
				num_unloaded++
			if(num_unloaded)
				bow.update_icon()
		visible_message(span_warning("[src]'s draw is interrupted, dropping the arrow!"), span_warning("I flinch from the hit, dropping my arrow!"))
		stop_attack()
	else if(istype(held_item, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow))
		visible_message(span_warning("[src]'s aim is disrupted!"), span_warning("The hit disrupts my aim!"))
		stop_attack()

/proc/variance_attack_message(mob/living/user)
	if(!ishuman(user))
		return ""
	if(istype(user.rmb_intent, /datum/rmb_intent/strong))
		return " <b style='color:pink'><i>A brutal blow!</i></b>"
	if(istype(user.rmb_intent, /datum/rmb_intent/weak))
		return " <span style='color:pink'><i>A restrained strike.</i></span>"
	if(user.last_variance_percentile)
		if(user.last_variance_percentile <= VARIANCE_LOW_PERCENTILE)
			return " <span style='color:pink'><i>A glancing blow.</i></span>"
		if(user.last_variance_percentile >= VARIANCE_HIGH_PERCENTILE)
			return " <b style='color:pink'><i>The strike lands squarely!</i></b>"
	return ""

/mob/living/carbon/human/proc/smash_knockback(mob/living/user, actual_damage)
	if(user.used_intent?.blade_class != BCLASS_SMASH || lying || resting || buckled || buckle_lying)
		return
	if(HAS_TRAIT(src, TRAIT_BIGGUY) && !HAS_TRAIT(user, TRAIT_BIGGUY))
		return
	var/throw_power = generic_stat_comparison(user.STASTR, max(STACON, STASTR))
	if(HAS_TRAIT(user, TRAIT_BIGGUY))
		throw_power += 25
	var/throw_damage_bonus = floor(actual_damage / 2)
	if(throw_power + throw_damage_bonus >= 50 || (!cmode && user.cmode && throw_power + throw_damage_bonus >= 25))
		throw_power = max(floor(throw_power / 10) - 3, 1)
		var/turf/target_turf = get_ranged_target_turf(get_turf(src), get_dir(get_turf(user), get_turf(src)), throw_power)
		smash_knockback_flying = TRUE
		if(!throw_at(target_turf, throw_power, throw_power, src, spin = FALSE, callback = CALLBACK(src, PROC_REF(end_smash_knockback))))
			smash_knockback_flying = FALSE

/mob/living/carbon
	var/smash_knockback_flying = FALSE

/mob/living/carbon/proc/end_smash_knockback()
	smash_knockback_flying = FALSE

/mob/living/carbon/proc/smash_knockback_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!smash_knockback_flying || !throwingdatum || !hit_atom?.density || hit_atom == src)
		return FALSE
	smash_knockback_flying = FALSE
	var/tiles_left = min(max(throwingdatum.maxrange - throwingdatum.dist_travelled, 0) + 1, SMASH_IMPACT_MAX_TILES)
	take_bodypart_damage(tiles_left * SMASH_IMPACT_DAMAGE_PER_TILE, check_armor = TRUE)
	playsound(src, "genblunt", 100, TRUE)
	if(isclosedturf(hit_atom) && blood_volume && !(NOBLOOD in dna?.species?.species_traits))
		blood_spray(get_dir(src, hit_atom))
	return TRUE

/mob/living/proc/dodge_turf_away_from(atom/threat)
	var/static/list/away_north = list(NORTH, WEST, EAST)
	var/static/list/away_south = list(SOUTH, WEST, EAST)
	var/static/list/away_east = list(EAST, SOUTH, NORTH)
	var/static/list/away_west = list(WEST, NORTH, SOUTH)
	var/list/dirry
	var/dx = x - threat.x
	var/dy = y - threat.y
	if(abs(dx) < abs(dy))
		dirry = (dy > 0) ? away_north : away_south
	else
		dirry = (dx > 0) ? away_east : away_west
	for(var/dodge_dir in shuffle(dirry))
		var/turf/turfcheck = get_step(src, dodge_dir)
		if(check_dodge_turf(turfcheck))
			return turfcheck
	return null

/mob/living/carbon/human/proc/try_parry_pointblank_ranged(obj/projectile/P)
	if(!isliving(P.firer) || !P.fired_from)
		return FALSE
	var/mob/living/shooter = P.firer
	if(get_dist(src, shooter) > 1)
		return FALSE
	if(!istype(P, /obj/projectile/bullet/reusable/arrow) && !istype(P, /obj/projectile/bullet/reusable/bolt))
		return FALSE
	if(!cmode || pulledby || pulling)
		return FALSE
	if((shooter in grabbedby) && shooter.grab_state >= GRAB_AGGRESSIVE)
		return FALSE
	var/obj/item/parry_weapon = get_active_held_item()
	if(!parry_weapon?.can_parry)
		parry_weapon = get_inactive_held_item()
	var/can_weapon_parry = parry_weapon?.can_parry
	var/parry_bonus = 0
	var/is_parry_attempt = FALSE
	var/is_dodge_attempt = FALSE
	if(d_intent == INTENT_PARRY && can_weapon_parry)
		is_parry_attempt = TRUE
		var/skill_level = 0
		if(parry_weapon.associated_skill)
			skill_level = get_wskill(parry_weapon)
		else
			skill_level = get_skill_level(/datum/skill/combat/unarmed)
			if(!HAS_TRAIT(src, TRAIT_CIVILIZEDBARBARIAN))
				skill_level = max(0, skill_level - 2)
		parry_bonus = skill_level * 4
	else if(d_intent == INTENT_DODGE && (mobility_flags & MOBILITY_STAND))
		is_dodge_attempt = TRUE
	if(!is_parry_attempt && !is_dodge_attempt)
		return FALSE
	var/success = is_parry_attempt ? ((rand(1, 20) + parry_bonus) >= 20) : (get_stat_roll(STASPD) > get_stat_roll(shooter.STASPD))
	if(!success)
		if(client?.prefs.showrolls)
			to_chat(src, span_warning("Failed to [is_parry_attempt ? "parry" : "dodge"] point-blank shot!"))
		return FALSE
	if(is_parry_attempt)
		var/parry_result = do_parry(parry_weapon, 3, shooter)
		if(parry_result == PARRY_DISARM)
			var/disarm_msg = "<b>[src]</b> bats away [shooter]'s [P.fired_from.name]! The [parry_weapon.name] flies free from [src]'s grasp!"
			dropItemToGround(parry_weapon, TRUE)
			playsound(get_turf(src), 'sound/combat/clash_disarm_us.ogg', 100, FALSE)
			visible_message(span_boldwarning(disarm_msg), span_boldwarning(disarm_msg))
			P.setAngle(rand(0, 359))
			return TRUE
		if(parry_result != TRUE)
			return FALSE
		visible_message(span_boldwarning("<b>[src]</b> bats away [shooter]'s [P.fired_from.name], spoiling the shot!"), span_boldwarning("I knock away [shooter]'s [P.fired_from.name]!"))
		P.setAngle(rand(0, 359))
		return TRUE
	var/turf/dodge_turf = dodge_turf_away_from(shooter)
	if(!dodge_turf)
		return FALSE
	if(!do_dodge(shooter, dodge_turf))
		return FALSE
	visible_message(span_boldwarning("<b>[src]</b> dodges out of the way of [shooter]'s point-blank shot!"), span_boldwarning("I dodge [shooter]'s point-blank shot!"))
	return TRUE

/mob/living/carbon/human/proc/punch_recoil(mob/living/carbon/human/target, obj/item/bodypart/affecting, damage, armor_block, actual_damage)
	if(HAS_TRAIT(src, TRAIT_CIVILIZEDBARBARIAN) || armor_block <= 0 || gloves || !ishuman(target) || !affecting)
		return
	var/obj/item/clothing/target_armor = target.last_armor_hit?.resolve()
	if(!target_armor || ARMOR_DEGRADATION_CLASS(target_armor) != ARMOR_CLASS_HEAVY)
		return
	var/recoil_damage = (damage - actual_damage) * 0.5
	if(recoil_damage <= 0)
		return
	var/obj/item/bodypart/punching_hand = hand_bodyparts[active_hand_index]
	if(!HAS_TRAIT(src, TRAIT_NOPAIN) && COOLDOWN_FINISHED(src, recoil_pain_cooldown))
		COOLDOWN_START(src, recoil_pain_cooldown, PUNCH_RECOIL_PAIN_COOLDOWN)
		emote("pain", forced = TRUE)
	if(punching_hand)
		apply_damage(recoil_damage, BRUTE, punching_hand, 0)

/mob/living/carbon/human
	COOLDOWN_DECLARE(recoil_pain_cooldown)

/proc/dodge_weapon_modifier(mob/living/attacker, mob/living/carbon/human/defender, obj/item/I, defender_dodge_expert)
	. = 0
	if(I.wbalance == WBALANCE_SWIFT && istype(attacker.rmb_intent, /datum/rmb_intent/swift) && attacker.STASPD > defender.STASPD && !HAS_TRAIT(attacker, TRAIT_FREEBLADE))
		. -= 2
	if(I.wbalance == WBALANCE_HEAVY && istype(attacker.rmb_intent, /datum/rmb_intent/strong) && defender.STASPD > attacker.STASPD)
		. += 2
	if(!defender_dodge_expert)
		. -= attacker.get_wskill(I) * 2
	if(!I.has_wskill())
		. += 2
	else if(!defender_dodge_expert)
		. += defender.get_wskill(I) * 2

