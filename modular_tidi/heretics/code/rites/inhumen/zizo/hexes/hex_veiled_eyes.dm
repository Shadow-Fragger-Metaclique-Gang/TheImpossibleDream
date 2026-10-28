/datum/runeritual/god/hex/zizo/veiled_eyes
	name = "Hex of the Veiled Eyes"
	desc = "Your victim's vision will be harshly reduced."
	flavor = "Cloak your enemy's vision with lingering shadows, making it challenging to see the world as it is."
	tier = SKILL_LEVEL_NOVICE
	awakened_heretic_only = TRUE
	layout = list(
		"N" = /obj/item/organ/eyes,
		"C" = /obj/item/wax_doll,
		"S" = /obj/item/candle
		)
	chant_lines = list(
	"#ZIZO! Pry their eyes away from me!",
	"#They have too much to see! Too much to bear!",
	"...ZIZO! Grant them the comfort of ignorance!",
	)

/datum/runeritual/god/hex/zizo/veiled_eyes/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/obj/item/organ/eyes/focus = selected_atoms["N"]
	var/obj/item/wax_doll/doll = selected_atoms["C"]

	if(focus.hex_focus)
		to_chat(user, span_warning("I'm already sustaining a hex with this focus. I must find another one."))
		return FALSE
	if(!doll.targetted_victim)
		to_chat(user, span_warning("The effigy melts away and disintegrates into nothingness. What happened to my victim..?"))
		qdel(doll)
		return FALSE

	var/datum/hex/veiled_eyes/hex = new
	if(!hex.apply(user, doll.targetted_victim, focus))
		return FALSE

	return TRUE
