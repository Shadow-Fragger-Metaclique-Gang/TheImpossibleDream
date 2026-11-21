/datum/wound/lethal
	name = "lethal wound"
	severity = WOUND_SEVERITY_FATAL
	sound_effect = 'sound/combat/crit.ogg'
	whp = 250
	woundpain = 100
	critical = TRUE
	sleep_healing = 0
	sewn_whp = 75
	bleed_rate = 25
	can_sew = TRUE
	sewn_bleed_rate = 0
	var/organ_damage = 0
	var/attack_damage = 0
	var/total_hits = 1
	var/organ_slot
	var/from_fracture = FALSE
	var/organ_damage_dealt = FALSE

/datum/wound/lethal/New(damage = 0)
	. = ..()
	if(damage > 0)
		attack_damage = damage
		organ_damage = clamp(damage * (rand(10, 20) / 10), 40, 100)

/datum/wound/lethal/on_mob_gain(mob/living/affected, damage)
	. = ..()
	if(iscarbon(affected) && affected.mind)
		affected.apply_status_effect(/datum/status_effect/debuff/critwounded)

/datum/wound/lethal/proc/get_target_organ()
	if(!organ_slot || !iscarbon(owner))
		return null
	var/mob/living/carbon/carbon_owner = owner
	return carbon_owner.getorganslot(organ_slot)

/datum/wound/lethal/is_hidden_bleed()
	return from_fracture

/datum/wound/lethal/can_stack_with(datum/wound/other)
	return type != other.type

/datum/wound/lethal/can_apply_to_bodypart(obj/item/bodypart/affected)
	// Merges repeat hits into the existing wound.
	var/datum/wound/lethal/existing = (!bodypart_owner && !QDELETED(affected)) ? affected.has_wound(type, specific = TRUE) : null
	if(existing)
		existing.merge_damage(attack_damage, organ_damage)
		return FALSE
	return ..()

/datum/wound/lethal/proc/merge_damage(new_attack_damage, new_organ_damage)
	if(!bodypart_owner || !owner)
		return
	total_hits++
	var/damage_multiplier = 1 / sqrt(total_hits)
	attack_damage += new_attack_damage * damage_multiplier
	if(new_organ_damage <= 0)
		return
	organ_damage = min(100, organ_damage + (new_organ_damage * damage_multiplier * 0.5))
	var/obj/item/organ/target_organ = get_target_organ()
	if(target_organ?.damage > 0)
		target_organ.applyOrganDamage(new_organ_damage * damage_multiplier * 0.3)

/datum/wound/lethal/heal_wound(heal_amount)
	if(!bodypart_owner || !owner)
		return
	var/obj/item/organ/target_organ = get_target_organ()
	if(target_organ?.damage > 0 && whp > 0 && heal_amount > 0)
		// Heals the organ in proportion to the wound.
		target_organ.applyOrganDamage(-target_organ.damage * min(heal_amount / whp, 1))
	. = ..()

/datum/wound/lethal/proc/damage_target_organ()
	var/obj/item/organ/target_organ = get_target_organ()
	if(organ_damage_dealt)
		return target_organ
	// Damages the organ only once.
	organ_damage_dealt = TRUE
	target_organ?.applyOrganDamage(organ_damage)
	return target_organ

/datum/wound/lethal/brain_penetration
	name = "brain penetration"
	check_name = span_userdanger("<B>BRAIN PIERCED</B>")
	crit_message = list(
		"The brain is pierced!",
		"The blade penetrates the skull into the brain!",
		"The brain is skewered!",
		"The edge pierces through the cranium into the brain!"
	)
	mortal = TRUE
	organ_slot = ORGAN_SLOT_BRAIN

/datum/wound/lethal/brain_penetration/get_crit_message(mob/living/affected, obj/item/bodypart/affected_bodypart)
	var/static/list/fracture_messages = list(
		"Bone fragments pierce the brain!",
		"The skull caves in, driving shards into the brain!",
		"Bone splinters penetrate deep into the brain!",
		"The fractured skull crushes inward into the brain!"
	)
	if(from_fracture)
		crit_message = fracture_messages
	return ..()

/datum/wound/lethal/brain_penetration/on_mob_gain(mob/living/affected, damage)
	. = ..()
	var/static/list/penetration_messages = list(
		"MY HEAD!",
		"I CAN'T THINK!",
		"EVERYTHING IS GOING DARK!")
	if(organ_damage_dealt)
		return
	damage_target_organ()
	if(get_stat_roll(affected.STACON) < 12)
		affected.Unconscious((rand(20, 30) - affected.STACON) SECONDS)
	to_chat(affected, span_userdanger("[pick(penetration_messages)]"))

/datum/wound/lethal/heart_penetration
	name = "heart penetration"
	check_name = span_userdanger("<B>HEART PIERCED</B>")
	crit_message = list(
		"The heart is pierced!",
		"The blade penetrates straight through the heart!",
		"The heart is skewered!",
		"The blade runs through %VICTIM's heart!"
	)
	woundpain = 250
	mortal = TRUE
	bleed_rate = 45
	organ_slot = ORGAN_SLOT_HEART

