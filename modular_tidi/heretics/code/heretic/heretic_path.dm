// This might be the biggest file in this module and it's kind of fucked up and evil
// It may not be very intuitive to change things, but know that if you ever change the rewards of a path, you have to update the physical rewards and the summary of the rewards as well
/datum/mind
	var/datum/heretic_path/heretic_path
	var/heretic_converted = FALSE
	var/heretic_awaken_timer

/datum/heretic_path
	var/datum/mind/owner
	var/patron_type
	var/tier = 0
	var/chosen_path
	var/datum/objective/heretic/current_objective
	var/list/history = list()
	var/static/list/branch_names = list(
		/datum/patron/inhumen/zizo = list(HERETIC_PATH_AVANTYNE, HERETIC_PATH_AMBITION),
		/datum/patron/inhumen/graggar = list(HERETIC_PATH_MARAUDER, HERETIC_PATH_ASSASSIN),
		/datum/patron/inhumen/matthios = list(HERETIC_PATH_DRAKE, HERETIC_PATH_THIEF),
	)
	var/static/list/branch_blurbs = list(
		HERETIC_PATH_AVANTYNE = "Champions of the Anatheme, clad in darkened plate formed march wielding reddened blades twinged in the twisted-red color of their own rotten lux. Subtlety is foregone the same way knights of houses garb themselves in garish silks in exchange for raw might.",
		HERETIC_PATH_AMBITION = "Black robes and glittering gems upon arcyne-infused staves. The very picture of a left-handed mage. The walking dead shall pave the way forwards; thundering rhythmic stomps as they march upon the stones beneath them.",
		HERETIC_PATH_MARAUDER = "MOTIVE FORCE! RIP AND TEAR! NONE SHALL STAND IN THE WAY OF UNBRIDLED STRENGTH AND POTENTIAL ENERGY YEARNING TO BE REALIZED. DISPLAY MIGHT THROUGH SHEER, VISCERAL COMBAT. THE GORESTAR WILL SURELY LAUGH THIS NITE!",
		HERETIC_PATH_ASSASSIN = "NOT ALL OF GRAGGAR'S CHILDREN SCREAM. SOME WHISPER IN THE DARK, BIDING THEIR TIME 'TILL THE IDEAL MOMENT TO STRIKE. INITIATES OF GRAGGAR'S KNIVES ARE OFTEN KILLED BEFORE REALIZING THEIR POTENTIAL; A NECESSARY CULLING OF THE WEAK. PROVE YOURSELF WORTHY.",
		HERETIC_PATH_DRAKE = "Clash. Metal against metal. Unity against class. The blue-blooded wretches hide behind plate and chivalry. Bring to bare the flail of Matthios against their steel. They shall crumble.",
		HERETIC_PATH_THIEF = "Not all have the courage to fight against the nobility and win. Some take the methodical, guaranteed route of success. If they never catch you taking, how are they supposed to stop you? Their treasuries will become barren sooner or later.",
	)

/datum/heretic_path/New(datum/mind/new_owner, new_patron_type)
	owner = new_owner
	patron_type = new_patron_type
	var/mob/living/carbon/human/H = owner.current
	if(istype(H) && !H.devotion)
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.able_to_progress = FALSE
		C.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_MINOR)
	give_tier_objective()

/datum/heretic_path/Destroy()
	QDEL_NULL(current_objective)
	owner = null
	return ..()

/datum/heretic_path/proc/give_tier_objective()
	var/list/options = list()
	for(var/datum/objective/heretic/objective_type as anything in subtypesof(/datum/objective/heretic))
		if(initial(objective_type.heretic_tier) != tier)
			continue
		var/objective_patron = initial(objective_type.heretic_patron)
		if(objective_patron && objective_patron != patron_type)
			continue
		var/objective_branch = initial(objective_type.heretic_branch)
		if(objective_branch && objective_branch != chosen_path)
			continue
		options += objective_type
	if(!length(options))
		return
	var/objective_type = pick(options)
	if(objective_type == /datum/objective/heretic/graggar/contract)
		var/marks = 0
		for(var/mob/living/carbon/human/candidate in GLOB.player_list)
			if(candidate != owner.current && candidate.stat != DEAD && candidate.has_flaw(/datum/charflaw/targeted) && !HAS_TRAIT(candidate, TRAIT_CLAIMED_BY_DARKSTAR))
				marks++
		if(marks < 2)
			objective_type = /datum/objective/heretic/graggar/worthy_foe/tier_five
	current_objective = new objective_type(null, owner)
	to_chat(owner.current, "<B>Objective</B>: [current_objective.explanation_text]")

