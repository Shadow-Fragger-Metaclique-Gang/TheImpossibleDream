// TIEFLINGS GET WINGS HERE.
/obj/item/organ/wings/tieberian
	name = "tiefling wings"
	desc = "A pair of impish, leathery wings."

/datum/customizer/organ/wings/tieberian
	customizer_choices = list(/datum/customizer_choice/organ/wings/tieberian)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/wings/tieberian
	name = "Impish Wings"
	organ_type = /obj/item/organ/wings/tieberian
	sprite_accessories = list(
		/datum/sprite_accessory/wings/bat,
		/datum/sprite_accessory/wings/wide/succubus
	)

// ENABLES ANGEL WINGS
/datum/customizer_choice/organ/wings/anthro/New()
	sprite_accessories += list(
		/datum/sprite_accessory/wings/huge/angel
	)
	..()

/datum/customizer_choice/organ/wings/slime/New() // slimes get the same as anthros, so let's continue the trend
	sprite_accessories += list(
		/datum/sprite_accessory/wings/huge/angel
	)
	..()
