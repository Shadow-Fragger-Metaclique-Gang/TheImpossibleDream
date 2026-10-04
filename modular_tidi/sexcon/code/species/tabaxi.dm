/datum/species/tabaxi/New()
	. = ..()
	customizers += list(
		/datum/customizer/bodypart_feature/pits/furry,
		/datum/customizer/bodypart_feature/pubes/furry,
	)
	offset_features[OFFSET_BREASTS] = list(0,1)
	offset_features[OFFSET_BREASTS_F] = list(0,-1)
