// Every Jester gets Xylix's T4 miracles regardless of their patron.
/datum/outfit/job/roguetown/jester/pre_equip(mob/living/carbon/human/H)
	..()
	if(!H.mind)
		return
	var/datum/patron/xylix = GLOB.patronlist[/datum/patron/divine/xylix]
	H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_EXPERT, TRUE)
	if(H.patron?.type == /datum/patron/divine/xylix)
		H.adjust_skillrank(/datum/skill/magic/ritualist, SKILL_LEVEL_EXPERT, TRUE)
		LAZYSET(backpack_contents, /obj/item/ritechalk, 1)
	wrists = /obj/item/clothing/neck/roguetown/psicross/xylix
	var/datum/devotion/C = new /datum/devotion(H, xylix)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, start_maxed = TRUE)
