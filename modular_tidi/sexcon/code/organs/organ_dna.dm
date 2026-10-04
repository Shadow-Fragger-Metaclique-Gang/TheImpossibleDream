/datum/organ_dna/breasts/var/lactating = FALSE

/datum/organ_dna/breasts/imprint_organ(obj/item/organ/organ)
	. = ..()
	var/obj/item/organ/breasts/breasts_organ = organ
	breasts_organ.lactating = lactating
	breasts_organ.milk_max = max(75, breasts_organ.breast_size * 100)