/datum/wound/lethal/heart_penetration/get_crit_message(mob/living/affected, obj/item/bodypart/affected_bodypart)
	var/static/list/construct_fracture_messages = list(
		"The golem core is punctured!",
		"Fragments pierce the lux core!",
		"The core cracks and splinters!",
		"The shattered shell crushes into the core!"
	)
	var/static/list/fracture_messages = list(
		"A rib pierces the heart!",
		"Broken ribs puncture straight through the heart!",
		"Bone fragments skewer the heart!",
		"The shattered ribcage crushes into the heart!"
	)
	if(from_fracture)
		crit_message = isconstruct(affected) ? construct_fracture_messages : fracture_messages
	return ..()

/datum/wound/lethal/heart_penetration/on_mob_gain(mob/living/affected, damage)
	. = ..()
	if(HAS_TRAIT(affected, TRAIT_DEADITE))
		return
	var/is_construct = isconstruct(affected)
	if(is_construct)
		set_bleed_rate(0)
		woundpain = 0
	var/static/list/penetration_messages = list(
		"MY HEART!",
		"MY CHEST!",
		"I'M DYING!",
		"OH GODS, THE PAIN!")
	var/static/list/construct_penetration_messages = list(
		"MY LUX CORE IS DAMAGED!",
		"I'M LOSING POWER!",
		"THE LIGHT DIMS!")
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		if(!is_construct)
			carbon_affected.vomit(blood = TRUE)
		damage_target_organ()
		if(!is_construct && !(NOBLOOD in carbon_affected.dna?.species?.species_traits))
			addtimer(CALLBACK(src, PROC_REF(crash_blood_pressure)), HEART_BP_CRASH_DELAY * get_severity_divisor())
	shake_camera(affected, 4, 4)
	if(!is_construct)
		affected.emote("painscream")
	to_chat(affected, span_userdanger("[pick(is_construct ? construct_penetration_messages : penetration_messages)]"))

/// Returns 1 for a nick and smaller values for worse heart damage.
/datum/wound/lethal/heart_penetration/proc/get_severity_divisor()
	return clamp(HEART_PENETRATION_NICK_DAMAGE / max(organ_damage, 1), 0.3, 1)

/// Crashes the owner's blood pressure.
/datum/wound/lethal/heart_penetration/proc/crash_blood_pressure()
	if(QDELETED(src) || !owner || !bodypart_owner)
		return
	ADD_TRAIT(owner, TRAIT_BP_CRASH, REF(src))
	owner.update_stat()

/datum/wound/lethal/heart_penetration/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_BP_CRASH, REF(src))
	affected.update_stat()

/datum/wound/lethal/heart_penetration/on_life()
	. = ..()
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon_owner = owner
	var/obj/item/organ/target_organ = get_target_organ()
	if(isconstruct(owner))
		carbon_owner.energy_add(-floor(organ_damage / 10))
		if(target_organ)
			if(target_organ.damage < target_organ.maxHealth)
				target_organ.applyOrganDamage(0.5)
			if(prob(3))
				to_chat(carbon_owner, span_warning("My lux core flickers and dims..."))
		return
	if(!carbon_owner.stat && prob(15))
		carbon_owner.vomit(1, blood = TRUE, stun = FALSE)
	if(!HAS_TRAIT(owner, TRAIT_NOBREATH))
		carbon_owner.adjustOxyLoss(HEART_PENETRATION_OXYLOSS / (get_severity_divisor() ** HEART_PENETRATION_OXYLOSS_EXPONENT))
	if(target_organ && target_organ.damage > round(target_organ.maxHealth / 2))
		target_organ.applyOrganDamage(1)
		if(prob(5))
			to_chat(carbon_owner, span_warning("MY HEART HURTS!"))

/datum/wound/lethal/lung_penetration
	name = "lung penetration"
	check_name = span_userdanger("<B>LUNG PIERCED</B>")
	crit_message = list(
		"The lung is pierced!",
		"Air escapes from the punctured lung!",
		"The lung collapses!",
		"The blade runs through %VICTIM's lung!"
	)
	bleed_rate = 4
	woundpain = 60
	mortal = TRUE
	organ_slot = ORGAN_SLOT_LUNGS
	/// Bleed rate the untreated wound ramps up to.
	var/max_bleed_rate = 15
	/// Bleed added each life tick while unbandaged; ~60s from start to max.
	var/bleed_ramp_per_tick = 0.4

/datum/wound/lethal/lung_penetration/get_crit_message(mob/living/affected, obj/item/bodypart/affected_bodypart)
	var/static/list/fracture_messages = list(
		"A rib pierces the lung!",
		"Broken ribs puncture the lung!",
		"Bone fragments collapse the lung!",
		"The shattered ribcage crushes into the lung!"
	)
	if(from_fracture)
		crit_message = fracture_messages
	return ..()

