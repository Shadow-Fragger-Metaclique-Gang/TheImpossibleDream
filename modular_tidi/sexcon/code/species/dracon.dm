/datum/species/dracon/New()
	. = ..()
	customizers += list(
		/datum/customizer/bodypart_feature/pits/feathered,
		/datum/customizer/bodypart_feature/pubes/feathered,
		/datum/customizer/organ/tail/manticore,
	)
	offset_features[OFFSET_BREASTS] = list(0,1)
	offset_features[OFFSET_BREASTS_F] = list(0,-1)