/datum/heretic_path/proc/try_advance(mob/living/carbon/human/user, obj/structure/ritualcircle/circle)
	if(!current_objective?.completed)
		to_chat(user, span_warning("<i>My patron is not yet satisfied.</i>"))
		circle?.fail_invoke()
		return FALSE
	grant_tier_rewards(user, tier, get_turf(circle || user))
	user.adjust_blood_corruption(10)
	if(tier)
		var/datum/patron/patron = patron_type
		adjust_storyteller_influence(initial(patron.name), tier)
	var/list/data = menu_data()
	var/list/entry = data["current"]
	entry["path"] = chosen_path
	history += list(entry)
	QDEL_NULL(current_objective)
	tier++
	circle?.success_invoke()
	to_chat(user, span_cult("<i>My patron is pleased. I have walked further down Their path.</i>"))
	give_tier_objective()
	if(!current_objective)
		to_chat(user, span_notice("<i>My patron has nothing more to ask of me, for now.</i>"))
	return TRUE

/datum/heretic_path/proc/menu_data()
	var/list/data = list(
		"tier" = tier,
		"path" = chosen_path,
		"branches" = branch_names[patron_type] || list(),
		"branch_blurbs" = branch_blurbs,
		"history" = history,
	)
	if(current_objective)
		data["current"] = list(
			"tier" = tier,
			"name" = current_objective.name,
			"text" = current_objective.explanation_text,
			"progress" = current_objective.progress_text(),
			"completed" = current_objective.completed,
			"reward" = tier_rewards(tier),
		)
	return data

/datum/heretic_path/proc/tier_rewards(for_tier)
	switch(patron_type)
		if(/datum/patron/inhumen/zizo)
			return zizo_reward_list(for_tier)
		if(/datum/patron/inhumen/graggar)
			return graggar_reward_list(for_tier)
		if(/datum/patron/inhumen/matthios)
			return matthios_reward_list(for_tier)
		if(/datum/patron/inhumen/baotha)
			return baotha_reward_list(for_tier)

/datum/heretic_path/proc/grant_tier_rewards(mob/living/carbon/human/user, completed_tier, turf/drop_turf)
	switch(patron_type)
		if(/datum/patron/inhumen/zizo)
			zizo_rewards(user, completed_tier, drop_turf)
		if(/datum/patron/inhumen/graggar)
			graggar_rewards(user, completed_tier, drop_turf)
		if(/datum/patron/inhumen/matthios)
			matthios_rewards(user, completed_tier, drop_turf)
		if(/datum/patron/inhumen/baotha)
			baotha_rewards(user, completed_tier, drop_turf)

