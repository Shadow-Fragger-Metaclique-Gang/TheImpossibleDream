/datum/wound/infection
	name = "infected wound"
	check_name = span_infection("<B>INFECTED</B>")
	severity = WOUND_SEVERITY_CRITICAL
	crit_message = ""
	sound_effect = null
	whp = 200
	woundpain = 0
	bleed_rate = null
	can_sew = FALSE
	can_cauterize = TRUE
	disabling = FALSE
	critical = TRUE
	sleep_healing = 0
	passive_healing = 0
	healable_by_miracles = FALSE
	bypass_bloody_wound_check = TRUE
	var/infection_stage = 1
	var/time_to_next_stage = 0
	var/progression_multiplier = 1
	var/next_spread_attempt = 0
	var/last_stage_duration = 0
	var/stage_4_time = 60 MINUTES
	var/necrotic_overlay_applied = FALSE
	var/notice_time = 0
	var/noticed = FALSE
	var/last_alive_tick = 0

/datum/wound/infection/can_stack_with(datum/wound/other)
	return !istype(other, /datum/wound/infection)

/datum/wound/infection/can_apply_to_bodypart(obj/item/bodypart/affected)
	if(affected.skeletonized || !affected.is_organic_limb())
		return FALSE
	if(affected.owner && HAS_TRAIT(affected.owner, TRAIT_IRONMAN))
		return FALSE
	return ..()

/datum/wound/infection/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	bleed_rate = null
	time_to_next_stage = world.time + (rand(INFECTION_FESTER_MIN_TIME, INFECTION_FESTER_MAX_TIME) * get_con_modifier()) / progression_multiplier
	notice_time = world.time + (time_to_next_stage - world.time) / 2
	last_alive_tick = world.time

/datum/wound/infection/on_bodypart_loss(obj/item/bodypart/affected)
	. = ..()
	if(!necrotic_overlay_applied || affected.skeletonized)
		return
	affected.rotted = FALSE
	affected.owner?.update_body_parts()

/datum/wound/infection/proc/get_con_modifier()
	return owner ? owner.infection_con_modifier() : 1

/// How much slower infection and rot run on this body; hardier bodies resist longer.
/mob/living/proc/infection_con_modifier()
	if(!ishuman(src))
		return 1
	return clamp(1 + ((STACON - 10) * 0.05), 0.5, 2)

/// Rot that harms nothing: on corpses, and on the walking dead.
/datum/wound/infection/proc/is_harmless()
	return owner && (owner.stat == DEAD || HAS_TRAIT(owner, TRAIT_DEADITE) || HAS_TRAIT(owner, TRAIT_ROTMAN))

/datum/wound/infection/proc/stage_pain()
	switch(infection_stage)
		if(2)
			return 80
		if(3)
			return 150
	return 0

/datum/wound/infection/proc/refresh_harm()
	var/harmless = is_harmless()
	woundpain = harmless ? 0 : stage_pain()
	disabling = !harmless && infection_stage >= INFECTION_STAGE_SKELETAL

/datum/wound/infection/on_life()
	. = ..()
	if(!owner || !bodypart_owner)
		return
	refresh_harm()
	if(owner.stat == DEAD)
		return
	var/mob/living/carbon/carbon_owner = owner
	if(infection_stage >= INFECTION_STAGE_SKELETAL && !is_harmless() && (bodypart_owner.body_zone in GLOB.vital_body_zones) && !(istype(carbon_owner) && (NOBLOOD in carbon_owner.dna?.species?.species_traits)))
		to_chat(owner, span_userdanger("There is nothing left of my [bodypart_owner.name] but bone!"))
		owner.death()
		return
	tick_clock(INFECTION_CLOCK_PAUSE_GAP)
	apply_stage_effects()

