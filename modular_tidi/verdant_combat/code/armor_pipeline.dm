#define PIECE_EFFECTIVENESS(piece, integrity_ratio, light_floor) armor_zone_effectiveness(integrity_ratio, ((light_floor) && (piece).armor_class == ARMOR_CLASS_NONE) ? ARMOR_CLASS_LIGHT : (piece).armor_class)
#define PIECE_BLUNT_MODIFIER(piece, effectiveness, def_zone, apply_vital_bonus) blunt_ap_modifier(ARMOR_DEGRADATION_CLASS(piece), effectiveness, def_zone, apply_vital_bonus)

GLOBAL_LIST_INIT(armor_type_by_bclass, list(
	BCLASS_BLUNT = "blunt",
	BCLASS_SMASH = "blunt",
	BCLASS_TWIST = "blunt",
	BCLASS_PUNCH = "blunt",
	BCLASS_CHOP = "slash",
	BCLASS_CUT = "slash",
	BCLASS_LASHING = "slash",
	BCLASS_PUNISH = "slash",
	BCLASS_PICK = "stab",
	BCLASS_STAB = "stab",
	BCLASS_BITE = "stab",
	BCLASS_PIERCE = "piercing",
	BCLASS_BURN = "fire",
))

/proc/armor_zone_effectiveness(integrity_ratio, armor_class)
	var/damage_percent = round(integrity_ratio * 100, 1)
	if(damage_percent >= 100)
		return 1.0
	var/floor_reduction = 0
	switch(armor_class)
		if(ARMOR_CLASS_HEAVY)
			floor_reduction = 50
		if(ARMOR_CLASS_MEDIUM)
			floor_reduction = 60
		if(ARMOR_CLASS_LIGHT)
			floor_reduction = 70
	return 1.0 - ((100 - damage_percent) / 100 * (floor_reduction / 100))

/proc/armor_integrity_damage(damage, armor_penetration, protection)
	if((damage + armor_penetration) > protection)
		return (damage + armor_penetration) - protection
	var/blocked_damage = protection - (damage + armor_penetration)
	return damage * 0.3 + (blocked_damage * 0.15)

/proc/armor_degradation_mult(armor_class, blade_dulling)
	switch(blade_dulling)
		if(BCLASS_BLUNT, BCLASS_SMASH)
			switch(armor_class)
				if(ARMOR_CLASS_LIGHT)
					return ARMOR_DEGR_BLUNT_LIGHT
				if(ARMOR_CLASS_MEDIUM)
					return ARMOR_DEGR_BLUNT_MEDIUM
				if(ARMOR_CLASS_HEAVY)
					return ARMOR_DEGR_BLUNT_HEAVY
		if(BCLASS_CUT, BCLASS_CHOP)
			switch(armor_class)
				if(ARMOR_CLASS_LIGHT)
					return ARMOR_DEGR_CUT_LIGHT
				if(ARMOR_CLASS_MEDIUM)
					return ARMOR_DEGR_CUT_MEDIUM
				if(ARMOR_CLASS_HEAVY)
					return ARMOR_DEGR_CUT_HEAVY
		if(BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE)
			switch(armor_class)
				if(ARMOR_CLASS_LIGHT)
					return ARMOR_DEGR_PIERCE_LIGHT
				if(ARMOR_CLASS_MEDIUM)
					return ARMOR_DEGR_PIERCE_MEDIUM
				if(ARMOR_CLASS_HEAVY)
					return ARMOR_DEGR_PIERCE_HEAVY
	return 1.0

/proc/blunt_ap_modifier(effective_class, effectiveness, def_zone, apply_vital_bonus = TRUE)
	var/blunt_modifier = 0
	var/damage_factor = (1 - effectiveness) * 2
	switch(effective_class)
		if(ARMOR_CLASS_LIGHT)
			blunt_modifier = BLUNT_AP_MOD_LIGHT
		if(ARMOR_CLASS_MEDIUM)
			blunt_modifier = BLUNT_AP_MOD_MEDIUM * damage_factor
		if(ARMOR_CLASS_HEAVY)
			blunt_modifier = BLUNT_AP_MOD_HEAVY * damage_factor
	if(apply_vital_bonus)
		var/armor_penalty = 0
		if(def_zone == BODY_ZONE_CHEST)
			switch(effective_class)
				if(ARMOR_CLASS_HEAVY)
					armor_penalty = 26 * effectiveness
				if(ARMOR_CLASS_MEDIUM)
					armor_penalty = 18 * effectiveness
				if(ARMOR_CLASS_LIGHT)
					armor_penalty = 8 * effectiveness
		if(def_zone == BODY_ZONE_HEAD)
			switch(effective_class)
				if(ARMOR_CLASS_HEAVY)
					armor_penalty = 12 * effectiveness
				if(ARMOR_CLASS_MEDIUM)
					armor_penalty = 10 * effectiveness
				if(ARMOR_CLASS_LIGHT)
					armor_penalty = 8 * effectiveness
		blunt_modifier -= armor_penalty
	return blunt_modifier

