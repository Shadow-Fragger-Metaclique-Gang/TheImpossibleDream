/datum/runeritual/god/hex/baotha/soulbound
	name = "\improper Hex of the Soulbound"
	flavor = "Calls upon Baotha to unite your two targets, so that they may share lyfe's joys and sorrows."
	tier = SKILL_LEVEL_JOURNEYMAN // This is quite griefy
	awakened_heretic_only = TRUE
	layout = list(
		"N" = /obj/item/organ/heart, // expensive because, once again, this is quite the griefy hex
		"W" = /obj/item/wax_doll,
		"E" = /obj/item/wax_doll,
		"C" = list(/obj/item/reagent_containers/lux, /obj/item/reagent_containers/lux_impure),
		"S" = /obj/item/needle
		)
	chant_lines = list(
	"A shared joy is doubled bliss!",
	"A shared sorrow is doubled despair!",
	"Baotha, unite these two souls so that they may share all these wonderful experiences!",
	)

/datum/runeritual/god/hex/baotha/soulbound/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/obj/item/focus = selected_atoms["N"] // focus should always be on N since that's the only ingredient that isn't consumed
	var/obj/item/wax_doll/doll1 = selected_atoms["W"] // we need 2 dolls for this
	var/obj/item/wax_doll/doll2 = selected_atoms["E"]

	if(focus.hex_focus) // can't use a focus twice sorry pal
		to_chat(user, span_warning("I'm already sustaining a hex with this focus. I must find another one."))
		return FALSE
	if(!doll1.targetted_victim) // ugly copy paste ifs but we don't want to delete the two dolls because one target happened to FT
		to_chat(user, span_warning("The effigy melts away and disintegrates into nothingness. What happened to my victim..?"))
		qdel(doll1)
		return FALSE
	if(!doll2.targetted_victim)
		to_chat(user, span_warning("The effigy melts away and disintegrates into nothingness. What happened to my victim..?"))
		qdel(doll2)
		return FALSE
	if(doll1.targetted_victim == doll2.targetted_victim) // you can't make someone co-dependent on themselves thats not how it works
		return FALSE

	var/datum/hex/soulbound/hex = new
	if(!hex.apply_soulbound(user, doll1.targetted_victim, doll2.targetted_victim, focus))
		return FALSE

	return TRUE
