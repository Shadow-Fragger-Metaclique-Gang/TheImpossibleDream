/atom/movable/screen/alert/status_effect/emberwine
	name = "Aphrodesiac"
	desc = "The warmth is spreading through my body..."
	icon = 'modular_tidi/sexcon/icons/screen_alert.dmi'
	icon_state = "emberwine"

/datum/status_effect/debuff/emberwine
	id = "emberwine"
	effectedstats = list("strength" = -1, "willpower" = -2, "speed" = -2, "intelligence" = -3)
	duration = 1 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/emberwine