/proc/armor_actual_damage(raw_damage, armor, damage_type)
	var/damage_threshold = armor / 2
	if(raw_damage < damage_threshold)
		return 0
	var/is_burn = (damage_type == "fire") || (damage_type in GLOB.charring_bclasses)
	if(!is_burn && prob(damage_threshold))
		return 0
	return max(floor(raw_damage * (1 - (armor / 100))), 0)

/proc/armor_blunts_attack(damage, armor, wound_class)
	if(damage <= 0 || armor <= 0 || !wound_class)
		return FALSE
	var/static/list/bluntable_classes = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_DRILL, BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE, BCLASS_LASHING)
	if(!(wound_class in bluntable_classes))
		return FALSE
	return damage < armor

/mob/living/carbon/human
	var/datum/weakref/last_armor_hit

/mob/living/carbon/human/proc/worn_armor_slots()
	return list(skin_armor, head, wear_mask, wear_wrists, gloves, wear_neck, cloak, wear_armor, wear_shirt, shoes, wear_pants, backr, backl, belt, s_store, glasses, ears, wear_ring)

/mob/living/carbon/human/proc/armor_zone(def_zone)
	if(isbodypart(def_zone))
		var/obj/item/bodypart/CBP = def_zone
		def_zone = CBP.body_zone
	switch(def_zone)
		if(BODY_ZONE_TAUR)
			return pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
		if(BODY_ZONE_PRECISE_L_FOOT)
			if(get_taur_tail())
				return BODY_ZONE_L_LEG
		if(BODY_ZONE_PRECISE_R_FOOT)
			if(get_taur_tail())
				return BODY_ZONE_R_LEG
	return def_zone

/mob/living/carbon/human/proc/blunt_vital_bonus_applies(obj/item/used_weapon, mob/living/attacker)
	var/is_unarmed_weapon = FALSE
	if(istype(used_weapon, /obj/item/rogueweapon))
		var/obj/item/rogueweapon/RW = used_weapon
		if(RW.associated_skill == /datum/skill/combat/unarmed)
			is_unarmed_weapon = TRUE
	if(!used_weapon || is_unarmed_weapon)
		if(!attacker || !HAS_TRAIT(attacker, TRAIT_CIVILIZEDBARBARIAN))
			return FALSE
	return TRUE

/mob/living/carbon/human/proc/covering_armor(def_zone, d_type, armor_penetration, bypass_item, blunt_applies, vital_penalties, apply_vital_bonus, no_crush = FALSE)
	var/list/covering = list()
	for(var/obj/item/clothing/C in worn_armor_slots())
		if(bypass_item && (C == bypass_item || (islist(bypass_item) && (C in bypass_item))))
			continue
		if(!zone2covered(def_zone, C.body_parts_covered_dynamic))
			continue
		if(QDELETED(C) || !C.armor || C.obj_broken)
			continue
		var/effectiveness = 1.0
		if(C.max_integrity)
			var/integrity_ratio = C.get_zone_integrity_ratio(def_zone)
			if(integrity_ratio <= 0)
				continue
			effectiveness = PIECE_EFFECTIVENESS(C, integrity_ratio, !vital_penalties)
		var/val = C.armor.getRating(d_type)
		if(val <= 0)
			continue
		var/blunt_modifier = blunt_applies ? PIECE_BLUNT_MODIFIER(C, effectiveness, vital_penalties ? def_zone : null, apply_vital_bonus) : 0
		if(no_crush)
			blunt_modifier = min(blunt_modifier, 0)
		covering[C] = max(val * effectiveness - (armor_penetration + blunt_modifier), 0)
	return covering

