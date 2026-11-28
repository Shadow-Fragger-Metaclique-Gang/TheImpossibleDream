#define DEADITE_UNDEATH_SOURCE "deadite_undeath"

GLOBAL_LIST_INIT(deadite_shrugged_traits, list(
	TRAIT_PARALYSIS,
	TRAIT_PARALYSIS_R_LEG,
	TRAIT_PARALYSIS_L_LEG,
	TRAIT_DEAF,
	TRAIT_BRITTLE,
	TRAIT_FINGERLESS,
))

GLOBAL_LIST_INIT(deadite_immune_effects, typecacheof(list(
	/datum/status_effect/debuff/critwounded,
	/datum/status_effect/debuff/dazed/skullshatter,
	/datum/status_effect/debuff/devitalised,
	/datum/status_effect/debuff/bleeding,
	/datum/status_effect/debuff/bleedingworse,
	/datum/status_effect/debuff/bleedingworst,
)))

/mob/living
	var/deadite_shrug_depth = 0
	var/shrug_confused = 0
	var/shrug_dizziness = 0
	var/shrug_stuttering = 0

/mob/living/proc/grant_undeath()
	ADD_TRAIT(src, TRAIT_NODEATH, DEADITE_UNDEATH_SOURCE)
	ADD_TRAIT(src, TRAIT_NOHARDCRIT, DEADITE_UNDEATH_SOURCE)

/mob/living/proc/revoke_undeath()
	REMOVE_TRAIT(src, TRAIT_NODEATH, DEADITE_UNDEATH_SOURCE)
	REMOVE_TRAIT(src, TRAIT_NOHARDCRIT, DEADITE_UNDEATH_SOURCE)

/datum/antagonist/zombie/transform_zombie()
	. = ..()
	var/mob/living/carbon/human/zombie = owner?.current
	if(zombie && has_turned)
		zombie.grant_undeath()

/datum/antagonist/zombie/on_removal()
	var/mob/living/carbon/human/zombie = owner?.current
	zombie?.revoke_undeath()
	return ..()

/mob/living/carbon/human/make_deadite()
	. = ..()
	grant_undeath()

/mob/living/proc/begin_deadite_shrug()
	if(!HAS_TRAIT(src, TRAIT_DEADITE))
		return FALSE
	if(!deadite_shrug_depth)
		shrug_confused = confused
		shrug_dizziness = dizziness
		shrug_stuttering = stuttering
	deadite_shrug_depth++
	return TRUE

/mob/living/proc/end_deadite_shrug()
	deadite_shrug_depth = max(deadite_shrug_depth - 1, 0)
	if(deadite_shrug_depth)
		return
	confused = min(confused, shrug_confused)
	dizziness = min(dizziness, shrug_dizziness)
	stuttering = min(stuttering, shrug_stuttering)
	var/stripped = strip_wound_traits(src)
	if(!iscarbon(src))
		return
	var/mob/living/carbon/carbon_self = src
	for(var/obj/item/bodypart/limb as anything in carbon_self.bodyparts)
		stripped += strip_wound_traits(limb)
	if(!stripped)
		return
	for(var/obj/item/bodypart/limb as anything in carbon_self.bodyparts)
		limb.update_disabled()

/mob/living/proc/strip_wound_traits(datum/target)
	. = 0
	for(var/trait in GLOB.deadite_shrugged_traits)
		var/list/sources = target.status_traits?[trait]
		if(!length(sources))
			continue
		for(var/source in sources.Copy())
			if(findtext("[source]", "/datum/wound") == 1)
				REMOVE_TRAIT(target, trait, source)
				.++

/mob/living/proc/deadite_shrugging()
	return deadite_shrug_depth && HAS_TRAIT(src, TRAIT_DEADITE)

/mob/living/carbon/proc/deadite_brain_destroyed()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	if(!head || head.grievously_wounded)
		return TRUE
	var/obj/item/organ/brain/brain = getorganslot(ORGAN_SLOT_BRAIN)
	return !brain || brain.brain_death || brain.damage >= BRAIN_DAMAGE_DEATH

/datum/wound/apply_to_bodypart(obj/item/bodypart/affected, silent = FALSE, crit_message = FALSE, damage)
	var/mob/living/target = affected?.owner
	var/shrugging = !istype(src, /datum/wound/sunder) && target?.begin_deadite_shrug()
	. = ..()
	if(shrugging)
		target.end_deadite_shrug()

/mob/living/handle_wounds()
	var/shrugging = begin_deadite_shrug()
	. = ..()
	if(shrugging)
		end_deadite_shrug()

/obj/item/bodypart/try_crit(bclass = BCLASS_BLUNT, dam, mob/living/user, zone_precise = src.body_zone, silent = FALSE, crit_message = FALSE, raw_damage = 0, armor_block = 0, armor_resistance = 0, was_blunted = FALSE, obj/item/weapon)
	var/mob/living/target = owner
	var/shrugging = target?.begin_deadite_shrug()
	. = ..()
	if(shrugging)
		target.end_deadite_shrug()

