/datum/species/lizardfolk/New()
	. = ..()
	customizers += list(
		/datum/customizer/bodypart_feature/pits/feathered,
		/datum/customizer/bodypart_feature/pubes/feathered,
		/datum/customizer/organ/tail/manticore,
	)
