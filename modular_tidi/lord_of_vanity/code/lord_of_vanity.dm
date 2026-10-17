// LORD_OF_VANITY
/datum/job/roguetown/lord
	// Each subclass equips its inherited lord outfit after choosing its own clothing.
	outfit = null

/datum/job/roguetown/lord/New()
	. = ..()
	job_subclasses |= /datum/advclass/lord/newclothes

/datum/advclass/lord/newclothes
	name = "Lord of Vanity"
	tutorial = "Among your many patrician indulgences, none rivals your love of fine clothes. How fortunate, then, that two passing seamsters offered you the finest garments ever woven: invisible only to fools and dullards. You can see them, of course… can't you, Your Grace?"
	outfit = /datum/outfit/job/roguetown/lord/newclothes
	pickprob = 15//the seamsters dont visit the good duke every week
	category_tags = list(CTAG_LORD)
	traits_applied = list(
		TRAIT_NOBLE,
		TRAIT_BLOOD_RESISTANCE,
		TRAIT_DNR,
		TRAIT_NUDIST,//you wouldn't dare take off your new clothes, right?
		TRAIT_BEAUTIFUL,
		TRAIT_SEEPRICES_SHITTY,//you know your luxery... if poorer than the merchant lord
		TRAIT_CICERONE,//wine snob
		TRAIT_RAGE//you get mad if someone dares say the duke is unclothed
	)
	subclass_stats = list(
		STATKEY_LCK = 4,
		STATKEY_INT = -5,//you are infact, a dullard
		STATKEY_PER = -2,//can't even see your own nudity
		STATKEY_CON = 5,
		STATKEY_WIL = 5,
		STATKEY_STR = 3,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/lord/newclothes/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/rage)
	// Preserve the inherited cloak, mask, crown, and footwear style.
	if(shoes == /obj/item/clothing/shoes/roguetown/boots)
		shoes = /obj/item/clothing/shoes/roguetown/boots/ducal
	else if(shoes == /obj/item/clothing/shoes/roguetown/shortboots)
		shoes = /obj/item/clothing/shoes/roguetown/shortboots/ducal
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/gold/ducal

	armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/chest/duke
	shirt = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/duke
	pants = /obj/item/clothing/suit/roguetown/armor/manual/meditation/legs/duke
	wrists = null
	gloves = null

	l_hand = /obj/item/rogueweapon/lordscepter
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
	)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)//please stop praying for grandpa, he's gotten too powerful
		H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)//hilarious
