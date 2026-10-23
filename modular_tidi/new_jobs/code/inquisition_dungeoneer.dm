// Placeholder name: "Dungeoneer".
/datum/job/roguetown/dungeoneer
	title = "Penitent One"
	flag = DUNGEONEER
	department_flag = INQUISITION
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	forbidden_races = list(RACES_DESPISED)
	allowed_patrons = list(/datum/patron/old_god)
	tutorial = "Unlike your brothers and sisters in faith, you are a professional. Neither an unwashed parolee nor a fanatic driven into frenzy, you were trained in secret prisons of Otava in combat, interrogation and investigation, an inquisitor-to-be. But you faltered. An unspeakable sin stains your past, yet they still have a use for you. You have been relegated to a shameful duty of torturing and maiming creations of PSYDON, a kind of a sin-eater. Your colleagues will meet God; you, however, will simply die."
	selection_color = JCOLOR_INQUISITION
	outfit = null
	display_order = JDO_DUNGEONEER
	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	wanderer_examine = FALSE
	advjob_examine = FALSE
	give_bank_account = 40
	vice_restrictions = list(/datum/charflaw/silverweakness)
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_INQUISITION, TRAIT_SQUIRE_REPAIR, TRAIT_INTELLECTUAL, TRAIT_BLACKBAGGER, TRAIT_PSYDONITE, TRAIT_DECEIVING_MEEKNESS)
	advclass_cat_rolls = list(CTAG_DUNGEONEER = 2)
	job_subclasses = list(/datum/advclass/dungeoneer)
	has_subprefs = FALSE // only one subclass

/datum/advclass/dungeoneer
	name = "Penitent One"
	tutorial = "Unlike your brothers and sisters in faith, you are a professional. Neither an unwashed parolee nor a fanatic driven into frenzy, you were trained in secret prisons of Otava in combat, interrogation and investigation, an inquisitor-to-be. But you faltered. An unspeakable sin stains your past, yet they still have a use for you. You have been relegated to a shameful duty of torturing and maiming creations of PSYDON, a kind of a sin-eater. Your colleagues will meet God; you, however, will simply die."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/dungeoneer
	category_tags = list(CTAG_DUNGEONEER)
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/templarofpsydonia.ogg'
	// Weighs 7 the speed penalty discourages hunting.
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_PER = 3,
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = -4
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"The Book" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/dungeoneer
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/dungeoneer/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head 	= 	/obj/item/clothing/head/roguetown/helmet/otavan
	backl 	= 	/obj/item/storage/backpack/rogue/satchel/otavan
	neck 	= 	/obj/item/clothing/neck/roguetown/gorget
	armor 	= 	/obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli
	wrists 	= 	/obj/item/clothing/neck/roguetown/psicross/silver
	id 		= 	/obj/item/clothing/ring/signet/psy
	shirt 	= 	/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/inq
	gloves 	= 	/obj/item/clothing/gloves/roguetown/otavan/psygloves
	belt 	= 	/obj/item/storage/belt/rogue/leather/knifebelt/black/psydon_blessed
	beltl 	= 	/obj/item/storage/belt/rogue/surgery_bag/full
	beltr 	= 	/obj/item/rogueweapon/scabbard/sword/noble
	pants 	= 	/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes 	= 	/obj/item/clothing/shoes/roguetown/boots/otavan
	backpack_contents = list(
		/obj/item/roguekey/inquisitionmanor = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/clothing/mask/rogue/sack/psy = 1,
		/obj/item/rope/inqarticles/inquirycord = 2,
	)
	H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/psy/preblessed)

	add_verb(H, /mob/living/carbon/human/proc/faith_test)
	add_verb(H, /mob/living/carbon/human/proc/torture_victim)
	change_origin(H, /datum/virtue/origin/otava, "Holy order")
