/obj/item/clothing
	var/integ_armor_mod = ARMOR_CLASS_NONE
	var/list/zone_integrity
	var/list/zone_max_integrity
	var/list/broken_zones
	var/zone_damage_target
	var/zone_basis_max

GLOBAL_LIST_INIT(canonical_integrity_zones, list(
	BODY_ZONE_CHEST = BODY_ZONE_CHEST,
	BODY_ZONE_PRECISE_STOMACH = BODY_ZONE_CHEST,
	BODY_ZONE_PRECISE_GROIN = BODY_ZONE_PRECISE_GROIN,
	BODY_ZONE_L_ARM = BODY_ZONE_L_ARM,
	BODY_ZONE_PRECISE_L_HAND = BODY_ZONE_L_ARM,
	BODY_ZONE_R_ARM = BODY_ZONE_R_ARM,
	BODY_ZONE_PRECISE_R_HAND = BODY_ZONE_R_ARM,
	BODY_ZONE_L_LEG = BODY_ZONE_L_LEG,
	BODY_ZONE_PRECISE_L_FOOT = BODY_ZONE_L_LEG,
	BODY_ZONE_R_LEG = BODY_ZONE_R_LEG,
	BODY_ZONE_PRECISE_R_FOOT = BODY_ZONE_R_LEG,
))

/proc/canonical_integrity_zone(def_zone)
	if(!istext(def_zone))
		return null
	return CANONICAL_INTEGRITY_ZONE(def_zone)

/obj/item/clothing/Initialize(mapload)
	. = ..()
	initialize_zone_durability()

/obj/item/clothing/proc/calculate_zone_integrity(zone, base_max = max_integrity)
	var/amount = base_max
	if(zone)
		switch(zone)
			if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
				if(!(slot_flags & (ITEM_SLOT_HANDS | ITEM_SLOT_WRISTS)))
					amount = round(base_max * 0.55, 10)
			if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
				if(!(slot_flags & (ITEM_SLOT_SHOES | ITEM_SLOT_PANTS)))
					amount = round(base_max * 0.55, 10)
			else
				amount = round(base_max * 0.75, 10)
	return amount

/obj/item/clothing/proc/initialize_zone_durability()
	broken_zones = list()
	zone_integrity = null
	zone_max_integrity = null
	zone_basis_max = max_integrity
	if(!max_integrity)
		return
	if(!(body_parts_covered & (CHEST | GROIN | ARMS | LEGS | HANDS | FEET)))
		return
	zone_integrity = list()
	if(body_parts_covered & CHEST)
		zone_integrity[BODY_ZONE_CHEST] = calculate_zone_integrity(BODY_ZONE_CHEST)
	if(body_parts_covered & GROIN)
		zone_integrity[BODY_ZONE_PRECISE_GROIN] = calculate_zone_integrity(BODY_ZONE_PRECISE_GROIN)
	if(body_parts_covered & (ARM_LEFT | HAND_LEFT))
		zone_integrity[BODY_ZONE_L_ARM] = calculate_zone_integrity(BODY_ZONE_L_ARM)
	if(body_parts_covered & (ARM_RIGHT | HAND_RIGHT))
		zone_integrity[BODY_ZONE_R_ARM] = calculate_zone_integrity(BODY_ZONE_R_ARM)
	if(body_parts_covered & (LEG_LEFT | FOOT_LEFT))
		zone_integrity[BODY_ZONE_L_LEG] = calculate_zone_integrity(BODY_ZONE_L_LEG)
	if(body_parts_covered & (LEG_RIGHT | FOOT_RIGHT))
		zone_integrity[BODY_ZONE_R_LEG] = calculate_zone_integrity(BODY_ZONE_R_LEG)
	refresh_zone_max_integrity()
	update_overall_integrity()

/obj/item/clothing/proc/refresh_zone_max_integrity()
	zone_max_integrity = list()
	for(var/zone in zone_integrity)
		zone_max_integrity[zone] = calculate_zone_integrity(zone)

/obj/item/clothing/proc/sync_zone_basis()
	if(zone_basis_max == max_integrity || !zone_integrity)
		return
	for(var/zone in zone_integrity)
		var/old_max = zone_max_integrity[zone]
		var/new_max = calculate_zone_integrity(zone)
		zone_integrity[zone] = old_max ? (zone_integrity[zone] / old_max * new_max) : new_max
		zone_max_integrity[zone] = new_max
	zone_basis_max = max_integrity

/obj/item/clothing/proc/uses_zone_integrity()
	return length(zone_integrity) > 0

