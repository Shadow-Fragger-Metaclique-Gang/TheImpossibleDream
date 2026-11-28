/mob/living/proc/skill_fatigue_mult(skill_used)
	if(!skill_used)
		return 1
	return max(1 - get_skill_level(skill_used) * FATIGUE_SKILL_REDUCTION_PER_RANK, 0)

/mob/proc/fatigue_skill_for(obj/item/held, fallback = /datum/skill/combat/unarmed)
	if(!held)
		return fallback
	if(held.has_wskill())
		return get_wskill_type(held)
	return held.associated_skill

/proc/struck_object_skill(blade_dulling, obj/item/tool)
	switch(blade_dulling)
		if(DULLING_CUT)
			return /datum/skill/labor/lumberjacking
		if(DULLING_PICK)
			return /datum/skill/labor/mining
	return tool?.associated_skill

/mob/living
	var/battered = 0
	var/last_battered = 0
	var/last_battered_decay = 0
	var/list/battered_floors
	var/max_stamina_base = 100

/mob/living/calculate_stamina()
	. = ..()
	max_stamina_base = max_stamina
	max_stamina = max(max_stamina - get_battered(), 1)

/mob/living/proc/get_battered()
	var/floor = 0
	for(var/source in battered_floors)
		floor = max(floor, battered_floors[source])
	return max(battered, floor)

/mob/living/proc/battered_add(amount)
	if(amount <= 0 || HAS_TRAIT(src, TRAIT_INFINITE_STAMINA))
		return
	battered = min(battered + amount, max_stamina_base * BATTERED_CAP_RATIO)
	last_battered = world.time
	last_battered_decay = world.time
	apply_battering()

/mob/living/proc/set_battered_floor(source, amount)
	amount = round(min(amount, max_stamina_base * BATTERED_CAP_RATIO), 1)
	if(amount <= 0)
		if(!LAZYACCESS(battered_floors, source))
			return
		LAZYREMOVE(battered_floors, source)
	else
		if(LAZYACCESS(battered_floors, source) == amount)
			return
		LAZYSET(battered_floors, source, amount)
	apply_battering()

/mob/living/proc/apply_battering()
	calculate_stamina()
	if(stamina >= max_stamina)
		stamina_add(0)
	else
		update_health_hud()

/mob/living/handle_stamina_regen()
	if(battered > 0 && world.time > last_battered + BATTERED_DECAY_DELAY)
		var/elapsed = world.time - max(last_battered_decay, last_battered + BATTERED_DECAY_DELAY)
		battered = max(battered - BATTERED_DECAY_PER_SECOND * elapsed / (1 SECONDS), 0)
		last_battered_decay = world.time
	return ..()

/obj/item/bodypart/chest/bodypart_attacked_by(bclass = BCLASS_BLUNT, dam, mob/living/user, zone_precise = src.body_zone, silent = FALSE, crit_message = FALSE, armor, was_blunted = FALSE, raw_damage = 0, armor_block = 0, obj/item/weapon, no_crit = FALSE, no_debuff = FALSE)
	. = ..()
	if(!owner || dam <= 0 || zone_precise != BODY_ZONE_PRECISE_STOMACH || bclass != BCLASS_BLUNT)
		return
	if(armor_block >= raw_damage / 2)
		return
	owner.winding_hit("gut_wind", dam * 0.2)

/obj/item/bodypart/head/bodypart_attacked_by(bclass = BCLASS_BLUNT, dam, mob/living/user, zone_precise = src.body_zone, silent = FALSE, crit_message = FALSE, armor, was_blunted = FALSE, raw_damage = 0, armor_block = 0, obj/item/weapon, no_crit = FALSE, no_debuff = FALSE)
	. = ..()
	if(!owner || dam <= 0 || armor_block >= raw_damage / 2)
		return
	owner.winding_hit("head_wind", (bclass == BCLASS_BLUNT) ? dam * 0.25 : dam * 0.15)

/mob/living/proc/winding_hit(timer_key, base_amount)
	if(HAS_TRAIT(src, TRAIT_NOPAINSTUN))
		return
	if(world.time < mob_timers[timer_key])
		return
	var/con = max(STACON, 1)
	var/amount = round(base_amount * 10 / con)
	if(amount <= 0)
		return
	battered_add(amount)
	mob_timers[timer_key] = world.time + (5 + con / 2) SECONDS

/obj/item/organ/heart/on_life()
	. = ..()
	if(!istype(owner))
		return
	owner.set_battered_floor("heart", (damage > 0 && damage < maxHealth && !HAS_TRAIT(owner, TRAIT_DEADITE)) ? (damage / maxHealth) * BATTERED_HEART_MAX : 0)

/obj/item/organ/heart/Remove(mob/living/carbon/M, special = 0)
	M?.set_battered_floor("heart", 0)
	return ..()
