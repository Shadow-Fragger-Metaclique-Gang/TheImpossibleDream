// HAIRS PORTED FROM OTHER SERVERS
/datum/customizer_choice/bodypart_feature/hair/head/humanoid/New()
	sprite_accessories += list(
		/datum/sprite_accessory/hair/head/ported_customization/renard,
		/datum/sprite_accessory/hair/head/ported_customization/willowtree,
		/datum/sprite_accessory/hair/head/ported_customization/nimue,
		/datum/sprite_accessory/hair/head/ported_customization/willow
	)

/datum/sprite_accessory/hair/head/ported_customization/ // so we don't have to copy & paste icon for everything.
	icon = 'modular_tidi/ported_customization/icons/human_hair.dmi'

/datum/sprite_accessory/hair/head/ported_customization/renard
	name = "Renard"
	icon_state = "renard"

/datum/sprite_accessory/hair/head/ported_customization/willowtree
	name = "Willowtree"
	icon_state = "willowtree"

/datum/sprite_accessory/hair/head/ported_customization/nimue
	name = "Nimue"
	icon_state = "nimue"

/datum/sprite_accessory/hair/head/ported_customization/willow
	name = "Willow"
	icon_state = "willow"
