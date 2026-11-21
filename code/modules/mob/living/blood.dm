/****************************************************
				BLOOD SYSTEM
****************************************************/

/mob/living/proc/suppress_bloodloss(amount)
	if(bleedsuppress)
		return
	else
		bleedsuppress = TRUE
		addtimer(CALLBACK(src, PROC_REF(resume_bleeding)), amount)

/mob/living/proc/resume_bleeding()
	bleedsuppress = 0
	if(stat != DEAD && bleed_rate)
		to_chat(src, span_warning("The blood soaks through my bandage."))

/mob/living/carbon/proc/refresh_blood_debuffs()
	remove_status_effect(/datum/status_effect/debuff/bleeding)
	remove_status_effect(/datum/status_effect/debuff/bleedingworse)
	remove_status_effect(/datum/status_effect/debuff/bleedingworst)

	switch(blood_volume)
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			if(prob(3))
				to_chat(src, span_warning("I feel dizzy."))
			remove_status_effect(/datum/status_effect/debuff/bleedingworse)
			remove_status_effect(/datum/status_effect/debuff/bleedingworst)
			apply_status_effect(/datum/status_effect/debuff/bleeding)

		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			if(prob(3))
				blur_eyes(6)
				to_chat(src, span_warning("I feel faint."))
			remove_status_effect(/datum/status_effect/debuff/bleeding)
			remove_status_effect(/datum/status_effect/debuff/bleedingworst)
			apply_status_effect(/datum/status_effect/debuff/bleedingworse)

		if(0 to BLOOD_VOLUME_BAD)
			if(prob(3))
				blur_eyes(6)
				to_chat(src, span_warning("I feel faint."))
			if(prob(3))
				to_chat(src, span_warning("I feel drained."))
			remove_status_effect(/datum/status_effect/debuff/bleeding)
			remove_status_effect(/datum/status_effect/debuff/bleedingworse)
			apply_status_effect(/datum/status_effect/debuff/bleedingworst)