/obj/item/bodypart/chest/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE, raw_damage = 0, armor_block = 0, armor_resistance = 0, was_blunted = FALSE, obj/item/weapon)
	var/mob/living/target = owner
	var/shrugging = target?.begin_deadite_shrug()
	. = ..()
	if(shrugging)
		target.end_deadite_shrug()

/obj/item/bodypart/head/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE, raw_damage = 0, armor_block = 0, armor_resistance = 0, was_blunted = FALSE, obj/item/weapon)
	var/mob/living/target = owner
	var/shrugging = target?.begin_deadite_shrug()
	. = ..()
	if(shrugging)
		target.end_deadite_shrug()

/datum/reagents/metabolize(mob/living/carbon/C, can_overdose = FALSE, liverless = FALSE)
	var/shrugging = C?.begin_deadite_shrug()
	. = ..()
	if(shrugging)
		C.end_deadite_shrug()

/obj/item/bodypart/temporary_crit_paralysis(duration = 60 SECONDS, brittle = TRUE)
	if(owner && HAS_TRAIT(owner, TRAIT_DEADITE))
		return
	return ..()

/obj/item/bodypart/is_disabled()
	. = ..()
	if(. != BODYPART_DISABLED_WOUND || !HAS_TRAIT(owner, TRAIT_DEADITE))
		return
	if(HAS_TRAIT(owner, TRAIT_PARALYSIS) || HAS_TRAIT(src, TRAIT_PARALYSIS))
		return BODYPART_DISABLED_PARALYSIS
	if(get_surgery_flags() & SURGERY_CLAMPED)
		return BODYPART_DISABLED_CLAMPED
	var/total_dam = get_damage()
	if((total_dam >= max_damage) || (HAS_TRAIT(owner, TRAIT_EASYLIMBDISABLE) && (total_dam >= (max_damage * 0.6))))
		return BODYPART_DISABLED_DAMAGE
	return BODYPART_NOT_DISABLED

/mob/living/apply_status_effect(effect, ...)
	if(HAS_TRAIT(src, TRAIT_DEADITE) && is_type_in_typecache(effect, GLOB.deadite_immune_effects))
		return null
	return ..()

/mob/living/Unconscious(amount, updating = TRUE, ignore_canstun = FALSE)
	if(HAS_TRAIT(src, TRAIT_DEADITE) && amount > 0)
		return
	return ..()

/mob/living/Sleeping(amount, updating = TRUE, ignore_canstun = FALSE)
	if(HAS_TRAIT(src, TRAIT_DEADITE) && amount > 0)
		return
	return ..()

/mob/living/SetSleeping(amount, updating = TRUE, ignore_canstun = FALSE)
	if(HAS_TRAIT(src, TRAIT_DEADITE) && amount > 0)
		return
	return ..()

/mob/living/Stun(amount, updating = TRUE, ignore_canstun = FALSE)
	if(deadite_shrugging())
		return
	return ..()

/mob/living/Knockdown(amount, updating = TRUE, ignore_canstun = FALSE)
	if(deadite_shrugging())
		return
	return ..()

/mob/living/Immobilize(amount, updating = TRUE, ignore_canstun = FALSE)
	if(deadite_shrugging())
		return
	return ..()

/mob/living/Paralyze(amount, updating = TRUE, ignore_canstun = FALSE)
	if(deadite_shrugging())
		return
	return ..()

/mob/living/Slowdown(amount)
	if(deadite_shrugging())
		return
	return ..()

/mob/living/add_movespeed_modifier(id, update=TRUE, priority=0, flags=NONE, override=FALSE, multiplicative_slowdown=0, movetypes=ALL, blacklisted_movetypes=NONE, conflict=FALSE)
	if(multiplicative_slowdown > 0 && deadite_shrugging())
		return FALSE
	return ..()

/mob/living/carbon/vomit(lost_nutrition = 50, blood = FALSE, stun = TRUE, distance = 1, message = TRUE, toxic = FALSE, harm = FALSE, force = FALSE)
	if(HAS_TRAIT(src, TRAIT_DEADITE) && (blood || deadite_shrugging()))
		return FALSE
	return ..()

/mob/living/energy_add(added as num)
	if(added < 0 && deadite_shrugging())
		return
	return ..()

/mob/living/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	if(amount > 0 && HAS_TRAIT(src, TRAIT_DEADITE))
		return 0
	return ..()

/mob/living/setOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	if(amount > 0 && HAS_TRAIT(src, TRAIT_DEADITE))
		return 0
	return ..()

/mob/living/carbon/human/handle_heart()
	if(HAS_TRAIT(src, TRAIT_DEADITE))
		return
	return ..()

/mob/living/carbon/human/death(gibbed, nocutscene = FALSE)
	if(!gibbed && stat != DEAD && deadite_shrugging() && !deadite_brain_destroyed())
		return FALSE
	return ..()

#undef DEADITE_UNDEATH_SOURCE