/datum/wound/lethal/lung_penetration/on_mob_gain(mob/living/affected, damage)
	. = ..()
	if(HAS_TRAIT(affected, TRAIT_DEADITE) || HAS_TRAIT(affected, TRAIT_NOBREATH))
		return
	var/static/list/penetration_messages = list(
		"I CAN'T BREATHE!",
		"MY LUNGS!",
		"I'M CHOKING!")
	to_chat(affected, span_userdanger("[pick(penetration_messages)]"))
	damage_target_organ()

/datum/wound/lethal/lung_penetration/on_life()
	. = ..()
	if(owner && !is_sewn() && !bodypart_owner?.bandage && bleed_rate < max_bleed_rate)
		set_bleed_rate(min(bleed_rate + bleed_ramp_per_tick, max_bleed_rate))
	if(!iscarbon(owner) || HAS_TRAIT(owner, TRAIT_NOBREATH))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(!carbon_owner.stat && prob(15))
		carbon_owner.emote("cough")

/datum/wound/lethal/liver_penetration
	name = "liver penetration"
	check_name = span_userdanger("<B>LIVER PIERCED</B>")
	crit_message = list(
		"The liver is pierced!",
		"The blade punctures through the liver!",
		"The liver is punctured!",
		"The liver is torn open!"
	)
	bleed_rate = 15
	woundpain = 120
	mortal = TRUE
	organ_slot = ORGAN_SLOT_LIVER
	internal_bleeding = TRUE

/datum/wound/lethal/liver_penetration/on_mob_gain(mob/living/affected, damage)
	. = ..()
	if(HAS_TRAIT(affected, TRAIT_DEADITE))
		return
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.vomit(blood = TRUE)
		damage_target_organ()
	to_chat(affected, span_userdanger("MY GUTS!"))

/datum/wound/lethal/liver_penetration/on_life()
	. = ..()
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(!carbon_owner.stat && prob(8))
		carbon_owner.vomit(1, blood = TRUE, stun = FALSE)
	carbon_owner.adjustToxLoss(0.5)

/datum/wound/lethal/stomach_penetration
	name = "stomach penetration"
	check_name = span_userdanger("<B>STOMACH PIERCED</B>")
	crit_message = list(
		"The stomach is pierced!",
		"The blade punctures through the stomach!",
		"The stomach is torn open!",
		"Stomach contents spill from the wound!"
	)
	bleed_rate = 20
	woundpain = 110
	mortal = TRUE
	organ_slot = ORGAN_SLOT_STOMACH
	internal_bleeding = TRUE

/datum/wound/lethal/stomach_penetration/on_mob_gain(mob/living/affected, damage)
	. = ..()
	if(HAS_TRAIT(affected, TRAIT_DEADITE))
		return
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.vomit(blood = TRUE)
		damage_target_organ()
	to_chat(affected, span_userdanger("MY GUTS!"))

/datum/wound/lethal/stomach_penetration/on_life()
	. = ..()
	if(!iscarbon(owner) || HAS_TRAIT(owner, TRAIT_NOHUNGER))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(!carbon_owner.stat && prob(12))
		carbon_owner.vomit(1, blood = TRUE, stun = FALSE)
		to_chat(carbon_owner, span_warning("I taste blood!"))
/obj/item/bodypart/proc/get_internal_bleed_rate()
	if(bandage && !HAS_BLOOD_DNA(bandage))
		return 0
	. = 0
	for(var/datum/wound/wound as anything in wounds)
		if(wound.internal_bleeding && wound.bleed_rate > 0)
			. += wound.bleed_rate

/mob/living/carbon/human/proc/get_rot_examine(observer_privilege, possessive)
	var/corpse_rot = 0
	for(var/obj/item/bodypart/part as anything in bodyparts)
		if(!observer_privilege && !get_location_accessible(src, part.body_zone))
			continue
		var/datum/wound/infection/infection = part.has_wound(/datum/wound/infection)
		if(infection?.noticed && infection.infection_stage < INFECTION_STAGE_SKELETAL)
			if(stat == DEAD)
				corpse_rot = max(corpse_rot, infection.infection_stage)
			else
				LAZYADD(., span_danger("<B>[possessive] [part.name] is festering!</B>"))
		var/datum/wound/burn/frostbite/frostbite = part.has_wound(/datum/wound/burn/frostbite)
		if(frostbite?.numb_stage >= 2)
			LAZYADD(., span_danger("[possessive] [part.name] is blackened and decaying."))
	if(corpse_rot >= INFECTION_STAGE_NECROTIC)
		LAZYADD(., span_danger("<B>[possessive] body is rotting away!</B>"))
	else if(corpse_rot)
		LAZYADD(., span_danger("<B>[possessive] body is festering!</B>"))
