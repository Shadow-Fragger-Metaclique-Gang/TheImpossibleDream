/mob/living/proc/swap_ritualist_trait(source)
	REMOVE_TRAIT(src, TRAIT_RITUALIST, source) // Over all looks nicer than copy and pasting it a dozen times
	adjust_skillrank_up_to(/datum/skill/magic/ritualist, SKILL_LEVEL_EXPERT, TRUE)

/datum/job/roguetown/templar/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()
	H.swap_ritualist_trait(JOB_TRAIT)

/datum/job/roguetown/druid/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()
	H.swap_ritualist_trait(JOB_TRAIT)

/datum/job/roguetown/monk/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()
	H.swap_ritualist_trait(JOB_TRAIT)

/datum/job/roguetown/priest/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()
	H.swap_ritualist_trait(JOB_TRAIT)

/datum/job/roguetown/painter/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()
	H.swap_ritualist_trait(JOB_TRAIT)

/datum/advclass/wretch/heretic/equipme(mob/living/carbon/human/H, dummy = FALSE)
	. = ..()
	H.swap_ritualist_trait(ADVENTURER_TRAIT)

/datum/advclass/wretch/munitioneer/equipme(mob/living/carbon/human/H, dummy = FALSE)
	. = ..()
	H.swap_ritualist_trait(ADVENTURER_TRAIT)

/datum/advclass/iconoclast/equipme(mob/living/carbon/human/H, dummy = FALSE)
	. = ..()
	H.swap_ritualist_trait(ADVENTURER_TRAIT)

/datum/advclass/gnoll/shaman/equipme(mob/living/carbon/human/H, dummy = FALSE)
	. = ..()
	H.swap_ritualist_trait(ADVENTURER_TRAIT)

/datum/advclass/hag/equipme(mob/living/carbon/human/H, dummy = FALSE)
	. = ..()
	H.swap_ritualist_trait(ADVENTURER_TRAIT)

/datum/advclass/heartfelt/retinue/prior/equipme(mob/living/carbon/human/H, dummy = FALSE)
	. = ..()
	H.swap_ritualist_trait(ADVENTURER_TRAIT)

/datum/advclass/grenzel_priest/equipme(mob/living/carbon/human/H, dummy = FALSE)
	. = ..()
	H.swap_ritualist_trait(ADVENTURER_TRAIT)

/datum/antagonist/lich/equip_and_traits()
	. = ..()
	owner.current.swap_ritualist_trait("[type]")

/datum/antagonist/dreamwalker/reset_stats()
	. = ..()
	owner.current.swap_ritualist_trait("[type]")

/datum/outfit/job/dark_itinerant_knight/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.swap_ritualist_trait(TRAIT_GENERIC)

/datum/hag_boon/trait/ritualist
	var/ritualism_raised = 0

/datum/hag_boon/trait/ritualist/apply_boon_effect(mob/living/L)
	. = ..()
	ritualism_raised = max(SKILL_LEVEL_EXPERT - L.get_skill_level(/datum/skill/magic/ritualist), 0)
	L.swap_ritualist_trait(TRAIT_HAG_BOON)

/datum/hag_boon/trait/ritualist/remove_boon_effect(mob/living/L)
	. = ..()
	if(ritualism_raised)
		L.adjust_skillrank(/datum/skill/magic/ritualist, -ritualism_raised, TRUE)
		ritualism_raised = 0
