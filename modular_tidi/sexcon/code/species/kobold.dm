/datum/species/kobold/New()
	. = ..()
	customizers += list(
		/datum/customizer/bodypart_feature/pits/feathered,
		/datum/customizer/bodypart_feature/pubes/feathered,
	)
	offset_features[OFFSET_BREASTS] = list(0,-4)
	offset_features[OFFSET_BREASTS_F] = list(0,-4)
