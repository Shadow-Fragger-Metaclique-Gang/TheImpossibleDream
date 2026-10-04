/mob/living/carbon/handle_blood()
	. = ..()
	if(stat == DEAD || !ishuman(src) || HAS_TRAIT(src, TRAIT_JOURNEYS_END))
		return
	if((bodytemperature <= TCRYO) || HAS_TRAIT(src, TRAIT_HUSK) || (dna?.species && (NOBLOOD in dna.species.species_traits)))
		return
	var/mob/living/carbon/human/H = src
	if(H.has_massive_erection())
		var/blood_minimum = 117 + (STACON * 18) // Having six constitution or lower can drain you. Twelve and under is tier two blood loss.
		var/blood_extracted = min(blood_volume - blood_minimum, 2)
		if(blood_extracted > 0)
			blood_volume = max(blood_volume - blood_extracted, 0)
