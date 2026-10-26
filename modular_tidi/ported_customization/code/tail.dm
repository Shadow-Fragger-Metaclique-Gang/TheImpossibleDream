// TAILS PORTED FROM OTHER SERVERS
/datum/customizer_choice/organ/tail/tiefling/New()
	sprite_accessories += list(
		/datum/sprite_accessory/tail/tiefling/spade
	)
	return ..()

/datum/customizer_choice/organ/tail/manticore/New()
	sprite_accessories += list(
		/datum/sprite_accessory/tail/tiefling/tailmaw,
		/datum/sprite_accessory/tail/tiefling/heart/tailmaw,
		/datum/sprite_accessory/tail/tiefling/spadeheart/tailmaw,
		/datum/sprite_accessory/tail/tiefling/spade/tailmaw
	)
	return ..()

/datum/sprite_accessory/tail/tiefling/tailmaw
	name = "Tiefling (Tailmaw)"

/datum/sprite_accessory/tail/tiefling/heart/tailmaw
	name = "Succubus (Tailmaw)"

/datum/sprite_accessory/tail/tiefling/spade
	name = "Spade"
	icon = 'modular_tidi/ported_customization/icons/tiefling.dmi'
	icon_state = "spade"
	can_wag = FALSE

/datum/sprite_accessory/tail/tiefling/spade/tailmaw
	name = "Spade (Tailmaw)"
	can_wag = FALSE

/datum/sprite_accessory/tail/tiefling/spadeheart/tailmaw
	name = "Succubus (Alt) (Tailmaw)"
	icon = 'modular_tidi/ported_customization/icons/tiefling.dmi'
	icon_state = "spadeheart"
