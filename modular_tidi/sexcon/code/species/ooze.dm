/datum/species/ooze/New()
	. = ..()
	customizers += list(
		/datum/customizer/bodypart_feature/pits,
		/datum/customizer/bodypart_feature/pubes,
	)
