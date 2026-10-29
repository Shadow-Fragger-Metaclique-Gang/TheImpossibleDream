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
	REMOVE_TRAIT(sufferer, TRAIT_CYCLOPS_LEFT, REF(src))
	REMOVE_TRAIT(sufferer, TRAIT_CYCLOPS_RIGHT, REF(src))
	sufferer.update_fov_angles()

	var/list/all_hexes = list()
	if(sufferer.active_hexes)
		all_hexes |= sufferer.active_hexes
	if(sufferer.shared_hexes)
		all_hexes |= sufferer.shared_hexes
	for(var/datum/hex/hex as anything in all_hexes) // we want to ONLY remove our colorblindness and send a message if our vision actually gets fixed. which, if we have more than one copy of veiled eyes, we wont.
		if(hex == src || hex.suspended)
			continue
		if(istype(hex, /datum/hex/veiled_eyes))
			return
	to_chat(sufferer, span_cult("My vision returns to what it once was; hues make themselves known to me once more."))
	sufferer.remove_client_colour(/datum/client_colour/monochrome)
