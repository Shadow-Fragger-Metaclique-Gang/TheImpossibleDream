/datum/species/anthromorphsmall/New()
	. = ..()
	customizers += list(
		/datum/customizer/bodypart_feature/pits/furry,
		/datum/customizer/bodypart_feature/pubes/furry,
		/datum/customizer/organ/tail/manticore,
	)
	offset_features[OFFSET_BREASTS] = list(0,-4)
	offset_features[OFFSET_BREASTS_F] = list(0,-5)