/datum/heretic_path/proc/zizo_reward_list(for_tier)
	switch(for_tier)
		if(0)
			return list("gifts" = list("+1 INT", "+1 PER", "Ritualism +1", "Expert in knives"))
		if(1)
			return list("gifts" = list("+1 INT", "+1 PER", "Tier zero miracles", "Ritualism +1", "An inverted psycross"))
		if(2)
			return list(
				"gifts" = list("Tier one miracles", "Ritualism +1", "Tempo", "Immunity to the church's curses and apostasy"),
				"paths" = list(
					HERETIC_PATH_AVANTYNE = list("+1 STR", "Medium armor training, unless I have critical resistance or am thick blooded"),
					HERETIC_PATH_AMBITION = list("+1 SPD", "+1 PER", "A minor spell", "Four utility spells", "Arcana +2, up to Expert"),
				),
			)
		if(3)
			if(chosen_path == HERETIC_PATH_AVANTYNE)
				return list("gifts" = list("+1 CON", "+1 WIL", "Tier two miracles", "Expert in a weapon of my choice besides daggers, if I have none", "A dark crystal", "Wrestling +1, up to Expert", "Athletics +1"))
			return list("gifts" = list("+1 INT", "+1 WIL", "Tier two miracles", "A dark crystal", "Wrestling +1, up to Expert", "Athletics +1"))
		if(4)
			if(chosen_path == HERETIC_PATH_AVANTYNE)
				return list("gifts" = list("+1 STR", "Tier three miracles", "Ritualism +1", "Heavy armor training, unless I have critical resistance or am thick blooded"))
			return list("gifts" = list("+1 PER", "+1 WIL", "Tier three miracles", "Ritualism +1"))
		if(5)
			if(chosen_path == HERETIC_PATH_AVANTYNE)
				return list("gifts" = list("+1 CON", "+1 WIL", "Tier four miracles"))
			return list("gifts" = list("+1 SPD", "+1 INT", "Tier four miracles", "A major spell", "A minor spell", "Arcana +2, up to Master"))

/datum/heretic_path/proc/zizo_rewards(mob/living/carbon/human/user, completed_tier, turf/drop_turf)
	switch(completed_tier)
		if(0)
			add_ritualism(user)
			user.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			user.change_stat(STATKEY_INT, 1)
			user.change_stat(STATKEY_PER, 1)
		if(1)
			grant_miracle_tier(user, CLERIC_T0)
			add_ritualism(user)
			new /obj/item/clothing/neck/roguetown/psicross/inhumen/iron(drop_turf)
			user.change_stat(STATKEY_INT, 1)
			user.change_stat(STATKEY_PER, 1)
		if(2)
			grant_miracle_tier(user, CLERIC_T1)
			add_ritualism(user)
			ADD_TRAIT(user, TRAIT_TEMPO, HERETIC_PATH_TRAIT)
			ADD_TRAIT(user, TRAIT_HERESIARCH, HERETIC_PATH_TRAIT)
			choose_path(user)
			if(chosen_path == HERETIC_PATH_AVANTYNE)
				user.change_stat(STATKEY_STR, 1)
				add_training(user, TRAIT_MEDIUMARMOR)
			else
				user.change_stat(STATKEY_SPD, 1)
				user.change_stat(STATKEY_PER, 1)
				grant_spell_points(user, minors = 1, utilities = 4)
				user.adjust_skillrank_up_to(/datum/skill/magic/arcane, min(user.get_skill_level(/datum/skill/magic/arcane) + 2, SKILL_LEVEL_EXPERT), TRUE)
		if(3)
			grant_miracle_tier(user, CLERIC_T2)
			new /obj/item/necro_relics/necro_crystal(drop_turf)
			add_wrestling(user)
			user.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			user.change_stat(STATKEY_WIL, 1)
			if(chosen_path == HERETIC_PATH_AVANTYNE)
				grant_chosen_weapon_skill(user, SKILL_LEVEL_EXPERT)
				user.change_stat(STATKEY_CON, 1)
			else
				user.change_stat(STATKEY_INT, 1)
		if(4)
			grant_miracle_tier(user, CLERIC_T3)
			add_ritualism(user)
			if(chosen_path == HERETIC_PATH_AVANTYNE)
				user.change_stat(STATKEY_STR, 1)
				REMOVE_TRAIT(user, TRAIT_MEDIUMARMOR, HERETIC_PATH_TRAIT)
				add_training(user, TRAIT_HEAVYARMOR)
			else
				user.change_stat(STATKEY_PER, 1)
				user.change_stat(STATKEY_WIL, 1)
		if(5)
			grant_miracle_tier(user, CLERIC_T4)
			if(chosen_path == HERETIC_PATH_AVANTYNE)
				user.change_stat(STATKEY_CON, 1)
				user.change_stat(STATKEY_WIL, 1)
			else
				user.change_stat(STATKEY_SPD, 1)
				user.change_stat(STATKEY_INT, 1)
				grant_spell_points(user, majors = 1, minors = 1)
				user.adjust_skillrank_up_to(/datum/skill/magic/arcane, min(user.get_skill_level(/datum/skill/magic/arcane) + 2, SKILL_LEVEL_MASTER), TRUE)

