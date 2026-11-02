/* THE GREAT SPECIES CHANGES DM.
This file is for all the generalist, minor mechanical changes to a species I'd like to introduce.
This includse new parts to access, different customization, taur bodies, markings, yada yada yada.
Anything that's already in-game can go here. If, for example, you want to add tusks to verminvolk or Lupians, make the file edits here.

If you want to add new sprites, markings, organs, whatever, you probably want to contain the code in its own .dm.
*/

/obj/item/bodypart/taur/goat
	name = "Digitigrade Legs"

/datum/species/anthromorph/New()
	. = ..()
	customizers += list(
		/datum/customizer/organ/horns/tusks,
	)
/datum/species/lupian
	allowed_taur_types = list(
		/obj/item/bodypart/taur/goat,
	)
/datum/species/tabaxi
	allowed_taur_types = list(
		/obj/item/bodypart/taur/goat,
	)
/datum/species/dracon
	allowed_taur_types = list(
		/obj/item/bodypart/taur/goat,
	)
/datum/species/akula
	allowed_taur_types = list(
		/obj/item/bodypart/taur/goat,
	)
/datum/species/lizardfolk
	allowed_taur_types = list(
		/obj/item/bodypart/taur/goat,
	)
/datum/species/moth
	allowed_taur_types = list(
		/obj/item/bodypart/taur/goat,
	)
/datum/species/vulpkanin
	allowed_taur_types = list(
		/obj/item/bodypart/taur/goat,
	)

/datum/customizer/organ/snout/anthro
	allows_disabling = TRUE

/datum/customizer/organ/snout/anthrosmall
	allows_disabling = TRUE

/datum/species/ooze
	is_subrace = TRUE

/datum/species/aasimar/New()
	. = ..()
	customizers += list(
		/datum/customizer/bodypart_feature/crest,
	)
