/datum/species/tieberian/New()
	. = ..()
	customizers += list(
		/datum/customizer/bodypart_feature/pits,
		/datum/customizer/bodypart_feature/pubes,
		/datum/customizer/organ/tail/manticore,
	)
