/datum/species/moth/New()
	. = ..()
	customizers += list(
		/datum/customizer/bodypart_feature/pits/fuzzy,
		/datum/customizer/bodypart_feature/pubes/fuzzy,
	)
	offset_features[OFFSET_BREASTS] = list(0,1)
	offset_features[OFFSET_BREASTS_F] = list(0,-1)
