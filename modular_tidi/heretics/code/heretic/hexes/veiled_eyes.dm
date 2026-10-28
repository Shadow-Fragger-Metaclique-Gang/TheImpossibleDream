// proof of concept hex that actually does something
// i highly encourage you to come up with funny ways to grief people, rather than simply stat debuffs or parry debuffs like the bishop's curses
// i don't want this to be just "cast -4 str on your target to frag him easier"
/datum/hex/veiled_eyes
	name = "\improper Hex of the Veiled Eyes"

/datum/hex/veiled_eyes/on_apply(mob/living/carbon/human/sufferer = victim)
	to_chat(sufferer, span_cult("My vision recedes, the colours of the world melt away..."))
	ADD_TRAIT(sufferer, TRAIT_CYCLOPS_LEFT, REF(src)) // somewhat hacky, but this avoids modifying core files.
	ADD_TRAIT(sufferer, TRAIT_CYCLOPS_RIGHT, REF(src)) // nothing actually checks for cyclops. in fact, cyclops doesn't actually remove your eye or anything. its purely just FOV.
	sufferer.add_client_colour(/datum/client_colour/monochrome)
	sufferer.update_fov_angles()

/datum/hex/veiled_eyes/on_remove(mob/living/carbon/human/sufferer = victim)
	to_chat(sufferer, span_cult("My vision returns to what it once was; hues make themselves known to me once more."))
	REMOVE_TRAIT(sufferer, TRAIT_CYCLOPS_LEFT, REF(src))
	REMOVE_TRAIT(sufferer, TRAIT_CYCLOPS_RIGHT, REF(src))
	sufferer.remove_client_colour(/datum/client_colour/monochrome)
	sufferer.update_fov_angles()
