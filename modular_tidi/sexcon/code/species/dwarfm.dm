/datum/species/dwarf/mountain/New()
	. = ..()
	customizers += list(
		/datum/customizer/bodypart_feature/pits/braids,
		/datum/customizer/bodypart_feature/pubes/braids,
	)
	offset_features[OFFSET_BREASTS] = list(0,-4)
	offset_features[OFFSET_BREASTS_F] = list(0,-4)