/// Advances the infection on its own timer; a tick gap longer than pause_gap stops the clock for that gap. Returns TRUE on a stage change.
/datum/wound/infection/proc/tick_clock(pause_gap)
	var/paused_for = world.time - last_alive_tick
	last_alive_tick = world.time
	if(infection_stage >= INFECTION_STAGE_SKELETAL)
		return FALSE
	if(paused_for > pause_gap)
		time_to_next_stage += paused_for
		notice_time += paused_for
	else
		var/hurry = paused_for * (owner.zombie_rot_speed(infection_stage) - 1)
		time_to_next_stage -= hurry
		notice_time -= hurry
	if(world.time >= time_to_next_stage)
		advance_stage(owner.stat == DEAD)
		return TRUE
	if(!noticed && world.time >= notice_time)
		if(owner.stat == DEAD)
			noticed = TRUE
		else
			notice_rot()
	return FALSE

/// Advances to at least target_stage without messages.
/datum/wound/infection/proc/advance_to(target_stage)
	noticed = TRUE
	while(infection_stage < target_stage && bodypart_owner && !QDELETED(src))
		advance_stage(TRUE)

/datum/wound/infection/proc/notice_rot()
	noticed = TRUE
	to_chat(owner, span_warning("You smell something starting to rot..."))
	var/turf/owner_turf = get_turf(owner)
	owner_turf?.pollute_turf(/datum/pollutant/rot, 2)

/datum/wound/infection/proc/advance_stage(silent = FALSE)
	if(!owner || !bodypart_owner)
		return
	infection_stage++
	noticed = TRUE
	last_alive_tick = world.time
	switch(infection_stage)
		if(INFECTION_STAGE_FESTERING)
			name = "festering wound"
			check_name = span_infection_purple("<B>FESTERING</B>")
			if(!silent)
				to_chat(owner, span_userdanger("The wound on my [bodypart_owner.name] begins to fester!"))
			last_stage_duration = (rand(20 MINUTES, 40 MINUTES) * get_con_modifier()) / progression_multiplier
			time_to_next_stage = world.time + last_stage_duration
		if(INFECTION_STAGE_NECROTIC)
			name = "necrotic wound"
			check_name = span_infection_purple("<B>ROTTEN</B>")
			if(!silent)
				to_chat(owner, span_userdanger("The wound on my [bodypart_owner.name] turns necrotic!"))
				owner.visible_message(span_danger("[owner]'s [bodypart_owner.name] begins to rot!"))
			var/time_since_infection = world.time - (time_to_next_stage - last_stage_duration)
			time_to_next_stage = world.time + max(stage_4_time - time_since_infection, 5 MINUTES)
			next_spread_attempt = world.time + 1 MINUTES
			apply_necrotic_overlay()
		if(INFECTION_STAGE_SKELETAL)
			name = "skeletal limb"
			check_name = span_bone_grey("<B>BONE</B>")
			if(!silent)
				to_chat(owner, span_userdanger("The flesh on my [bodypart_owner.name] has completely rotted away!"))
				owner.visible_message(span_danger("[owner]'s [bodypart_owner.name] turns to bare bone!"))
			bodypart_owner.skeletonize(!is_harmless() && (bodypart_owner.body_zone in GLOB.vital_body_zones))
	refresh_harm()

/datum/wound/infection/proc/apply_stage_effects()
	if(!owner || !bodypart_owner)
		return
	switch(infection_stage)
		if(2)
			var/turf/owner_turf = get_turf(owner)
			if(owner_turf && prob(10))
				owner_turf.pollute_turf(/datum/pollutant/rot, 2)
		if(3)
			apply_necrotic_effects()

/datum/wound/infection/proc/apply_necrotic_effects()
	if(!necrotic_overlay_applied)
		apply_necrotic_overlay()
	if(is_harmless())
		return
	if(prob(3))
		bodypart_owner.set_disabled(BODYPART_DISABLED_ROT)
		owner.visible_message(span_warning("[owner]'s [bodypart_owner.name] seizes up from the rot!"))
		addtimer(CALLBACK(src, PROC_REF(reenable_bodypart)), rand(5 SECONDS, 15 SECONDS))
	if(world.time >= next_spread_attempt)
		attempt_spread()
		next_spread_attempt = world.time + rand(1, 3) MINUTES
	if((bodypart_owner.body_zone in GLOB.vital_body_zones) && !HAS_TRAIT(owner, TRAIT_TOXIMMUNE))
		owner.adjustToxLoss(2)

