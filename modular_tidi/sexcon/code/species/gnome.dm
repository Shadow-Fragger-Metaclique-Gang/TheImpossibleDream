/datum/species/dwarf/gnome/New()
	. = ..()
	customizers += list(
		/datum/customizer/bodypart_feature/pits,
		/datum/customizer/bodypart_feature/pubes,
	)
	offset_features[OFFSET_BREASTS] = list(0,-4)
	offset_features[OFFSET_BREASTS_F] = list(0,-4)
