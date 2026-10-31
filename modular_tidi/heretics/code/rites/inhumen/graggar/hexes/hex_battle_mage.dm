/datum/runeritual/god/hex/graggar/battle_mage
	name = "Hex of the Battle Mage"
	flavor = "Call upon GRAGGAR to force the masters of the arcane into glorious, hand-to-hand combat! They shall bathe in blood, for HE demands it!"
	desc = "Ineffective on those who do not practice thaumaturgy or those who have already been afflicted by this hex."
	tier = SKILL_LEVEL_APPRENTICE
	awakened_heretic_only = TRUE
	layout = list(
		"N" = /obj/item/clothing/gloves/roguetown/knuckles,
		"C" = /obj/item/wax_doll,
		"S" = /obj/item/rogueweapon/woodstaff
		)
	chant_lines = list(
	"GLORIOUS FORCE, O' MOTIVE VIOLENCE!",
	"FORGET CLEVER TRICKS, FORGET MAGIC!",
	"THEY SHALL FIGHT LIKE AN ANIMAL! LET THE BLOOD FLOOOOOW!!",
	)

/datum/runeritual/god/hex/graggar/battle_mage/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/obj/item/clothing/gloves/roguetown/knuckles/focus = selected_atoms["N"]
	var/obj/item/wax_doll/doll = selected_atoms["C"]

	if(focus.hex_focus)
		to_chat(user, span_warning("THIS FOCUS ALREADY HOLDS MAGICK! GRAGGAR DEMANDS ANOTHER!"))
		return FALSE
	if(!doll.targetted_victim)
		to_chat(user, span_warning("ARGH! MY EFFIGY MELTS AWAY! WHAT HAPPENED?!"))
		qdel(doll)
		return FALSE

	var/datum/hex/battle_mage/hex = new
	if(!hex.apply(user, doll.targetted_victim, focus))
		return FALSE

	return TRUE