/mob/living/carbon/human/proc/get_best_armor(def_zone, d_type, blade_dulling = null, armor_penetration = 0, mob/living/attacker)
	if(!d_type)
		return null
	def_zone = armor_zone(def_zone)
	d_type = NORMALIZE_ARMOR_TYPE(d_type)
	var/blunt_applies = d_type == "blunt" && (blade_dulling == BCLASS_BLUNT || blade_dulling == BCLASS_SMASH || (blade_dulling == BCLASS_PUNCH && attacker && HAS_TRAIT(attacker, TRAIT_CIVILIZEDBARBARIAN)))
	var/list/covering = covering_armor(def_zone, d_type, armor_penetration, null, blunt_applies, FALSE, FALSE)
	var/obj/item/clothing/best
	var/best_value = 0
	for(var/obj/item/clothing/C as anything in covering)
		if(covering[C] > best_value)
			best_value = covering[C]
			best = C
	return best

/mob/living/carbon/human/getarmor(def_zone, type, damage, armor_penetration = 0, blade_dulling, intdamfactor = 1, bypass_item = null, obj/item/used_weapon, mob/living/attacker, no_debuff = FALSE)
	type = NORMALIZE_ARMOR_TYPE(type)
	if(def_zone)
		return checkarmor(def_zone, type, damage, armor_penetration, blade_dulling, intdamfactor, bypass_item, used_weapon, attacker, no_debuff)
	var/armorval = 0
	var/organnum = 0
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		armorval += checkarmor(BP, type, damage, armor_penetration)
		organnum++
	return (armorval / max(organnum, 1))

/mob/living/carbon/human/proc/checkarmor(def_zone, d_type, damage, armor_penetration = 0, blade_dulling, intdamfactor = 1, bypass_item = null, obj/item/used_weapon, mob/living/attacker, no_debuff = FALSE)
	if(!d_type)
		return 0
	def_zone = armor_zone(def_zone)
	if(HAS_TRAIT(src, TRAIT_IRONMAN))
		playsound(loc, get_armor_sound(PLATEHIT, blade_dulling), 100)

	var/blunt_applies = d_type == "blunt"
	var/apply_vital_bonus = blunt_applies && blunt_vital_bonus_applies(used_weapon, attacker)
	var/no_crush = istype(used_weapon, /obj/projectile/magic)
	var/list/covering = covering_armor(def_zone, d_type, armor_penetration, bypass_item, blunt_applies, TRUE, apply_vital_bonus, no_crush)
	var/obj/item/clothing/used
	var/best_effective_armor = 0
	for(var/obj/item/clothing/C as anything in covering)
		if(covering[C] > best_effective_armor)
			best_effective_armor = covering[C]
			used = C
	if(damage)
		last_armor_hit = used ? WEAKREF(used) : null

	var/protection = 0
	var/armor_effectiveness = 1.0
	var/used_blunt_modifier = 0
	if(used)
		protection = used.armor.getRating(d_type)
		if(used.max_integrity)
			armor_effectiveness = PIECE_EFFECTIVENESS(used, used.get_zone_integrity_ratio(def_zone), FALSE)
		if(blunt_applies)
			used_blunt_modifier = PIECE_BLUNT_MODIFIER(used, armor_effectiveness, def_zone, apply_vital_bonus)
			if(no_crush)
				used_blunt_modifier = min(used_blunt_modifier, 0)
	if(used && damage)
		if(!blade_dulling)
			blade_dulling = BCLASS_BLUNT
		if(used.blocksound)
			playsound(loc, get_armor_sound(used.blocksound, blade_dulling), 100)
		var/intdamage = armor_integrity_damage(damage, armor_penetration, protection)
		if(intdamfactor != 1)
			intdamage *= intdamfactor
		if(has_status_effect(/datum/status_effect/buff/iron_skin))
			intdamage *= 0.75
		var/consume_debuff = !no_debuff && !istype(used_weapon, /obj/projectile) && (best_effective_armor >= damage)
		if(consume_debuff)
			if(has_status_effect(/datum/status_effect/debuff/exposed))
				intdamage *= EXPOSED_INTEG_MOD
				playsound(src, 'sound/combat/exposed_pop.ogg', 100, TRUE)
				visible_message("<span class = 'combatsecondarybodypart'>[src] suffers a savage hit to their armor while exposed!</span>")
				remove_status_effect(/datum/status_effect/debuff/exposed)
				emote("pain", forced = TRUE)
			else if(has_status_effect(/datum/status_effect/debuff/vulnerable))
				intdamage *= VULN_INTEG_MOD
				playsound(src, 'sound/combat/vulnerable_pop.ogg', 100, TRUE)
				visible_message(span_biginfo("[src] is struck into their armor while vulnerable!"))
				remove_status_effect(/datum/status_effect/debuff/vulnerable)
				emote("groan", forced = TRUE)
		damage_armor_layers(def_zone, d_type, intdamage, blade_dulling, used, covering, used_weapon)
	protection *= armor_effectiveness
	if(used_blunt_modifier)
		protection = max(protection - used_blunt_modifier, 0)
	if(physiology)
		protection += physiology.armor.getRating(d_type)
	return protection

