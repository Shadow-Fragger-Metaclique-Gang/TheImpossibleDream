/obj/structure/barricade/mineshaft
	name = "mineshaft support"
	desc = "This'll stop those tremors from triggering."
	icon = 'modular_tidi/mineshaft_collapse/icons/mineshaft.dmi'
	icon_state = "woodenbarricade_mineshaft"
	pass_flags = LETPASSTHROW
	density = FALSE

/obj/structure/barricade/mineshaft/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("This will prevent mineshaft collapses of a radius of seven steps.")

/datum/crafting_recipe/roguetown/structure/mineshaft_support
	name = "mineshaft support"
	category = "Misc"
	result = /obj/structure/barricade/mineshaft
	reqs = list(/obj/item/grown/log/tree/small = 1)
	ontile = TRUE
	verbage_simple = "set up"
	verbage = "sets up"
	buildsame = TRUE
