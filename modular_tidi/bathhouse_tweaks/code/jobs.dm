/datum/outfit/job/roguetown/bathmaster/basic/pre_equip(mob/living/carbon/human/H)
	..()
//	belt2 = /obj/item/storage/keyring/bathmaster
//	wrists = null
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular/pileappraisal)

