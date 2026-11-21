/datum/component/rot/corpse
	var/flesh_rotting = FALSE
	var/necrotic = FALSE
	var/all_bone = FALSE
	var/bone_since = 0
	var/infect_after = 0

/// Runs every flesh limb's infection clock while dead, infecting clean limbs first. Returns TRUE if any limb changed.
/datum/component/rot/corpse/proc/rot_flesh(mob/living/carbon/corpse, advance = TRUE)
	. = FALSE
	flesh_rotting = FALSE
	necrotic = FALSE
	var/any_flesh = FALSE
	var/any_bone = FALSE
	var/ticking = advance && !has_world_trait(/datum/world_trait/pestra_mercy)
	if(!infect_after)
		infect_after = rand(INFECTION_FESTER_MIN_TIME, INFECTION_FESTER_MAX_TIME) * corpse.infection_con_modifier()
	for(var/obj/item/bodypart/part as anything in corpse.bodyparts)
		var/datum/wound/infection/infection = part.has_wound(/datum/wound/infection)
		if(ticking && !infection && !part.skeletonized && amount * corpse.zombie_rot_speed(0) > infect_after)
			infection = part.add_wound(/datum/wound/infection, silent = TRUE)
			if(infection)
				. = TRUE
		if(ticking && corpse.stat == DEAD && infection?.tick_clock(CORPSE_ROT_CLOCK_GAP))
			. = TRUE
		if(part.skeletonized)
			any_bone = TRUE
			continue
		if(!part.is_organic_limb())
			continue
		any_flesh = TRUE
		if(infection?.infection_stage >= INFECTION_STAGE_FESTERING)
			flesh_rotting = TRUE
		if(infection?.infection_stage >= INFECTION_STAGE_NECROTIC)
			necrotic = TRUE
	all_bone = any_bone && !any_flesh
	if(!all_bone)
		bone_since = 0
	else if(!bone_since)
		bone_since = world.time

/mob/living/proc/zombie_rot_speed(stage)
	if(HAS_TRAIT(src, TRAIT_DNR) || !mind?.has_antag_datum(/datum/antagonist/zombie))
		return 1
	switch(stage)
		if(INFECTION_STAGE_FESTERING)
			return ZOMBIE_FESTERING_ROT_SPEED
		if(INFECTION_STAGE_NECROTIC, INFECTION_STAGE_SKELETAL)
			return 1
	return ZOMBIE_EARLY_ROT_SPEED

/// Whether the corpse has been bare bone long enough to crumble.
/datum/component/rot/corpse/proc/ready_to_dust()
	return all_bone && bone_since && world.time - bone_since >= CORPSE_DUST_DELAY

/// Rots the body to at least the given infection stage, as when a corpse rises already decayed.
/mob/living/carbon/proc/rot_flesh_to(stage)
	for(var/obj/item/bodypart/part as anything in bodyparts)
		var/datum/wound/infection/infection = part.has_wound(/datum/wound/infection)
		if(!infection && !part.skeletonized)
			infection = part.add_wound(/datum/wound/infection, silent = TRUE)
		infection?.advance_to(stage)

/// Clears rot from the limb: its infection, and the rotted and skeletal flags.
/obj/item/bodypart/proc/cure_rot()
	var/datum/wound/infection/infection = has_wound(/datum/wound/infection)
	if(infection)
		qdel(infection)
	rotted = FALSE
	skeletonized = FALSE

/datum/antagonist/zombie
	var/keep_flesh_rot = FALSE

/mob/living/proc/unzombify_keeping_rot()
	var/datum/antagonist/zombie/zombie_antag = mind?.has_antag_datum(/datum/antagonist/zombie)
	if(!zombie_antag)
		return
	zombie_antag.keep_flesh_rot = TRUE
	mind.remove_antag_datum(/datum/antagonist/zombie)

/proc/warn_untreated_flesh(mob/user, mob/living/target)
	if(!iscarbon(target))
		return
	var/mob/living/carbon/carbon_target = target
	var/state
	for(var/obj/item/bodypart/part as anything in carbon_target.bodyparts)
		var/datum/wound/infection/infection = part.has_wound(/datum/wound/infection)
		if(!infection)
			continue
		if(part.skeletonized)
			state = "Their flesh is gone."
			break
		if(infection.infection_stage >= INFECTION_STAGE_FESTERING)
			state = "Their flesh is rotten."
	if(state)
		to_chat(user, span_warning("[state] They may suffer and die when they awaken.") + " " + span_boldwarning("I should treat the flesh first."))

