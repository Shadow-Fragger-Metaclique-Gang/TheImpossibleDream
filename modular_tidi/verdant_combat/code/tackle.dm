/mob/living/carbon/human/proc/try_tackle(mob/living/carbon/target, datum/thrownthing/throwingdatum)
	if(!target || !iscarbon(target))
		return FALSE
	if(!Adjacent(target))
		return FALSE
	if(target == src)
		return FALSE
	if(stat || target.stat)
		return FALSE

	if(target.has_status_effect(/datum/status_effect/buff/clash))
		tackle_fall(throwingdatum)
		visible_message(span_warning("[src] charges at [target], but is repelled by their guard!"), span_warning("I charge at [target] but am repelled by their guard!"))
		return FALSE

	var/angle_diff = abs(dir2angle(get_dir(src, target)) - dir2angle(target.dir))
	if(angle_diff > 180)
		angle_diff = 360 - angle_diff
	var/direction_bonus
	if(angle_diff <= 45)
		direction_bonus = 50
	else if(angle_diff <= 135)
		direction_bonus = 10
	else if(target.cmode)
		direction_bonus = -50
	else
		direction_bonus = -25

	var/tackler_wrestling = mind ? get_skill_level(/datum/skill/combat/wrestling) : 0
	var/target_wrestling = target.mind ? target.get_skill_level(/datum/skill/combat/wrestling) : 0
	var/tackler_armor_weight = highest_ac_worn()
	var/target_armor_weight = 0
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		target_armor_weight = human_target.highest_ac_worn()
	var/tackler_is_lighter = target_armor_weight > tackler_armor_weight
	var/armor_bonus = abs(target_armor_weight - tackler_armor_weight) * 5

	var/tackle_chance = 50 + direction_bonus
	tackle_chance += (STASTR - target.STASTR) * 3
	tackle_chance += (STACON - target.STACON) * 3
	tackle_chance += (tackler_wrestling - target_wrestling) * 8
	tackle_chance += tackler_is_lighter ? armor_bonus : -armor_bonus
	tackle_chance = clamp(tackle_chance, 5, 95)
	if(client?.prefs.showrolls)
		to_chat(src, span_info("Tackle chance: [tackle_chance]%!"))

	visible_message(span_danger("[src] charges at [target]!"), span_danger("I charge at [target]!"))
	if(!prob(tackle_chance))
		tackle_fall(throwingdatum)
		visible_message(span_warning("[src] fails to tackle [target] and falls!"), span_warning("I fail to tackle [target] and fall!"))
		return FALSE

	is_jumping = FALSE
	throwing = null
	if(throwingdatum)
		throwingdatum.extra = FALSE
	forceMove(get_turf(target))
	target.Knockdown(30)
	Knockdown(30)

	var/resist_chance = 50
	resist_chance += (target.STASTR - STASTR) * 3
	resist_chance += (target.STACON - STACON) * 3
	resist_chance += (target_wrestling - tackler_wrestling) * 8
	resist_chance += tackler_is_lighter ? -armor_bonus : armor_bonus
	resist_chance = clamp(resist_chance, 5, 95)
	if(target.client?.prefs.showrolls)
		to_chat(target, span_info("Tackle resistance chance: [resist_chance]%!"))

	playsound(get_turf(src), "punch_hard", 100, TRUE)
	playsound(get_turf(src), "bodyfall", 100, TRUE)
	if(prob(resist_chance))
		visible_message(span_boldwarning("[src] tackles [target] to the ground, but [target] resists the grapple!"), span_boldwarning("I tackle [target] to the ground, but they resist my grapple!"))
		return TRUE
	target.Stun(15)
	target.drop_all_held_items()
	visible_message(span_boldwarning("[src] tackles [target] to the ground!"), span_boldwarning("I tackle [target] to the ground!"))
	addtimer(CALLBACK(src, PROC_REF(tackle_grapple_check), target), 1)
	return TRUE

/mob/living/carbon/human/proc/tackle_fall(datum/thrownthing/throwingdatum)
	is_jumping = FALSE
	if(throwingdatum)
		throwingdatum.extra = FALSE
	Knockdown(30)
	Immobilize(2 SECONDS)
	drop_all_held_items()
	stamina_add(20)
	playsound(get_turf(src), "bodyfall", 100, TRUE)

/mob/living/carbon/human/proc/tackle_grapple_check(mob/living/carbon/human/target)
	if(!target || QDELETED(target))
		return
	target.grabbedby(src, TRUE)
	if(pulling != target)
		return
	target.grippedby(src, TRUE)