/datum/heretic_path/proc/graggar_reward_list(for_tier)
	switch(for_tier)
		if(0)
			return list("gifts" = list("+1 STR", "Ritualism +1", "Expert in knives", "Expert in a weapon of my choice besides daggers, if I have none"))
		if(1)
			return list("gifts" = list("Delayed potential...", "Tier zero miracles", "An amulet of Graggar"))
		if(2)
			return list(
				"gifts" = list("Tier one miracles", "Ritualism +1", "Tempo", "Immunity to the church's curses and apostasy"),
				"paths" = list(
					HERETIC_PATH_MARAUDER = list("+1 STR", "Medium armor training, unless I have critical resistance or am thick blooded"),
					HERETIC_PATH_ASSASSIN = list("+1 SPD", "Dodge expert, unless I have critical resistance or am thick blooded", "Light step", "Sneaking +3", "Climbing +2, up to Expert"),
				),
			)
		if(3)
			return list("gifts" = list("+1 CON", "+1 WIL", "Tier two miracles", "Ritualism +1", "Athletics +1", "Wrestling +1, up to Expert", "Something more..."))
		if(4)
			if(chosen_path == HERETIC_PATH_MARAUDER)
				return list("gifts" = list("+1 CON", "+1 WIL", "Tier three miracles", "Ritualism +1", "Heavy armor training, unless I have critical resistance or am thick blooded"))
			return list("gifts" = list("+1 SPD", "Tier three miracles", "Ritualism +1", "Sneaking +1"))
		if(5)
			if(chosen_path == HERETIC_PATH_MARAUDER)
				return list("gifts" = list("+1 STR", "Tier four miracles", "Master in a weapon of my choice besides daggers, if I have none"))
			return list("gifts" = list("+1 SPD", "Tier four miracles", "Master in knives"))

/datum/heretic_path/proc/graggar_rewards(mob/living/carbon/human/user, completed_tier, turf/drop_turf)
	switch(completed_tier)
		if(0)
			add_ritualism(user)
			user.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			user.change_stat(STATKEY_STR, 1)
			grant_chosen_weapon_skill(user, SKILL_LEVEL_EXPERT)
		if(1)
			grant_miracle_tier(user, CLERIC_T0)
			new /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar(drop_turf)
		if(2)
			grant_miracle_tier(user, CLERIC_T1)
			add_ritualism(user)
			ADD_TRAIT(user, TRAIT_TEMPO, HERETIC_PATH_TRAIT)
			ADD_TRAIT(user, TRAIT_HERESIARCH, HERETIC_PATH_TRAIT)
			choose_path(user)
			if(chosen_path == HERETIC_PATH_MARAUDER)
				user.change_stat(STATKEY_STR, 1)
				add_training(user, TRAIT_MEDIUMARMOR)
			else
				user.change_stat(STATKEY_SPD, 1)
				add_training(user, TRAIT_DODGEEXPERT)
				ADD_TRAIT(user, TRAIT_LIGHT_STEP, HERETIC_PATH_TRAIT)
				user.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
				user.adjust_skillrank_up_to(/datum/skill/misc/climbing, min(user.get_skill_level(/datum/skill/misc/climbing) + 2, SKILL_LEVEL_EXPERT), TRUE)
		if(3)
			grant_miracle_tier(user, CLERIC_T2)
			add_ritualism(user)
			user.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			add_wrestling(user)
			user.change_stat(STATKEY_CON, 1)
			user.change_stat(STATKEY_WIL, 1)
			user.swap_in_engorged_heart()
			user.set_blood_corruption(100)
		if(4)
			grant_miracle_tier(user, CLERIC_T3)
			add_ritualism(user)
			if(chosen_path == HERETIC_PATH_MARAUDER)
				user.change_stat(STATKEY_CON, 1)
				user.change_stat(STATKEY_WIL, 1)
				REMOVE_TRAIT(user, TRAIT_MEDIUMARMOR, HERETIC_PATH_TRAIT)
				add_training(user, TRAIT_HEAVYARMOR)
			else
				user.change_stat(STATKEY_SPD, 1)
				user.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)
		if(5)
			grant_miracle_tier(user, CLERIC_T4)
			if(chosen_path == HERETIC_PATH_MARAUDER)
				user.change_stat(STATKEY_STR, 1)
				grant_chosen_weapon_skill(user, SKILL_LEVEL_MASTER)
			else
				user.change_stat(STATKEY_SPD, 1)
				user.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_MASTER, TRUE)

