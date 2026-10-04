/datum/body_build/bulky/New()
	. = ..()
	offset_features[OFFSET_BREASTS] = list(0,1)
	offset_features[OFFSET_BREASTS_F] = list(0,-1)

/datum/body_build/slim/New()
	. = ..()
	offset_features[OFFSET_BREASTS] = list(0,0)
	offset_features[OFFSET_BREASTS_F] = list(0,-1)

/datum/body_build/elven/New()
	. = ..()
	offset_features[OFFSET_BREASTS] = list(0,1)
	offset_features[OFFSET_BREASTS_F] = list(0,0)
