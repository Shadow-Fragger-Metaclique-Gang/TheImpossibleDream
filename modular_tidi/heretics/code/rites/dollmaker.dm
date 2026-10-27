/datum/runeritual/god/dollmaker
	name = "Rite of the Dollmaker"
	desc = "Creates a wax doll shaped in the likeness of the last person you have examined. Used for hexing."
	flavor = "With hatred in your heart, and your victim still fresh in your mind's eye, the Anathema will guide your hands in creating the perfect idol to spit upon, to direct your hatred towards... And, of course, to curse."
	tier = SKILL_LEVEL_NOVICE
	awakened_heretic_only = TRUE
	layout = list("C" = /obj/item/candle)
	chant_lines = list(
	"#Anathema, I beseech your guidance!", // Most of it is whispered as this isn't a ritual that does really anything beside let you target someone.
	"#See whom I have Seen...",
	"...And mold this wax in their likeness!",
	)

/obj/item/wax_doll
	name = "wax doll"
	desc = ""
	icon = 'modular_tidi/heretics/icons/wax_doll.dmi'
	icon_state = "doll"
	var/mob/living/carbon/human/targetted_victim

/obj/item/wax_doll/examine(mob/user)
	if(user.mind?.heretic_path && targetted_victim)
		desc = "A doll shaped from wax. Its face is the spitting image of [targetted_victim]."
	else
		desc = "A crude effigy molded from wax. It doesn't particularly look like anything."
	. = ..()

/datum/runeritual/god/dollmaker/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/mob/living/carbon/human/examiner = user
	var/mob/living/carbon/human/target = examiner.last_examined

	if(!target)
		to_chat(user, span_warning("...My mind draws a blank. I should get another look at my victim."))
		return FALSE

	var/obj/item/wax_doll/doll = new(loc)
	doll.targetted_victim = target

	to_chat(user, span_cult("My hands move on their own, the wax takes shape beneath my fingers. I recognize this face."))
	return TRUE

