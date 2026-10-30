/datum/runeritual/god/hex/matthios/plunderer
	name = "Hex of the Plunderer"
	flavor = "Your victim's riches shall crumble in their very hands."
	tier = SKILL_LEVEL_JOURNEYMAN
	awakened_heretic_only = TRUE
	layout = list(
		"NW" = /obj/item/roguecoin/gold,
		"N" = list(/obj/item/bodypart/l_arm, /obj/item/bodypart/r_arm),
		"NE" = /obj/item/roguecoin/copper,
		"W" = /obj/item/storage/belt/rogue/pouch,
		"C" = /obj/item/wax_doll,
		"E" = /obj/item/storage/belt/rogue/pouch,
		"S" = /obj/item/rope/chain
		)
	chant_lines = list(
	"Matthios! Fiddler-upon-flames!",
	"Let kings be beggars, and beggars be kings!",
	"Great Leveller! Take from them what they hold dear!",
	)

/datum/runeritual/god/hex/matthios/plunderer/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/obj/item/roguecoin/gold/focus = selected_atoms["N"]
	var/obj/item/wax_doll/doll = selected_atoms["C"]

	if(focus.hex_focus)
		to_chat(user, span_warning("I'm already sustaining a hex with this focus. I must find another one."))
		return FALSE
	if(!doll.targetted_victim)
		to_chat(user, span_warning("The effigy melts away and disintegrates into nothingness. What happened to my victim..?"))
		qdel(doll)
		return FALSE

	var/datum/hex/plunderer/hex = new
	if(!hex.apply(user, doll.targetted_victim, focus))
		return FALSE

	return TRUE
