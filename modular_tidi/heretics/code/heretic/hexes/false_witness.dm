/datum/hex/false_witness
	name = "\improper Hex of the False Witness"

/datum/hex/false_witness/on_apply(mob/living/carbon/human/sufferer = victim) // this one is silent
	ADD_TRAIT(sufferer, FALSE_WITNESS_TRAIT, REF(src))

/datum/hex/false_witness/on_remove(mob/living/carbon/human/sufferer = victim)
	REMOVE_TRAIT(sufferer, FALSE_WITNESS_TRAIT, REF(src))
