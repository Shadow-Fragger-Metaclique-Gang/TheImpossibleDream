/datum/hex/veiled_eyes
	name = "Veiled Eyes"

/datum/hex/veiled_eyes/on_apply()
	to_chat(victim, span_cult("My vision recedes, the colours of the world melt away..."))
	ADD_TRAIT(victim, TRAIT_CYCLOPS_LEFT, REF(src)) // somewhat hacky, but this avoids modifying core files.
	ADD_TRAIT(victim, TRAIT_CYCLOPS_RIGHT, REF(src)) // nothing actually checks for cyclops. in fact, cyclops doesn't actually remove your eye or anything. its purely just FOV.
	victim.add_client_colour(/datum/client_colour/monochrome)
	victim.update_fov_angles()

/datum/hex/veiled_eyes/on_remove()
	to_chat(victim, span_cult("My vision returns to what it once was; hues make themselves known to me once more."))
	REMOVE_TRAIT(victim, TRAIT_CYCLOPS_LEFT, REF(src))
	REMOVE_TRAIT(victim, TRAIT_CYCLOPS_RIGHT, REF(src))
	victim.remove_client_colour(/datum/client_colour/monochrome)
	victim.update_fov_angles()