/datum/heretic_path/proc/matthios_reward_list(for_tier)
	switch(for_tier)
		if(0)
			return list("gifts" = list("+1 CON", "+1 WIL", "Ritualism +1", "Expert in knives", "The eye to see what things are truly worth"))
		if(1)
			return list("gifts" = list("+1 SPD", "Tier zero miracles", "An amulet of Matthios", "Sneaking +2", "Lockpicking +2", "Pickpocketing +2"))
		if(2)
			return list(
				"gifts" = list("Tier one miracles", "Ritualism +1", "Tempo", "Immunity to the church's curses and apostasy"),
				"paths" = list(
					HERETIC_PATH_DRAKE = list("+1 STR", "Expert in a weapon of my choice besides daggers, if I have none", "Medium armor training, unless I have critical resistance or am thick blooded"),
					HERETIC_PATH_THIEF = list("+1 SPD", "+1 PER", "Dodge expert, unless I have critical resistance or am thick blooded", "Light step", "Sneaking +1", "Lockpicking +1", "Pickpocketing +1", "Climbing +2, up to Expert"),
				),
			)
		if(3)
			if(chosen_path == HERETIC_PATH_DRAKE)
				return list("gifts" = list("+1 CON", "+1 WIL", "Tier two miracles", "Ritualism +1", "Wrestling +1, up to Expert", "Athletics +1"))
			return list("gifts" = list("+1 PER", "+1 WIL", "Tier two miracles", "Ritualism +1", "Wrestling +1, up to Expert", "Athletics +1"))
		if(4)
			if(chosen_path == HERETIC_PATH_DRAKE)
				return list("gifts" = list("+1 STR", "Tier three miracles", "Ritualism +1", "Heavy armor training, unless I have critical resistance or am thick blooded"))
			return list("gifts" = list("+1 INT", "+1 WIL", "Tier three miracles", "Ritualism +1"))
		if(5)
			if(chosen_path == HERETIC_PATH_DRAKE)
				return list("gifts" = list("+1 CON", "+1 WIL", "Tier four miracles", "Master in a weapon of my choice besides daggers, if I have none"))
			return list("gifts" = list("+1 SPD", "+1 PER", "Tier four miracles", "Master in knives"))