/mob/living/carbon/human/proc/damage_armor_layers(def_zone, d_type, intdamage, blade_dulling, obj/item/clothing/used, list/covering, obj/item/used_weapon)
	var/list/layers = list(used)
	var/list/rest = covering.Copy()
	rest -= used
	while(length(rest))
		var/obj/item/clothing/next
		for(var/obj/item/clothing/C as anything in rest)
			if(!next || rest[C] > rest[next])
				next = C
		layers += next
		rest -= next
	var/total_layers = length(layers)
	var/depth = 1
	var/static/list/cursed_ingots = list(/obj/item/ingot/aaslag, /obj/item/ingot/aalloy, /obj/item/ingot/purifiedaalloy, /obj/item/ingot/component/zizo, /obj/item/ingot/component/graggar, /obj/item/ingot/component/matthios, /obj/item/ingot/component/baotha, /obj/item/ingot/avantyne, /obj/item/ingot/vampire)
	for(var/obj/item/clothing/layer as anything in layers)
		var/layer_damage = intdamage / depth
		if(istype(used_weapon) && used_weapon.is_silver && ((layer.smeltresult in cursed_ingots) || layer.GetComponent(/datum/component/cursed_item)))
			var/datum/component/silverbless/bless = used_weapon.GetComponent(/datum/component/silverbless)
			if(bless?.is_blessed)
				layer_damage = round(layer_damage * bless.cursed_item_intdamage)
		layer_damage *= armor_degradation_mult(ARMOR_DEGRADATION_CLASS(layer), blade_dulling)
		if(layer.uses_zone_integrity())
			layer.damage_zone(def_zone, layer_damage, damage_flag = d_type, sound_effect = FALSE, armor_penetration = 100)
		else
			layer.take_damage(layer_damage, damage_flag = d_type, sound_effect = FALSE, armor_penetration = 100)
		if(layer_damage > 0)
			SEND_SIGNAL(src, COMSIG_MOB_ARMOR_INTEGRITY_DAMAGED, layer_damage, layer, depth, total_layers)
		depth++

/mob/living/carbon/proc/get_armor_class(def_zone, d_type)
	if(!ishuman(src))
		return ARMOR_CLASS_NONE
	var/mob/living/carbon/human/H = src
	var/obj/item/clothing/C = H.get_best_armor(def_zone, d_type)
	if(!C)
		return ARMOR_CLASS_NONE
	return C.armor_class

/mob/living/proc/armor_reduced_damage(raw_damage, armor, damage_type)
	return max(floor(raw_damage * (100 - clamp(armor, 0, 100)) / 100), 0)

/mob/living/carbon/human/armor_reduced_damage(raw_damage, armor, damage_type)
	return armor_actual_damage(raw_damage, armor, damage_type)

/proc/shield_degradation_mult(obj/item/shield, attacker_bclass)
	if(!attacker_bclass || !shield)
		return 1.0
	if(ispath(shield.anvilrepair, /datum/skill/craft/carpentry))
		if(attacker_bclass == BCLASS_CHOP)
			return ARMOR_DEGR_CUT_LIGHT
		return 1.0
	if(!ispath(shield.smeltresult, /obj/item/ingot) && !ispath(shield.anvilrepair, /datum/skill/craft/weaponsmithing) && !ispath(shield.anvilrepair, /datum/skill/craft/blacksmithing) && !ispath(shield.anvilrepair, /datum/skill/craft/armorsmithing))
		return 1.0
	switch(attacker_bclass)
		if(BCLASS_BLUNT, BCLASS_SMASH)
			return ARMOR_DEGR_BLUNT_HEAVY
		if(BCLASS_CUT, BCLASS_CHOP)
			return ARMOR_DEGR_CUT_HEAVY
		if(BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE)
			return ARMOR_DEGR_PIERCE_HEAVY
	return 1.0

#undef PIECE_EFFECTIVENESS
#undef PIECE_BLUNT_MODIFIER