/obj/item/clothing/proc/has_zone_integrity(def_zone)
	if(!zone_integrity || !istext(def_zone))
		return FALSE
	var/zone = CANONICAL_INTEGRITY_ZONE(def_zone)
	return zone && !isnull(zone_integrity[zone])

/obj/item/clothing/proc/get_zone_max_integrity(def_zone)
	if(!zone_integrity || !istext(def_zone))
		return max_integrity
	var/zone = CANONICAL_INTEGRITY_ZONE(def_zone)
	if(!zone || isnull(zone_integrity[zone]))
		return max_integrity
	if(zone_basis_max != max_integrity)
		sync_zone_basis()
	return zone_max_integrity[zone]

/obj/item/clothing/proc/get_zone_integrity(def_zone)
	if(!zone_integrity || !istext(def_zone))
		return obj_integrity
	var/zone = CANONICAL_INTEGRITY_ZONE(def_zone)
	if(!zone || isnull(zone_integrity[zone]))
		return obj_integrity
	if(zone_basis_max != max_integrity)
		sync_zone_basis()
	return zone_integrity[zone]

/// Integrity fraction: the ONE definition of "how intact is this", used everywhere.
/// 1 = pristine, 0 = broken. Non-zoned items break at integrity_failure, so the fraction is
/// measured over the usable range above that threshold. Zones break at 0, so a zone's raw ratio already fits.
/obj/item/proc/get_integrity_fraction()
	if(obj_broken || !max_integrity)
		return 0
	var/break_threshold = max_integrity * integrity_failure
	var/usable = max_integrity - break_threshold
	if(usable <= 0)
		return 0
	return clamp((obj_integrity - break_threshold) / usable, 0, 1)

/obj/item/clothing/get_integrity_fraction()
	if(!uses_zone_integrity())
		return ..()
	if(obj_broken)
		return 0
	return get_overall_zone_ratio()

/// Integrity fraction for a specific body zone. Falls back to the whole-item fraction for
/// items (or zones) without per-zone integrity, e.g. helmets and masks.
/obj/item/clothing/proc/get_zone_integrity_ratio(def_zone)
	if(!zone_integrity || !istext(def_zone))
		return get_integrity_fraction()
	var/zone = CANONICAL_INTEGRITY_ZONE(def_zone)
	if(!zone || isnull(zone_integrity[zone]))
		return get_integrity_fraction()
	if(zone_basis_max != max_integrity)
		sync_zone_basis()
	var/zone_max = zone_max_integrity[zone]
	return zone_max ? (zone_integrity[zone] / zone_max) : 0

/obj/item/clothing/proc/modify_zone_integrity(def_zone, delta)
	if(!has_zone_integrity(def_zone))
		return null
	sync_zone_basis()
	var/zone = canonical_integrity_zone(def_zone)
	zone_integrity[zone] = clamp(zone_integrity[zone] + delta, 0, get_zone_max_integrity(zone))
	if(zone_integrity[zone] <= 0)
		broken_zones |= zone
	return zone_integrity[zone]

/obj/item/clothing/proc/set_zone_integrity_ratio(def_zone, ratio)
	if(!has_zone_integrity(def_zone))
		return
	sync_zone_basis()
	var/zone = canonical_integrity_zone(def_zone)
	zone_integrity[zone] = clamp(ratio, 0, 1) * get_zone_max_integrity(zone)
	if(zone_integrity[zone] > 0)
		broken_zones -= zone
	else
		broken_zones |= zone

/obj/item/clothing/proc/get_zone_name(def_zone)
	switch(canonical_integrity_zone(def_zone))
		if(BODY_ZONE_CHEST)
			return "chest"
		if(BODY_ZONE_PRECISE_GROIN)
			return "groin"
		if(BODY_ZONE_L_ARM)
			return "left arm"
		if(BODY_ZONE_R_ARM)
			return "right arm"
		if(BODY_ZONE_L_LEG)
			return "left leg"
		if(BODY_ZONE_R_LEG)
			return "right leg"
	return "unknown"

/obj/item/clothing/proc/get_overall_zone_ratio()
	var/total = 0
	var/total_max = 0
	sync_zone_basis()
	for(var/zone in zone_integrity)
		total += zone_integrity[zone]
		total_max += get_zone_max_integrity(zone)
	return total_max ? (total / total_max) : 0

/obj/item/clothing/proc/all_zones_destroyed()
	for(var/zone in zone_integrity)
		if(zone_integrity[zone] > 0)
			return FALSE
	return TRUE