/datum/heretic_path/proc/matthios_rewards(mob/living/carbon/human/user, completed_tier, turf/drop_turf)
	switch(completed_tier)
		if(0)
			add_ritualism(user)
			user.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			ADD_TRAIT(user, TRAIT_SEEPRICES, HERETIC_PATH_TRAIT)
			user.change_stat(STATKEY_CON, 1)
			user.change_stat(STATKEY_WIL, 1)
		if(1)
			grant_miracle_tier(user, CLERIC_T0)
			new /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios(drop_turf)
			user.change_stat(STATKEY_SPD, 1)
			user.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
			user.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
			user.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
		if(2)
			grant_miracle_tier(user, CLERIC_T1)
			add_ritualism(user)
			ADD_TRAIT(user, TRAIT_TEMPO, HERETIC_PATH_TRAIT)
			ADD_TRAIT(user, TRAIT_HERESIARCH, HERETIC_PATH_TRAIT)
			choose_path(user)
			if(chosen_path == HERETIC_PATH_DRAKE)
				grant_chosen_weapon_skill(user, SKILL_LEVEL_EXPERT)
				add_training(user, TRAIT_MEDIUMARMOR)
				user.change_stat(STATKEY_STR, 1)
			else
				user.change_stat(STATKEY_SPD, 1)
				user.change_stat(STATKEY_PER, 1)
				add_training(user, TRAIT_DODGEEXPERT)
				ADD_TRAIT(user, TRAIT_LIGHT_STEP, HERETIC_PATH_TRAIT)
				user.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)
				user.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
				user.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
				user.adjust_skillrank_up_to(/datum/skill/misc/climbing, min(user.get_skill_level(/datum/skill/misc/climbing) + 2, SKILL_LEVEL_EXPERT), TRUE)
		if(3)
			grant_miracle_tier(user, CLERIC_T2)
			add_ritualism(user)
			add_wrestling(user)
			user.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			user.change_stat(STATKEY_WIL, 1)
			if(chosen_path == HERETIC_PATH_DRAKE)
				user.change_stat(STATKEY_CON, 1)
			else
				user.change_stat(STATKEY_PER, 1)
		if(4)
			grant_miracle_tier(user, CLERIC_T3)
			add_ritualism(user)
			if(chosen_path == HERETIC_PATH_DRAKE)
				user.change_stat(STATKEY_STR, 1)
				REMOVE_TRAIT(user, TRAIT_MEDIUMARMOR, HERETIC_PATH_TRAIT)
				add_training(user, TRAIT_HEAVYARMOR)
			else
				user.change_stat(STATKEY_INT, 1)
				user.change_stat(STATKEY_WIL, 1)
		if(5)
			grant_miracle_tier(user, CLERIC_T4)
			if(chosen_path == HERETIC_PATH_DRAKE)
				grant_chosen_weapon_skill(user, SKILL_LEVEL_MASTER)
				user.change_stat(STATKEY_CON, 1)
				user.change_stat(STATKEY_WIL, 1)
			else
				user.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_MASTER, TRUE)
				user.change_stat(STATKEY_SPD, 1)
				user.change_stat(STATKEY_PER, 1)

/datum/heretic_path/proc/baotha_reward_list(for_tier)
	switch(for_tier)
		if(0)
			return list("gifts" = list("+1 WIL", "+1 PER", "Tier zero miracles", "Ritualism +1", "Expert in knives", "A bottle of emberwine", "An amulet of Baotha"))
		if(1)
			return list("gifts" = list("+1 SPD", "Tier one miracles"))
		if(2)
			return list("gifts" = list("+1 SPD", "+1 PER", "Tier two miracles", "Ritualism +1", "Dodge expert, unless I have critical resistance or am thick blooded", "Tempo", "Immunity to the church's curses and apostasy"))
		if(3)
			return list("gifts" = list("+2 CON", "Tier three miracles", "Ritualism +1", "Wrestling +1, up to Expert", "Athletics +1"))
		if(4)
			return list("gifts" = list("+1 SPD", "Tier four miracles", "Ritualism +1"))
		if(5)
			return list("gifts" = list("+1 STR", "+1 WIL"))

