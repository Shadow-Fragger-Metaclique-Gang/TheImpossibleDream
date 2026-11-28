/mob/living/carbon/proc/species_has_organ(slot)
	var/list/species_organs = dna?.species?.organs
	return species_organs && species_organs[slot]

/mob/living/carbon/proc/handle_missing_organs()
	if(stat == DEAD)
		return
	if(ishuman(src) && !getorganslot(ORGAN_SLOT_HEART))
		var/mob/living/carbon/human/heartless = src
		heartless.handle_heart()
	if(species_has_organ(ORGAN_SLOT_LIVER) && !getorganslot(ORGAN_SLOT_LIVER))
		liver_failure()
	handle_missing_stomach()

/mob/living/carbon/proc/handle_missing_stomach()
	if(!species_has_organ(ORGAN_SLOT_STOMACH) || getorganslot(ORGAN_SLOT_STOMACH) || HAS_TRAIT(src, TRAIT_NOHUNGER) || HAS_TRAIT(src, TRAIT_NOMETABOLISM))
		set_battered_floor("stomach", 0)
		return
	set_battered_floor("stomach", BATTERED_STOMACH_MISSING)
	if(!(NOBLOOD in dna.species.species_traits))
		blood_volume = max(blood_volume - 10, 0)
	if(prob(5) && !stat)
		emote("painscream")
		to_chat(src, span_warning("My insides burn with horrible agony!"))

/mob/living/carbon/proc/missing_organ_slots()
	. = list()
	for(var/slot in list(ORGAN_SLOT_HEART, ORGAN_SLOT_LIVER, ORGAN_SLOT_STOMACH))
		if(species_has_organ(slot) && !getorganslot(slot))
			. += slot
