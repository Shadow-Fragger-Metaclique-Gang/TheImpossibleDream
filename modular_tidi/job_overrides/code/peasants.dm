/datum/advclass/thug/goon
	maximum_possible_slots = 4
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_INT = -1,
		STATKEY_PER = -1
	)

// Only "Whatever I Can Find" leaves all three of these at Apprentice, so it identifies that choice
/datum/advclass/thug/goon/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.get_skill_level(/datum/skill/combat/swords) == SKILL_LEVEL_APPRENTICE \
		&& H.get_skill_level(/datum/skill/combat/polearms) == SKILL_LEVEL_APPRENTICE \
		&& H.get_skill_level(/datum/skill/combat/whipsflails) == SKILL_LEVEL_APPRENTICE)
		H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)

/datum/advclass/thug/wiseguy
	maximum_possible_slots = 4
	subclass_stats = list(
		STATKEY_WIL = 1,
		STATKEY_CON = -1,
		STATKEY_STR = -1,
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 2
	)

/datum/advclass/thug/wiseguy/post_equip(mob/living/carbon/human/H)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
	if(H.get_skill_level(/datum/skill/combat/slings) == SKILL_LEVEL_JOURNEYMAN)
		H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_EXPERT, TRUE)

/datum/advclass/thug/bigman
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 5,
		STATKEY_SPD = -2,
		STATKEY_INT = -5,
		STATKEY_PER = 2,
	)

/datum/job/roguetown/shophand
	total_positions = 2
	spawn_positions = 2
	job_traits = list() // Appraisal is granted per class instead
	advclass_cat_rolls = list(CTAG_SHOPHAND = 10)
	job_subclasses = list(
		/datum/advclass/thug/goon/docker,
		/datum/advclass/thug/wiseguy/docker,
		/datum/advclass/thug/bigman/docker,
	)

// Docker copies of the thug and thief classes. They are separate types so they keep their own slot counts.
/datum/advclass/thug/goon/docker
	category_tags = list(CTAG_SHOPHAND)
	maximum_possible_slots = 2

/datum/advclass/thug/goon/docker/post_equip(mob/living/carbon/human/H)
	. = ..()
	give_merchant_keyring(H)

/datum/advclass/thug/wiseguy/docker
	category_tags = list(CTAG_SHOPHAND)
	maximum_possible_slots = 2
	traits_applied = list(TRAIT_SEEPRICES, TRAIT_CICERONE, TRAIT_NUTCRACKER, TRAIT_ALCHEMY_EXPERT)

/datum/advclass/thug/wiseguy/docker/post_equip(mob/living/carbon/human/H)
	. = ..()
	give_merchant_keyring(H)

/datum/advclass/thug/bigman/docker
	category_tags = list(CTAG_SHOPHAND)
	maximum_possible_slots = 1

/datum/advclass/thug/bigman/docker/post_equip(mob/living/carbon/human/H)
	. = ..()
	give_merchant_keyring(H)

// The original Docker class is no longer selectable
/datum/advclass/shophand
	category_tags = list()