/datum/heretic_path/proc/baotha_rewards(mob/living/carbon/human/user, completed_tier, turf/drop_turf)
	switch(completed_tier)
		if(0)
			add_ritualism(user)
			user.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			grant_miracle_tier(user, CLERIC_T0)
			new /obj/item/reagent_containers/glass/bottle/alchemical/emberwine(drop_turf)
			new /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha(drop_turf)
			user.change_stat(STATKEY_WIL, 1)
			user.change_stat(STATKEY_PER, 1)
		if(1)
			grant_miracle_tier(user, CLERIC_T1)
			user.change_stat(STATKEY_SPD, 1)
		if(2)
			grant_miracle_tier(user, CLERIC_T2)
			add_ritualism(user)
			user.change_stat(STATKEY_SPD, 1)
			user.change_stat(STATKEY_PER, 1)
			add_training(user, TRAIT_DODGEEXPERT)
			ADD_TRAIT(user, TRAIT_TEMPO, HERETIC_PATH_TRAIT)
			ADD_TRAIT(user, TRAIT_HERESIARCH, HERETIC_PATH_TRAIT)
		if(3)
			grant_miracle_tier(user, CLERIC_T3)
			add_ritualism(user)
			add_wrestling(user)
			user.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			user.change_stat(STATKEY_CON, 2)
		if(4)
			grant_miracle_tier(user, CLERIC_T4)
			add_ritualism(user)
			user.change_stat(STATKEY_SPD, 1)
		if(5)
			user.change_stat(STATKEY_STR, 1)
			user.change_stat(STATKEY_WIL, 1)

/datum/heretic_path/proc/add_training(mob/living/carbon/human/user, trait)
	if(!HAS_TRAIT(user, TRAIT_CRITICAL_RESISTANCE) && !HAS_TRAIT(user, TRAIT_BLOOD_RESISTANCE))
		ADD_TRAIT(user, trait, HERETIC_PATH_TRAIT)

/datum/heretic_path/proc/add_wrestling(mob/living/carbon/human/user)
	if(user.get_skill_level(/datum/skill/combat/wrestling) < SKILL_LEVEL_EXPERT)
		user.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)

/datum/heretic_path/proc/add_ritualism(mob/living/carbon/human/user)
	if(user.get_skill_level(/datum/skill/magic/ritualist) < SKILL_LEVEL_EXPERT)
		user.adjust_skillrank(/datum/skill/magic/ritualist, 1, TRUE)

/datum/heretic_path/proc/grant_miracle_tier(mob/living/carbon/human/user, cleric_tier)
	var/static/list/tier_limits = list(CLERIC_REQ_1, CLERIC_REQ_1, CLERIC_REQ_2, CLERIC_REQ_3, CLERIC_REQ_4)
	var/datum/devotion/C = user.devotion
	if(!C)
		C = new /datum/devotion(user, user.patron)
	C.able_to_progress = TRUE
	C.grant_miracles(user, cleric_tier = cleric_tier, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = tier_limits[cleric_tier + 1])
	C.able_to_progress = FALSE

/datum/heretic_path/proc/grant_spell_points(mob/living/carbon/human/user, majors = 0, minors = 0, utilities = 0)
	if(!user.mind)
		return
	if(!LAZYLEN(user.mind.mage_aspect_config))
		user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 0))
	user.mind.mage_aspect_config["major"] += majors
	user.mind.mage_aspect_config["minor"] += minors
	user.mind.mage_aspect_config["utilities"] += utilities
	user.mind.check_learnspell()

/datum/heretic_path/proc/choose_path(mob/living/carbon/human/user)
	for(var/branch in branch_names[patron_type])
		to_chat(user, span_cult("<b>[branch]</b>: <i>[branch_blurbs[branch]]</i>"))
	chosen_path = input(user, "My patron offers me a choice of paths.", "CHOOSE YOUR PATH") as anything in branch_names[patron_type]

/datum/heretic_path/proc/grant_chosen_weapon_skill(mob/living/carbon/human/user, level)
	var/weapons = list(
		"Swords" = /datum/skill/combat/swords,
		"Polearms" = /datum/skill/combat/polearms,
		"Maces" = /datum/skill/combat/maces,
		"Axes" = /datum/skill/combat/axes,
		"Whips & Flails" = /datum/skill/combat/whipsflails,
		"Wrestling" = /datum/skill/combat/wrestling,
		"Unarmed" = /datum/skill/combat/unarmed,
		"Shields" = /datum/skill/combat/shields,
		"Staves" = /datum/skill/combat/staves,
	)
	for(var/weapon in weapons)
		if(user.get_skill_level(weapons[weapon]) >= level)
			return
	var/weapon_choice = input(user, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	user.adjust_skillrank_up_to(weapons[weapon_choice], level, TRUE)