/obj/item/bodypart/proc/needs_flesh_graft()
	if(!skeletonized || has_wound(/datum/wound/flesh_graft))
		return FALSE
	var/datum/wound/infection/infection = has_wound(/datum/wound/infection)
	return infection?.infection_stage >= INFECTION_STAGE_SKELETAL

GLOBAL_LIST_INIT(flesh_graft_meats, typecacheof(list(
	/obj/item/reagent_containers/food/snacks/rogue/meat/steak,
	/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll,
	/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll,
	/obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn,
	/obj/item/reagent_containers/food/snacks/rogue/meat/fatty,
	/obj/item/reagent_containers/food/snacks/rogue/meat/pork_belly,
	/obj/item/reagent_containers/food/snacks/rogue/meat/spider,
	/obj/item/reagent_containers/food/snacks/rogue/meat/poultry,
	/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet,
	/obj/item/reagent_containers/food/snacks/rogue/meat/wolf,
	/obj/item/reagent_containers/food/snacks/rogue/meat/rat,
	/obj/item/reagent_containers/food/snacks/rogue/meat/bear,
	/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit,
	/obj/item/reagent_containers/food/snacks/rogue/meat/ham,
	/obj/item/reagent_containers/food/snacks/rogue/meat/ham/boar,
	/obj/item/reagent_containers/food/snacks/rogue/meat/humanoid,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_w,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_w,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_z,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_w,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_z,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_w,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_z,
), only_root_path = TRUE))

/datum/surgery_step/graft_flesh
	name = "graft flesh"
	implements = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat = 80,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	time = 8 SECONDS
	surgery_flags = NONE
	surgery_flags_blocked = SURGERY_CONSTRUCT
	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_MASTER
	self_operable = FALSE
	preop_sound = 'sound/foley/sewflesh.ogg'
	success_sound = 'sound/foley/sewflesh.ogg'

/datum/surgery_step/graft_flesh/tool_check(mob/user, obj/item/tool)
	if(!(tool?.type in GLOB.flesh_graft_meats))
		return FALSE
	return ..()

/datum/surgery_step/graft_flesh/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/carbon_target = target
	var/obj/item/bodypart/part = carbon_target.get_bodypart(check_zone(target_zone))
	if(!part?.needs_flesh_graft())
		return FALSE
	if(user.get_skill_level(/datum/skill/misc/medicine) < SKILL_LEVEL_MASTER)
		to_chat(user, span_warning("I lack the skill to build flesh back onto bare bone."))
		return FALSE
	return TRUE

/datum/surgery_step/graft_flesh/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I begin to lay [tool] over the bare bone of [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to lay [tool] over the bare bone of [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to work on [target]'s [parse_zone(target_zone)]."))
	return TRUE

/datum/surgery_step/graft_flesh/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/mob/living/carbon/carbon_target = target
	var/obj/item/bodypart/part = carbon_target.get_bodypart(check_zone(target_zone))
	if(!part?.needs_flesh_graft())
		return FALSE
	if(!part.add_wound(/datum/wound/flesh_graft, silent = TRUE))
		return FALSE
	qdel(tool)
	display_results(user, target, span_notice("I graft fresh flesh onto [target]'s [part.name]. It must be sewn in place."),
		span_notice("[user] grafts flesh onto [target]'s [part.name]."),
		span_notice("[user] grafts flesh onto [target]'s [part.name]."))
	return TRUE

/datum/wound/flesh_graft
	name = "unsewn flesh graft"
	check_name = span_warning("<B>GRAFT</B>")
	severity = WOUND_SEVERITY_SEVERE
	crit_message = ""
	sound_effect = null
	whp = 100
	woundpain = 0
	bleed_rate = null
	can_sew = TRUE
	can_cauterize = FALSE
	disabling = TRUE
	sleep_healing = 0
	passive_healing = 0
	healable_by_miracles = FALSE
	bypass_bloody_wound_check = TRUE

/datum/wound/flesh_graft/can_stack_with(datum/wound/other)
	return !istype(other, /datum/wound/flesh_graft)

/datum/wound/flesh_graft/heal_wound(heal_amount, special_treatment = FALSE)
	return 0

/datum/wound/flesh_graft/sew_wound()
	if(!can_sew)
		return FALSE
	can_sew = FALSE
	var/obj/item/bodypart/part = bodypart_owner
	var/mob/living/carbon/patient = owner
	if(part)
		part.cure_rot()
		part.update_limb()
		part.update_disabled()
	qdel(src)
	patient?.update_body()
	return TRUE
