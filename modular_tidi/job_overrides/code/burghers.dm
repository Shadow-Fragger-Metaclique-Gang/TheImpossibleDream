// A Malum Guildmaster gets T4 miracles, Ritualist and Expert holy skill.
/datum/outfit/job/roguetown/guildmaster/basic/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind && H.patron?.type == /datum/patron/divine/malum)
		H.adjust_skillrank(/datum/skill/magic/ritualist, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_EXPERT, TRUE)
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T4, start_maxed = TRUE)
		LAZYSET(backpack_contents, /obj/item/ritechalk, 1)
		wrists = /obj/item/clothing/neck/roguetown/psicross/malum
