/datum/species/goblinp/New()
	. = ..()
	customizers += list(
		/datum/customizer/bodypart_feature/pubes,
		/datum/customizer/bodypart_feature/pits,
	)
	offset_features[OFFSET_BREASTS] = list(0,-4)
	offset_features[OFFSET_BREASTS_F] = list(0,-5)
