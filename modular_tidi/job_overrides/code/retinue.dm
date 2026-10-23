/datum/job/roguetown/knight
	total_positions = 2
	spawn_positions = 2
	job_traits = list(TRAIT_NOBLE, TRAIT_STEELHEARTED, TRAIT_EXPERT_HUNTER)

/datum/job/roguetown/squire
	total_positions = 3
	spawn_positions = 3
	job_traits = list(TRAIT_SQUIRE_REPAIR, TRAIT_EXPERT_HUNTER)

/datum/advclass/squire/lancer/post_equip(mob/living/carbon/human/H)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)

/datum/advclass/squire/footman/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(locate(/obj/item/rogueweapon/sword/iron) in H)
		H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
	else if(locate(/obj/item/rogueweapon/mace/cudgel) in H)
		H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)

/datum/advclass/squire/skirmisher/post_equip(mob/living/carbon/human/H)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