/mob/living/proc/handle_blood()
	if((bodytemperature <= TCRYO) || HAS_TRAIT(src, TRAIT_HUSK)) //cryosleep or husked people do not pump the blood.
		return

	blood_volume = min(blood_volume, BLOOD_VOLUME_MAXIMUM)
	//Effects of bloodloss - only run if we're not actually dead.
	if (stat != DEAD)
		if(!HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
			switch(blood_volume)
				if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
					if(prob(3))
						to_chat(src, span_warning("I feel dizzy."))
					remove_status_effect(/datum/status_effect/debuff/bleedingworse)
					remove_status_effect(/datum/status_effect/debuff/bleedingworst)
					apply_status_effect(/datum/status_effect/debuff/bleeding)
				if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
					if(prob(3))
						blur_eyes(6)
						to_chat(src, span_warning("I feel faint."))
					remove_status_effect(/datum/status_effect/debuff/bleeding)
					remove_status_effect(/datum/status_effect/debuff/bleedingworst)
					apply_status_effect(/datum/status_effect/debuff/bleedingworse)
				if(0 to BLOOD_VOLUME_BAD)
					if(prob(3))
						blur_eyes(6)
						to_chat(src, span_warning("I feel faint."))
					if(prob(3))
						to_chat(src, span_warning("I feel drained."))
					remove_status_effect(/datum/status_effect/debuff/bleedingworse)
					remove_status_effect(/datum/status_effect/debuff/bleeding)
					apply_status_effect(/datum/status_effect/debuff/bleedingworst)
			if(blood_volume <= BLOOD_VOLUME_BAD)
				adjustOxyLoss(1)
				if(blood_volume <= BLOOD_VOLUME_SURVIVE)
					adjustOxyLoss(2)
		else
			remove_status_effect(/datum/status_effect/debuff/bleeding)
			remove_status_effect(/datum/status_effect/debuff/bleedingworse)
			remove_status_effect(/datum/status_effect/debuff/bleedingworst)

	bleed_rate = get_bleed_rate()
	if(HAS_TRAIT(src, TRAIT_ADRENALINE_RUSH))
		bleed_rate = FALSE
	if(bleed_rate)
		bleed(bleed_rate)
	// [SURREALIS-EDIT] - VRCOMBAT
	// else if(blood_volume < BLOOD_VOLUME_NORMAL) // SURREALIS-EDIT - ORIGINAL
	else if(blood_volume < BLOOD_VOLUME_NORMAL && stat != DEAD)
	// [/SURREALIS-EDIT]
		blood_volume = min(blood_volume + 1, BLOOD_VOLUME_NORMAL)

	// Non-vampiric bloodpool regen.
	// We assume that in non-vampires bloodpool represents "usable" blood that is regenerated slower than blood_volume
	if(!clan && blood_volume > BLOOD_VOLUME_SAFE)
		adjust_bloodpool(BLOODPOL_REGEN, FALSE)

// Takes care blood loss and regeneration
/mob/living/carbon/handle_blood()
	if((bodytemperature <= TCRYO) || HAS_TRAIT(src, TRAIT_HUSK)) //cryosleep or husked people do not pump the blood.
		return

	blood_volume = min(blood_volume, BLOOD_VOLUME_MAXIMUM)
	if(dna?.species)
		if(NOBLOOD in dna.species.species_traits)
			blood_volume = BLOOD_VOLUME_NORMAL
			return

	// if we're dead and have no blood left, then there's nothing to do here: we can't regen it ourselves (in this proc), so...
	// we'll continue to bleed out for as long as we have blood, but that's it
	if (!blood_volume)
		if (stat == DEAD)
			bleed_rate = 0 // just to be sure for anything else that cares about it, since we're ostensibly out of blood now
			return
		else
			// handle just the oxyloss, and then abort. nothing else in here is relevant to us
			adjustOxyLoss(blood_volume <= BLOOD_VOLUME_SURVIVE ? 3 : 1)
			return

	//Blood regeneration if there is some space
	// [SURREALIS-EDIT] - VRCOMBAT
	// if(blood_volume < BLOOD_VOLUME_NORMAL && blood_volume) // SURREALIS-EDIT - ORIGINAL
	if(blood_volume < BLOOD_VOLUME_NORMAL && blood_volume && stat != DEAD)
	// [/SURREALIS-EDIT]
		var/nutrition_ratio = 1
//			switch(nutrition)
//				if(0 to NUTRITION_LEVEL_STARVING)
//					nutrition_ratio = 0.2
//				if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
//					nutrition_ratio = 0.4
//				if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
//					nutrition_ratio = 0.6
//				if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
//					nutrition_ratio = 0.8
//				else
//					nutrition_ratio = 1
//			if(satiety > 80)
//				nutrition_ratio *= 1.25
//			adjust_hydration(-nutrition_ratio * HUNGER_FACTOR) //get thirsty twice as fast when regenning blood
		blood_volume = min(BLOOD_VOLUME_NORMAL, blood_volume + 0.5 * nutrition_ratio)

	//Effects of bloodloss - only if we're actually alive, though
	if (stat != DEAD)
		if(!HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
			var/current_bleeding_tier
			switch(blood_volume)
				if(BLOOD_VOLUME_SAFE to INFINITY)
					current_bleeding_tier = 0
				if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
					current_bleeding_tier = 1
					if(prob(3))
						to_chat(src, span_warning("I feel dizzy."))
				if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
					current_bleeding_tier = 2
					if(prob(3))
						blur_eyes(6)
						to_chat(src, span_warning("I feel faint."))
				if(0 to BLOOD_VOLUME_BAD)
					current_bleeding_tier = 3
					if(prob(3))
						blur_eyes(6)
						to_chat(src, span_warning("I feel faint."))
					if(prob(3))
						to_chat(src, span_warning("I feel drained."))
				else
					current_bleeding_tier = bleeding_tier

			// only apply status effects if we've actually shifted a tier of bleeding instead of performing
			// 3+ STATUS EFFECT CHECKS ON EVERY SINGLE LIFE TICK. HOLY SMOKES!!!
			if (current_bleeding_tier != bleeding_tier)
				bleeding_tier = current_bleeding_tier
				switch (bleeding_tier)
					if (0)
						remove_status_effect(/datum/status_effect/debuff/bleeding)
						remove_status_effect(/datum/status_effect/debuff/bleedingworse)
						remove_status_effect(/datum/status_effect/debuff/bleedingworst)
					if (1)
						apply_status_effect(/datum/status_effect/debuff/bleeding)
						remove_status_effect(/datum/status_effect/debuff/bleedingworse)
						remove_status_effect(/datum/status_effect/debuff/bleedingworst)
					if (2)
						apply_status_effect(/datum/status_effect/debuff/bleedingworse)
						remove_status_effect(/datum/status_effect/debuff/bleeding)
						remove_status_effect(/datum/status_effect/debuff/bleedingworst)
					if (3)
						apply_status_effect(/datum/status_effect/debuff/bleedingworst)
						remove_status_effect(/datum/status_effect/debuff/bleeding)
						remove_status_effect(/datum/status_effect/debuff/bleedingworse)

			// [SURREALIS-ADD] - VRCOMBAT
			var/soft_crit_threshold = clamp(BLOOD_VOLUME_SURVIVE - ((STACON - 10) * 10), 40, 200)
			// [/SURREALIS-ADD]
			// [SURREALIS-EDIT] - VRCOMBAT
			// if(blood_volume <= BLOOD_VOLUME_BAD) // SURREALIS-EDIT - ORIGINAL
			// Health is now maxHealth - max(tox, oxy), so blood-loss oxy damage is lethal; bloodloss-immune mobs must skip it entirely.
			if(blood_volume <= BLOOD_VOLUME_BAD && !HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
			// [/SURREALIS-EDIT]
				if(mind && !has_status_effect(/datum/status_effect/debuff/critwounded)) //check if we have a mind and lack the status effect before we do our trait condition check. - So every NPC isn't running this.
					// [SURREALIS-REMOVE] - VRCOMBAT
					/*
					if(!HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE)) //uniquely undeath rituos users/vampires don't care for bloodloss, they do on arteries though.
					*/
					// [/SURREALIS-REMOVE]
					apply_status_effect(/datum/status_effect/debuff/critwounded) //apply critically wounded - more energy in cmode cost. Until fixed.
				// [SURREALIS-EDIT] - VRCOMBAT
				// SURREALIS-EDIT - ORIGINAL
				/*
				var/oxy_amt = blood_volume <= BLOOD_VOLUME_SURVIVE ? 3 : 1
				if(!mind)
					oxy_amt *= 3
					if(has_status_effect(/datum/status_effect/debuff/bloody_mess))
						oxy_amt *= 6
				adjustOxyLoss(oxy_amt)
				*/
				if(blood_volume <= 40)
					adjustOxyLoss(2)
				else if(blood_volume <= soft_crit_threshold)
					adjustOxyLoss(0.4)
				else
					adjustOxyLoss(0.2)
				// [/SURREALIS-EDIT]
				if(world.time >= last_gasp)
					last_gasp = world.time + rand(3 SECONDS, 9 SECONDS)
					if(ishuman(src))
						var/mob/living/carbon/human/H = src
						H.deathgasp_noise() // wanton noise pollution, blame RYON >:(
						if(H.mind && H.mind.key) // NPC filter
							H.deathgasp_visual()
							if(prob(50)) // mostly to halve the potential chatlog spam, we don't care if it never appears or always appear, on the former, tough luck, on the latter, drama queen
								H.emote(pick("struggles to breathe, deathly pale!"))

			// [SURREALIS-EDIT] - VRCOMBAT
			// else if((blood_volume > BLOOD_VOLUME_SURVIVE) || HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE)) // SURREALIS-EDIT - ORIGINAL
			else if((blood_volume > soft_crit_threshold) || HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
			// [/SURREALIS-EDIT]
				if(getOxyLoss())
					adjustOxyLoss(-1.6)

	//Bleeding out
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(bodypart.bandage && !HAS_BLOOD_DNA(bodypart.bandage))
			// [SURREALIS-EDIT] - VRCOMBAT
			// bodypart.process_bandage(bodypart.bleeding) // SURREALIS-EDIT - ORIGINAL
			bodypart.process_bandage()
			// [/SURREALIS-EDIT]
	bleed_rate = get_bleed_rate() // expensive proc, but we zero it on bled-out mobs
	if(HAS_TRAIT(src, TRAIT_ADRENALINE_RUSH))
		bleed_rate = FALSE
	// [SURREALIS-EDIT] - VRCOMBAT
	// if(bleed_rate) // SURREALIS-EDIT - ORIGINAL
	// 	bleed(bleed_rate) // SURREALIS-EDIT - ORIGINAL
	if(bleed_rate)
		var/hidden_part = min(hidden_bleed_rate, bleed_rate)
		if(bleed_rate - hidden_part > 0)
			bleed(bleed_rate - hidden_part)
		if(hidden_part > 0)
			bleed(hidden_part, internal = TRUE)
	// [/SURREALIS-EDIT]

	// Non-vampiric bloodpool regen.
	// We assume that in non-vampires bloodpool represents "usable" blood that is regenerated slower than blood_volume
	if(!clan && blood_volume > BLOOD_VOLUME_SAFE)
		adjust_bloodpool(BLOODPOL_REGEN, FALSE)

/mob/living/proc/get_bleed_rate()
	if (!blood_volume)
		return FALSE //the blood bag is empty, brother.
	var/bleed_rate = 0
	/*for(var/datum/wound/wound as anything in get_wounds())
		bleed_rate += wound.bleed_rate*/
	bleed_rate += simple_bleeding
	for(var/obj/item/embedded as anything in simple_embedded_objects)
		bleed_rate += embedded.embedding?.embedded_bloodloss
	return bleed_rate

/mob/living/carbon/get_bleed_rate()
	// [SURREALIS-REMOVE] - VRCOMBAT
	/*
	var/bleed_rate = 0
	*/
	// [/SURREALIS-REMOVE]
	if (!blood_volume) // if we have no blood, we can't rightly bleed, can we?
		return 0
	if(NOBLOOD in dna?.species?.species_traits)
		return 0
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	/*
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		bleed_rate += bodypart.get_bleed_rate()
	return bleed_rate
	*/
	if(bleed_cache_dirty)
		recalculate_bleed_cache()
	var/normal_bleed = cached_normal_bleed
	var/critical_bleed = cached_critical_bleed
	var/internal_bleed = cached_internal_bleed
	var/hidden_bleed = cached_hidden_bleed
	hidden_bleed_rate = 0
	internal_bleed_rate = 0
	if(cached_grab_suppression != 1)
		normal_bleed *= cached_grab_suppression
		critical_bleed *= cached_grab_suppression * 0.5
		internal_bleed *= cached_grab_suppression * 0.5
	var/external_bleed = normal_bleed + critical_bleed
	var/inner_bleed = internal_bleed + hidden_bleed
	if(external_bleed + inner_bleed <= 0)
		return 0
	var/inner_factor = 1
	if(in_hypotensive_shock())
		// Shock slows bleeding to a trickle.
		external_bleed *= SHOCK_BLEED_FRACTION
		inner_factor = SHOCK_INTERNAL_BLEED_FRACTION
		if(critical_bleed + internal_bleed > 0)
			external_bleed += SHOCK_BLEED_FLAT
		else if(hidden_bleed > 0)
			hidden_bleed += SHOCK_BLEED_FLAT / inner_factor
	else if(blood_volume < BLOOD_VOLUME_NORMAL)
		var/blood_pressure = blood_volume / BLOOD_VOLUME_NORMAL
		external_bleed *= blood_pressure ** CONSCIOUS_BLEED_PRESSURE_EXPONENT
		inner_factor = blood_pressure ** CONSCIOUS_INTERNAL_BLEED_PRESSURE_EXPONENT
	var/total_bleed = external_bleed + (internal_bleed + hidden_bleed) * inner_factor
	if(total_bleed <= 0.1)
		return 0
	hidden_bleed_rate = hidden_bleed * inner_factor
	internal_bleed_rate = internal_bleed * inner_factor
	return total_bleed

/// Checks for hypotensive shock.
/mob/living/carbon/proc/in_hypotensive_shock()
	return (blood_volume <= BLOOD_VOLUME_SURVIVE) || HAS_TRAIT(src, TRAIT_BP_CRASH)

/mob/living/carbon/proc/invalidate_bleed_cache()
	bleed_cache_dirty = TRUE

/mob/living/carbon/proc/recalculate_bleed_cache()
	var/total_normal = 0
	var/total_critical = 0
	var/total_internal = 0
	var/total_hidden = 0
	var/total_grab_suppress = 1
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		var/normal = 0
		var/critical = 0
		var/internal = 0
		var/hidden = 0
		var/max_bleed = 0
		var/plug_amount = 0
		for(var/obj/item/embedded as anything in bodypart.embedded_objects)
			plug_amount += embedded.embed_bleed_contribution
		for(var/datum/wound/wound as anything in bodypart.wounds)
			var/wound_bleed = wound.bleed_rate
			if(!wound_bleed)
				continue
			if(plug_amount && istype(wound, /datum/wound/dynamic/puncture))
				wound_bleed = max(wound_bleed - plug_amount, 0)
			max_bleed = max(max_bleed, wound_bleed)
			if(wound.is_hidden_bleed())
				hidden += wound_bleed
			else if(wound.internal_bleeding)
				internal += wound_bleed
			else if(wound.severity >= WOUND_SEVERITY_CRITICAL)
				critical += wound_bleed
			else
				normal += wound_bleed
		if(bodypart.is_clamped())
			hidden = min(hidden, 0.5)
		total_hidden += hidden
		if(bodypart.is_bandaged())
			if(!bodypart.try_bandage_expire())
				continue
		var/list/grabs = SANITIZE_LIST(bodypart.grabbedby)
		for(var/obj/item/grabbing/grab in grabs)
			total_grab_suppress *= grab.bleed_suppressing
		if(bodypart.is_clamped())
			normal = min(normal, 0.5)
			critical = min(critical, 0.5)
			internal = min(internal, 0.5)
		total_normal += max(normal, 0)
		total_critical += critical
		total_internal += internal
	cached_normal_bleed = total_normal
	cached_critical_bleed = total_critical
	cached_internal_bleed = total_internal
	cached_hidden_bleed = total_hidden
	cached_grab_suppression = total_grab_suppress
	bleed_cache_dirty = FALSE
	// [/SURREALIS-EDIT]

//Makes a blood drop, leaking amt units of blood from the mob
// [SURREALIS-EDIT] - VRCOMBAT
// /mob/living/proc/bleed(amt) // SURREALIS-EDIT - ORIGINAL
/mob/living/proc/bleed(amt, internal = FALSE)
// [/SURREALIS-EDIT]
	if(!blood_volume)
		return FALSE
	if(!iscarbon(src) && !HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		return FALSE

	amt *= get_bleed_mod()
	// [SURREALIS-EDIT] - VRCOMBAT
	// blood_volume = max(blood_volume - amt, 0) // SURREALIS-EDIT - ORIGINAL
	var/old_volume = blood_volume
	blood_volume = max(blood_volume - amt, 0)
	if(old_volume > 0 && !blood_volume && stat != DEAD && !HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE) && !HAS_TRAIT(src, TRAIT_NODEATH))
		to_chat(src, span_userdanger("The last of my lyfeblood ebbs from my ravaged body and soaks the cold earth below..."))
		death()
	// [/SURREALIS-EDIT]
	// [SURREALIS-ADD] - VRCOMBAT
	if(internal)
		return TRUE
	// [/SURREALIS-ADD]
	record_round_statistic(STATS_BLOOD_SPILT, amt)
	if(isturf(src.loc)) //Blood loss still happens in locker, floor stays clean
		add_drip_floor(src.loc, amt)
	var/vol2use
	if(amt > 1)
		vol2use = 'sound/misc/bleed (1).ogg'
	if(amt > 2)
		vol2use = 'sound/misc/bleed (2).ogg'
	if(amt > 3)
		vol2use = 'sound/misc/bleed (3).ogg'
	if(!(mobility_flags & MOBILITY_STAND))
		vol2use = null
	if(vol2use)
		playsound(get_turf(src), vol2use, 100, FALSE)

	return TRUE

// [SURREALIS-EDIT] - VRCOMBAT
// /mob/living/carbon/human/bleed(amt) // SURREALIS-EDIT - ORIGINAL
/mob/living/carbon/human/bleed(amt, internal = FALSE)
// [/SURREALIS-EDIT]
	amt *= physiology.bleed_mod
	if(!(NOBLOOD in dna.species.species_traits))
		return ..()
	return FALSE

/mob/living/proc/get_bleed_mod()
	. = 1
	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	/*
	if(HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
		. *= CRIT_RESISTANCE_EFFECTIVE_BLEEDRATE
	else if(HAS_TRAIT(src, TRAIT_BLOOD_RESISTANCE))
		. *= BLOOD_RESISTANCE_EFFECTIVE_BLEEDRATE

	if(STACON < CONSTITUTION_BLEEDRATE_CAP && STACON != 10)
		if(HAS_TRAIT(src, TRAIT_CRITICAL_WEAKNESS))
			. *= 2
		var/conbonus = STACON - 10
		. -= . * (conbonus * CONSTITUTION_BLEEDRATE_MOD)
	*/
	if(HAS_TRAIT(src, TRAIT_BLOOD_RESISTANCE))
		. *= BLOOD_RESISTANCE_EFFECTIVE_BLEEDRATE
	if(STACON < CONSTITUTION_BLEEDRATE_CAP && STACON != 10)
		. -= . * ((STACON - 10) * CONSTITUTION_BLEEDRATE_MOD)
	// [/SURREALIS-EDIT]
	if(surrendering)
		. /= 4
	if(istype(has_status_effect(/datum/status_effect/buff/adrenaline_rush), /datum/status_effect/buff/adrenaline_rush/psydon))
		. /= 2

/mob/living/proc/restore_blood()
	blood_volume = initial(blood_volume)
	bleed_rate = 0

/mob/living/carbon/human/restore_blood()
	blood_volume = BLOOD_VOLUME_NORMAL
	bleed_rate = 0

/mob/living/proc/get_blood_color()
	return

/mob/living/carbon/human/get_blood_color()
	return dna?.species?.blood_color || BLOOD_COLOR_RED

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to a container or other mob, preserving all data in it.
/mob/living/proc/transfer_blood_to(atom/movable/AM, amount, forced)
	if(!blood_volume || !AM.reagents)
		return 0
	if(blood_volume < BLOOD_VOLUME_BAD && !forced)
		return 0

	if(blood_volume < amount)
		amount = blood_volume

	var/blood_id = get_blood_id()
	if(!blood_id)
		return 0

	blood_volume -= amount

	var/list/blood_data = get_blood_data(blood_id)

	if(iscarbon(AM))
		var/mob/living/carbon/C = AM
		if(blood_id == C.get_blood_id())//both mobs have the same blood substance
			if(blood_id == /datum/reagent/blood) //normal blood
				if(!(blood_data["blood_type"] in get_safe_blood(C.dna.blood_type)))
					C.reagents.add_reagent(/datum/reagent/toxin, amount * 0.5)
					return 1

			C.blood_volume = min(C.blood_volume + round(amount, 0.1), BLOOD_VOLUME_MAXIMUM)
			return 1

	AM.reagents.add_reagent(blood_id, amount, blood_data, bodytemperature)
	return 1


/mob/living/proc/get_blood_data(blood_id)
	return

/mob/living/carbon/get_blood_data(blood_id)
	if(blood_id == /datum/reagent/blood) //actual blood reagent
		var/blood_data = list()
		//set the blood data
		blood_data["donor"] = src

		blood_data["blood_DNA"] = copytext(dna.unique_enzymes,1,0)
		var/list/temp_chem = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			temp_chem[R.type] = R.volume
		blood_data["trace_chem"] = list2params(temp_chem)
		if(mind)
			blood_data["mind"] = mind
		else if(last_mind)
			blood_data["mind"] = last_mind
		if(ckey)
			blood_data["ckey"] = ckey
		else if(last_mind)
			blood_data["ckey"] = ckey(last_mind.key)

		if(!suiciding)
			blood_data["cloneable"] = 1
		blood_data["blood_type"] = copytext(dna.blood_type,1,0)
		blood_data["gender"] = gender
		blood_data["real_name"] = real_name
		blood_data["features"] = dna.features
		blood_data["factions"] = faction
		return blood_data

//get the id of the substance this mob use as blood.
/mob/proc/get_blood_id()
	return

/mob/living/simple_animal/get_blood_id()
	if(blood_volume)
		return /datum/reagent/blood

/mob/living/carbon/human/get_blood_id()
	if(HAS_TRAIT(src, TRAIT_HUSK))
		return
	if(dna?.species)
		if(dna.species.exotic_blood)
			return dna.species.exotic_blood
		if((NOBLOOD in dna.species.species_traits))
			return
	return /datum/reagent/blood

// This is has more potential uses, and is probably faster than the old proc.
/proc/get_safe_blood(bloodtype)
	. = list()
	if(!bloodtype)
		return

	var/static/list/bloodtypes_safe = list(
		"A-" = list("A-", "O-"),
		"A+" = list("A-", "A+", "O-", "O+"),
		"B-" = list("B-", "O-"),
		"B+" = list("B-", "B+", "O-", "O+"),
		"AB-" = list("A-", "B-", "O-", "AB-"),
		"AB+" = list("A-", "A+", "B-", "B+", "O-", "O+", "AB-", "AB+"),
		"O-" = list("O-"),
		"O+" = list("O-", "O+"),
		"L" = list("L"),
		"U" = list("A-", "A+", "B-", "B+", "O-", "O+", "AB-", "AB+", "L", "U")
	)

	var/safe = bloodtypes_safe[bloodtype]
	if(safe)
		. = safe

//to add a splatter of blood or other mob liquid.
/mob/living/proc/add_splatter_floor(turf/T)
	if(!iscarbon(src))
		if(!HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
			return
	if(!get_blood_id())
		return
	if(!T)
		T = get_turf(src)

	if(istype(T, /turf/open/water))
		var/turf/open/water/W = T
		W.water_reagent = /datum/reagent/blood // this is dumb, but it works for now
		W.mapped = FALSE // no infinite vitae glitch
		W.water_maximum = 10
		W.water_volume = 10
		W.update_icon()
		return
	var/current_blood_color = get_blood_color() || BLOOD_COLOR_RED
	new /obj/effect/decal/cleanable/blood/splatter(T, current_blood_color)
	for(var/obj/effect/decal/cleanable/blood/B in T)
		if(istype(B, /obj/effect/decal/cleanable/blood/footprints))
			continue
		B.set_blood_color(current_blood_color)
	T?.pollute_turf(/datum/pollutant/metallic_scent, 30)

//to add splatters of blood onto nearby walls. When provided a certain force amount, also increases the range at which blood can appear on the walls.
//spill_amount also increases the amount of times to try and spill more blood; Particularly to give better feedback to dismembering something.
#define WALL_SPLATTER_CAP 3

/mob/living/proc/add_splatter_wall(turf/T, force, spill_amount)
	var/force_distance = force / 10
	if(force <= 0) //If the force doesn't do enough damage then dont do anything.
		return
	if(!iscarbon(src))
		if(!HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
			return
	if(!get_blood_id())
		return
	if(!T)
		T = get_turf(src)
	if(!isturf(T))
		return
	var/room = WALL_SPLATTER_CAP
	for(var/obj/effect/decal/cleanable/blood/splatter/walls/existing in T)
		room--
	for(var/turf/closed/w in orange(abs(force_distance), T))
		if(room <= 0)
			return
		room--
		var/obj/effect/decal/cleanable/blood/splatter/walls/wall_blood = new(T)
		wall_blood.set_blood_color(get_blood_color())
		if(spill_amount > 0)
			spill_amount--
			continue
		else
			break

#undef WALL_SPLATTER_CAP

/mob/living/proc/blood_spray(sdir)
	if(!sdir || !isturf(loc) || !get_blood_id() || (!iscarbon(src) && !HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS)))
		return
	var/turf/T = get_step(src, sdir)
	if(!T)
		return
	var/colour = get_blood_color()
	if(isclosedturf(T))
		new /obj/effect/decal/cleanable/blood/spray/wall(loc, colour, sdir)
		return
	var/mob/living/L = locate() in T
	if(L)
		L.drench(src)
		return
	var/obj/effect/decal/cleanable/blood/spray/S = new(T, colour)
	S.setDir(sdir)

/mob/living/proc/blood_squirt()
	if(!isturf(loc) || !get_blood_id())
		return
	var/sdir = pick(GLOB.alldirs)
	var/colour = get_blood_color()
	var/turf/T = loc
	for(var/i in 1 to rand(2, 3))
		var/turf/next = get_step(T, sdir)
		if(!next)
			return
		if(isclosedturf(next))
			new /obj/effect/decal/cleanable/blood/spray/wall(T, colour, sdir)
			return
		T = next
		var/mob/living/L = locate() in T
		if(L)
			L.drench(src)
			return
		var/obj/effect/decal/cleanable/blood/squirt/S = new(T, colour)
		S.setDir(sdir)

/mob/living/proc/drench(mob/living/source)
	add_mob_blood(source)
	for(var/obj/item/I as anything in get_equipped_items())
		I.add_mob_blood(source)
		I.update_slot_icon()

/mob/living/proc/add_drip_floor(turf/T, amt)
	if(!iscarbon(src))
		if(!HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
			return
	if(!get_blood_id())
		return
	if(!T)
		T = get_turf(src)

	if(HAS_TRAIT(src, TRAIT_BLEED_PAINT))
		var/obj/effect/ink_trail/existing_trail = locate(/obj/effect/ink_trail) in T
		if(existing_trail)
			existing_trail.refresh_lifetime()
		else
			new /obj/effect/ink_trail(T, src)

	if(amt > 3)
		if(istype(T, /turf/open/water))
			var/turf/open/water/W = T
			W.water_reagent = /datum/reagent/blood // this is dumb, but it works for now
			W.mapped = FALSE // no infinite vitae glitch
			W.water_maximum = 10
			W.water_volume = 10
			W.update_icon()
			return
	var/obj/effect/decal/cleanable/blood/puddle/P = locate() in T
	if(P)
		P.set_blood_color(get_blood_color())
		P.blood_vol += amt
		P.update_icon()
	else
		var/obj/effect/decal/cleanable/blood/drip/D = locate() in T
		if(D)
			D.set_blood_color(get_blood_color())
			D.blood_vol += amt
			D.drips++
			D.update_icon()
		else
			var/drip_type = amt >= ARTERY_LIMB_BLEEDRATE / 4 ? /obj/effect/decal/cleanable/blood/drip/big : /obj/effect/decal/cleanable/blood/drip
			new drip_type(T, get_blood_color())

/mob/living/carbon/human/add_drip_floor(turf/T, amt)
	if(!(NOBLOOD in dna.species.species_traits))
		..()

/mob/living/carbon/human/add_splatter_floor(turf/T, small_drip)
	if(!(NOBLOOD in dna.species.species_traits))
		..()

/mob/living/carbon/human/proc/deathgasp_visual()
	var/le_gasp = pick("gasp", "choke", "gag", "wheeze", "gurgle", "sputter")
	var/gasp_color = "#ffffff"
	switch(getOxyLoss())
		if(0 to 20)
			gasp_color = "#00ff40"
		if(21 to 40)
			gasp_color = "#c8ff00"
		if(41 to 60)
			gasp_color = "#eeff00"
		if(61 to 80)
			gasp_color = "#ff9100"
		if(81 to INFINITY)
			gasp_color = "#ff0000"
	var/gasptext = "<font color='[gasp_color]'>*[le_gasp]!* (dying)</font>"
	filtered_balloon_alert(TRAIT_COMBAT_AWARE, gasptext, show_self = FALSE)
	skill_filtered_balloon_alert(/datum/skill/misc/medicine, SKILL_LEVEL_APPRENTICE, gasptext, 0, 0)

/mob/living/carbon/human/proc/deathgasp_noise()
	var/gaspnoise = null
	if(gender == MALE)
		gaspnoise = pick('sound/vo/male/gen/mchoke1.ogg', 'sound/vo/male/gen/mchoke2.ogg', 'sound/vo/male/gen/mchoke3.ogg', 'sound/vo/male/gen/mchoke4.ogg')
	else if(gender == FEMALE)
		gaspnoise = pick('sound/vo/female/gen/femchoke1.ogg', 'sound/vo/female/gen/femchoke2.ogg', 'sound/vo/female/gen/femchoke3.ogg', 'sound/vo/female/gen/femchoke4.ogg')

	if(gaspnoise && !(HAS_TRAIT(src, TRAIT_NOBREATH)))
		playsound(get_turf(src), gaspnoise, vol = 50, ignore_walls = FALSE, quiet = TRUE) //Only if you can SEE said-dying person.