/obj/item/clothing/proc/update_overall_integrity(force = FALSE)
	if(!uses_zone_integrity())
		return
	refresh_zone_break_visual()
	if(obj_broken && !force)
		return
	var/break_threshold = max_integrity * integrity_failure
	if(all_zones_destroyed())
		obj_integrity = break_threshold
		return
	obj_integrity = max(break_threshold + (max_integrity - break_threshold) * get_overall_zone_ratio(), break_threshold + DAMAGE_PRECISION)

/obj/item/clothing/proc/damage_zone(def_zone, damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, armor_penetration = 0)
	if(!has_zone_integrity(def_zone))
		return take_damage(damage_amount, damage_type, damage_flag, sound_effect, null, armor_penetration)
	zone_damage_target = canonical_integrity_zone(def_zone)
	. = take_damage(damage_amount, damage_type, damage_flag, sound_effect, null, armor_penetration)
	zone_damage_target = null

/obj/item/clothing/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir, armor_penetration = 0, object_damage_multiplier = 1)
	if(zone_damage_target && armor_penetration >= 100)
		return damage_amount * object_damage_multiplier * (damage_flag == "acid" ? ACID_DURABILITY_MULT : 1)
	return ..()

/obj/item/clothing/apply_integrity_damage(damage_amount)
	if(!uses_zone_integrity() || obj_broken)
		return ..()
	if(zone_damage_target)
		modify_zone_integrity(zone_damage_target, -damage_amount)
	else
		var/split_damage = round(damage_amount / min(length(zone_integrity), 3), 1)
		for(var/zone in zone_integrity)
			modify_zone_integrity(zone, -split_damage)
	update_overall_integrity()

/obj/item/clothing/proc/copy_zone_integrity(obj/item/clothing/source)
	if(!istype(source))
		return
	if(!source.uses_zone_integrity() || !uses_zone_integrity())
		set_integrity_fraction(source.get_integrity_fraction())
		return
	for(var/zone in zone_integrity)
		if(source.has_zone_integrity(zone))
			set_zone_integrity_ratio(zone, source.get_zone_integrity_ratio(zone))
	update_overall_integrity()

/obj/item/clothing/proc/restore_all_zones()
	if(!uses_zone_integrity())
		return
	zone_basis_max = max_integrity
	refresh_zone_max_integrity()
	for(var/zone in zone_integrity)
		zone_integrity[zone] = zone_max_integrity[zone]
	broken_zones.Cut()
	update_overall_integrity()

/obj/item/clothing/proc/integrity_display_ratio(def_zone)
	if(def_zone && has_zone_integrity(def_zone))
		return get_zone_integrity_ratio(def_zone)
	return get_integrity_fraction()

GLOBAL_LIST_INIT(integrity_display_zones, list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))

/obj/item/clothing/proc/durability_inspect_text()
	var/text = "\n<b>DURABILITY:</b>"
	for(var/zone in GLOB.integrity_display_zones)
		if(!has_zone_integrity(zone))
			continue
		var/percent = round(get_zone_integrity_ratio(zone) * 100, 1)
		text += "\n  <b>[capitalize(get_zone_name(zone))]:</b> [percent]% ([floor(get_zone_integrity(zone))])"
	return text

/// Sets obj_integrity. Zoned clothing distributes the change across its zones so both always agree.
/obj/proc/set_integrity(value)
	obj_integrity = clamp(value, 0, max_integrity)

/obj/item/clothing/set_integrity(value)
	if(!uses_zone_integrity())
		return ..()
	sync_zone_basis()
	var/break_threshold = max_integrity * integrity_failure
	var/usable = max_integrity - break_threshold
	var/target = usable > 0 ? clamp((value - break_threshold) / usable, 0, 1) : 0
	var/total = 0
	var/total_max = 0
	for(var/zone in zone_integrity)
		total += zone_integrity[zone]
		total_max += zone_max_integrity[zone]
	var/current = total_max ? (total / total_max) : 0
	for(var/zone in zone_integrity)
		var/zone_max = zone_max_integrity[zone]
		if(target >= 1)
			zone_integrity[zone] = zone_max
		else if(target > current)
			zone_integrity[zone] += (zone_max - zone_integrity[zone]) * ((target - current) / (1 - current))
		else if(current > 0)
			zone_integrity[zone] *= target / current
		if(zone_integrity[zone] > 0)
			broken_zones -= zone
		else
			broken_zones |= zone
	if(value < break_threshold)
		obj_integrity = clamp(value, 0, max_integrity)
	else
		update_overall_integrity(TRUE)

/// Sets max_integrity. Zoned clothing rescales its zones and keeps obj_integrity derived from them.
/obj/proc/set_max_integrity(new_max)
	max_integrity = new_max

