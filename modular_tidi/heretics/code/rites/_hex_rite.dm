/datum/runeritual/god/hex
	abstract_type = /datum/runeritual/god/hex

/datum/runeritual/god/hex/cleanup_atoms(list/selected_atoms) // Removes EVERYTHING except the focus. The focus should ALWAYS be on N.
	var/list/consumed_atoms = selected_atoms.Copy()
	consumed_atoms -= "N"
	return ..(consumed_atoms)

// boiler plate hexing ritual
// dont forget to make your hex in \code\heretic\hexes
/datum/runeritual/god/hex/debug
	name = "Hex of the Debugger"
	desc = "Googoobabies"
	flavor = "Stuff"
	tier = SKILL_LEVEL_NOVICE
	awakened_heretic_only = TRUE
	layout = list(
		"N" = /obj/item/,
		"C" = /obj/item/wax_doll,
		)
	chant_lines = list(
	"#CODERBUS",
	"#CODERBUSCODERBUS",
	"SAVEMEFROMMYSHITCODE!",
	)

/datum/runeritual/god/hex/debug/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/obj/item/focus = selected_atoms["N"] // focus should always be on N since that's the only ingredient that isn't consumed
	var/obj/item/wax_doll/doll = selected_atoms["C"] // doll can be on any spot as long as you don't forget to point towards it. i like C because it makes the most sense.

	if(focus.hex_focus) // can't use a focus twice sorry pal
		to_chat(user, span_warning("I'm already sustaining a hex with this focus. I must find another one."))
		return FALSE
	if(!doll.targetted_victim) // if the target were to FT or be deleted between the making of this doll and the cursing
		to_chat(user, span_warning("The effigy melts away and disintegrates into nothingness. What happened to my victim..?"))
		qdel(doll) // we delete it because a targetless doll is nothing but a fumo
		return FALSE

	var/datum/hex/debug/hex = new
	if(!hex.apply(user, doll.targetted_victim, focus))
		return FALSE

	to_chat(user, span_cult("Citrus overwhelms your mouth."))
	return TRUE
