/datum/runeritual/god/hex/zizo/false_witness
	name = "Hex of the False Witness"
	flavor = "Profane your victim's blood, ensuring it returns positive results from thaumaturgic investigation."
	tier = SKILL_LEVEL_NOVICE
	awakened_heretic_only = TRUE
	layout = list(
		"N" = /obj/item/organ/tongue,
		"C" = /obj/item/wax_doll,
		"W" = /obj/item/roguecoin/gold,
		"E" = /obj/item/roguecoin/gold,
		"SW" = /obj/item/roguecoin/gold,
		"S" = /obj/item/roguecoin/gold,
		"SE" = /obj/item/roguecoin/gold
		)
	chant_lines = list( // the curse itself is stealthy. the ritual, on the other hand...
	"ZIZO! Please focus your gaze upon this fool!",
	"ZIZO! Brand this one's lyfeblood with your gift!",
	"ZIZO! Rot them from the inside out!",
	)

/datum/runeritual/god/hex/zizo/false_witness/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/obj/item/organ/tongue/focus = selected_atoms["N"]
	var/obj/item/wax_doll/doll = selected_atoms["C"]

	if(focus.hex_focus)
		to_chat(user, span_warning("I'm already sustaining a hex with this focus. I must find another one."))
		return FALSE
	if(!doll.targetted_victim)
		to_chat(user, span_warning("The effigy melts away and disintegrates into nothingness. What happened to my victim..?"))
		qdel(doll)
		return FALSE

	var/datum/hex/false_witness/hex = new
	if(!hex.apply(user, doll.targetted_victim, focus))
		return FALSE

	to_chat(user, span_cult("The tongue shrivels up into a desiccated piece of meat."))
	return TRUE