/obj/item/clothing/set_max_integrity(new_max)
	. = ..()
	if(uses_zone_integrity())
		sync_zone_basis()
		update_overall_integrity()

/obj/item/clothing/force_obj_break(damage_flag = "")
	if(!obj_broken && integrity_failure && uses_zone_integrity())
		for(var/zone in zone_integrity)
			zone_integrity[zone] = 0
			broken_zones |= zone
	return ..()

/obj/proc/adjust_integrity(amount)
	var/old_integrity = obj_integrity
	obj_integrity = clamp(obj_integrity + amount, 0, max_integrity)
	return obj_integrity - old_integrity

/obj/item/clothing/adjust_integrity(amount)
	if(!uses_zone_integrity())
		return ..()
	var/old_integrity = obj_integrity
	for(var/zone in zone_integrity)
		modify_zone_integrity(zone, amount)
		if(zone_integrity[zone] > 0)
			broken_zones -= zone
	update_overall_integrity(TRUE)
	return obj_integrity - old_integrity

/// Inverse of get_integrity_fraction(): 0 puts the item at its break threshold, 1 at max.
/obj/item/proc/integrity_needs_repair()
	return max_integrity && obj_integrity < max_integrity

/obj/item/clothing/integrity_needs_repair()
	if(..())
		return TRUE
	if(!uses_zone_integrity())
		return FALSE
	for(var/zone in zone_integrity)
		if(zone_integrity[zone] < get_zone_max_integrity(zone))
			return TRUE
	return FALSE

/obj/item/proc/set_integrity_fraction(fraction)
	var/break_threshold = max_integrity * integrity_failure
	obj_integrity = break_threshold + (max_integrity - break_threshold) * clamp(fraction, 0, 1)

/obj/item/clothing/set_integrity_fraction(fraction)
	if(!uses_zone_integrity())
		return ..()
	for(var/zone in zone_integrity)
		set_zone_integrity_ratio(zone, fraction)
	update_overall_integrity(TRUE)

/obj/item/proc/copy_integrity_from(obj/item/source)
	set_integrity_fraction(source.get_integrity_fraction())
	if(source.obj_broken && !obj_broken)
		force_obj_break()

/obj/item/clothing/copy_integrity_from(obj/item/source)
	if(!istype(source, /obj/item/clothing))
		return ..()
	copy_zone_integrity(source)
	if(source.obj_broken && !obj_broken)
		force_obj_break()

/obj/item/clothing/clamps_break_damage()
	return obj_broken || !uses_zone_integrity()

/obj/item/clothing/examine(mob/user)
	. = ..()
	if(!uses_zone_integrity() || obj_broken || !integrity_needs_repair())
		return
	var/list/zone_lines = list()
	for(var/zone in GLOB.integrity_display_zones)
		if(has_zone_integrity(zone))
			zone_lines += "[capitalize(get_zone_name(zone))]: [round(get_zone_integrity_ratio(zone) * 100, 1)]%"
	if(length(zone_lines))
		. += span_warning(jointext(zone_lines, " | "))

/obj/item/clothing/proc/announce_breaches(broken_before)
	if(obj_broken || !isliving(loc))
		return
	var/mob/living/wearer = loc
	for(var/i in broken_before + 1 to length(broken_zones))
		wearer.visible_message(span_danger("The [name]'s [get_zone_name(broken_zones[i])] has been breached!"))

/mob/living/proc/acid_armor_message(def_zone)
	return ""

/mob/living/carbon/human/acid_armor_message(def_zone)
	var/obj/item/clothing/sizzling = get_best_armor(def_zone, "acid")
	if(!sizzling)
		return ""
	return " <span class='warning'>The [sizzling.name] begins to sizzle!</span>"

/obj/item/clothing
	var/shown_zone_break = FALSE

/obj/item/clothing/proc/refresh_zone_break_visual()
	var/zone_broken = length(broken_zones) > 0
	if(zone_broken == shown_zone_break)
		return
	shown_zone_break = zone_broken
	update_damaged_state()

/obj/item/clothing/update_damaged_state()
	if(obj_broken || !length(broken_zones))
		return ..()
	cut_overlays()
	var/icon/damaged_icon = icon(initial(icon), icon_state, , TRUE)
	damaged_icon.Blend("#fff", ICON_ADD)
	damaged_icon.Blend(icon(dam_icon, dam_icon_state), ICON_MULTIPLY)
	var/mutable_appearance/damage = new(damaged_icon)
	damage.alpha = 150
	add_overlay(damage)