/datum/wound/infection/proc/reenable_bodypart()
	if(!bodypart_owner)
		return
	bodypart_owner.set_disabled(BODYPART_NOT_DISABLED)
	owner?.visible_message(span_notice("[owner]'s [bodypart_owner.name] relaxes slightly."))

/datum/wound/infection/proc/apply_necrotic_overlay()
	if(!bodypart_owner || necrotic_overlay_applied)
		return
	bodypart_owner.rotted = TRUE
	if(iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		carbon_owner.update_body_parts()
	necrotic_overlay_applied = TRUE

/datum/wound/infection/proc/attempt_spread()
	if(!bodypart_owner || !owner)
		return
	for(var/obj/item/bodypart/adjacent_part as anything in get_adjacent_bodyparts())
		if(adjacent_part.has_wound(/datum/wound/infection))
			continue
		if(!prob(30))
			continue
		var/datum/wound/infection/spread_infection = new /datum/wound/infection()
		spread_infection.progression_multiplier = 2
		if(adjacent_part.add_wound(spread_infection))
			owner.visible_message(span_danger("The infection spreads from [owner]'s [bodypart_owner.name] to [owner.p_their()] [adjacent_part.name]!"))

/datum/wound/infection/proc/get_adjacent_bodyparts()
	. = list()
	if(!bodypart_owner || !owner)
		return
	var/static/list/chest_only = list(BODY_ZONE_CHEST)
	var/static/list/from_chest = list(BODY_ZONE_HEAD, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
	var/list/adjacent_zones
	switch(bodypart_owner.body_zone)
		if(BODY_ZONE_HEAD, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
			adjacent_zones = chest_only
		if(BODY_ZONE_CHEST)
			adjacent_zones = from_chest
	for(var/zone in adjacent_zones)
		var/obj/item/bodypart/adjacent_part = owner.get_bodypart(zone)
		if(adjacent_part)
			. += adjacent_part

/datum/wound/infection/heal_wound(heal_amount, special_treatment = FALSE)
	if(!special_treatment)
		return 0
	return ..()

/datum/wound/infection/cauterize_wound(surgical = FALSE, mob/user)
	return try_cauterize_treatment(surgical, user)

/datum/wound/infection/proc/try_alcohol_treatment()
	if(infection_stage > 1)
		return FALSE
	if(!prob(70))
		to_chat(owner, span_warning("The alcohol stings, but the infection persists..."))
		return FALSE
	to_chat(owner, span_notice("The alcohol burns away the infection in my [bodypart_owner.name]!"))
	owner.visible_message(span_notice("[owner] treats the infection on [owner.p_their()] [bodypart_owner.name] with alcohol."))
	qdel(src)
	return TRUE

/datum/wound/infection/proc/try_cauterize_treatment(surgical = FALSE, mob/user)
	if(bodypart_owner?.skeletonized)
		return FALSE
	if(!user)
		user = owner
	if(surgical)
		to_chat(owner, span_notice("The surgical cautery burns away the infected tissue!"))
		user.visible_message(span_danger("[user] cauterizes the infected tissue on [user == owner ? owner.p_their() : "[owner]'s"] [bodypart_owner.name]!"))
		owner.emote("painscream", TRUE)
		qdel(src)
		return TRUE
	to_chat(owner, span_notice("The flame sears away the infected tissue!"))
	user.visible_message(span_danger("[user] cauterizes the infection on [user == owner ? owner.p_their() : "[owner]'s"] [bodypart_owner.name]!"))
	owner.emote("paincrit", TRUE)
	qdel(src)
	return TRUE

/datum/reagent/consumable/ethanol/reaction_mob(mob/living/M, method = TOUCH, reac_volume)
	var/static/list/external_methods = list(TOUCH, VAPOR, PATCH)
	if(iscarbon(M) && (method in external_methods))
		var/mob/living/carbon/carbon_target = M
		for(var/obj/item/bodypart/bodypart as anything in carbon_target.bodyparts)
			var/datum/wound/infection/infection = bodypart.has_wound(/datum/wound/infection)
			infection?.try_alcohol_treatment()
	return ..()

GLOBAL_LIST_INIT(filthy_weapon_types, typecacheof(list(
	/obj/item/rogueweapon/contraption/linker/mace/decrepit,
	/obj/item/rogueweapon/contraption/linker/mace/big/decrepit,
	/obj/item/rogueweapon/flail/aflail,
	/obj/item/rogueweapon/greatsword/aalloy,
	/obj/item/rogueweapon/halberd/bardiche/aalloy,
	/obj/item/rogueweapon/huntingknife/idagger/adagger,
	/obj/item/rogueweapon/huntingknife/throwingknife/aalloy,
	/obj/item/rogueweapon/mace/alloy,
	/obj/item/rogueweapon/mace/goden/aalloy,
	/obj/item/rogueweapon/mace/warhammer/alloy,
	/obj/item/rogueweapon/spear/aalloy,
	/obj/item/rogueweapon/stoneaxe/woodcut/aaxe,
	/obj/item/rogueweapon/sword/sabre/alloy,
	/obj/item/rogueweapon/sword/short/ashort,
	/obj/item/rogueweapon/sword/short/gladius/agladius,
)))

/obj/item/rogueweapon/Initialize(mapload)
	. = ..()
	if(is_type_in_typecache(src, GLOB.filthy_weapon_types))
		ADD_TRAIT(src, TRAIT_FILTHY_WEAPON, INNATE_TRAIT)

/obj/item/bodypart/var/cauterizing = FALSE

/obj/item/bodypart/proc/check_wound_infection(datum/wound/new_wound, mob/living/user, obj/item/weapon)
	if(!owner || cauterizing || !istype(new_wound, /datum/wound/dynamic))
		return
	if(HAS_TRAIT(owner, TRAIT_NOMETABOLISM) || HAS_TRAIT(owner, TRAIT_DEADITE) || HAS_TRAIT(owner, TRAIT_ROTMAN))
		return
	if(prob(calculate_infection_chance(user, weapon, new_wound)))
		add_wound(/datum/wound/infection, silent = TRUE)

/obj/item/bodypart/proc/calculate_infection_chance(mob/living/user, obj/item/weapon, datum/wound/new_wound)
	var/chance = 0
	if((weapon && HAS_TRAIT(weapon, TRAIT_FILTHY_WEAPON)) || isanimal(user) || istype(new_wound, /datum/wound/dynamic/bite))
		chance += INFECTION_FILTHY_BONUS
	var/filth_bonus = 0
	if(weapon && weapon.blood_DNA_length() > 0)
		filth_bonus = 3
	if(user)
		if(user.blood_DNA_length() > 0)
			filth_bonus = max(filth_bonus, 2)
		if(HAS_TRAIT(user, TRAIT_DEADITE))
			chance += INFECTION_DEADITE_BONUS
	var/turf/owner_turf = get_turf(owner)
	if(owner_turf)
		if(locate(/obj/effect/decal/cleanable) in owner_turf)
			filth_bonus = max(filth_bonus, 2)
		if(istype(owner_turf, /turf/open/water/sewer) || istype(owner_turf, /turf/open/water/swamp) || istype(owner_turf, /turf/open/water/bloody))
			chance += INFECTION_FOUL_WATER_BONUS
	chance += filth_bonus
	if(ishuman(owner))
		chance -= (owner.STACON - 10) * INFECTION_CON_PER_POINT
	for(var/datum/wound/dynamic/burn/burn in wounds)
		if(burn.whp >= 70 && burn.bleed_rate > 0)
			chance += 95
			if(ishuman(owner) && owner.STACON >= 15)
				chance -= min((owner.STACON - 15) * 5, 25)
			break
	return clamp(chance, 0, 100)
