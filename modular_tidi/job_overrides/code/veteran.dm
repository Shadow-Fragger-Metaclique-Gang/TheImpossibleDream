/datum/outfit/job/roguetown/vet/merc/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/steel
	beltl = /obj/item/rogueweapon/sword/short
	beltr = /obj/item/roguekey/veteran //So they can get into their house.
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/half/vet
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	add_verb(H, /mob/proc/haltyell)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Retirement.")
		var/origins = list("Grenzelhoft", "Etrusca", "Kazengun", "Raneshen", "Pharos")
		var/originchoice = input(H, "Choose your origin.", "WHERE DO YOU HAIL FROM?") as anything in origins
		var/weapons = list("Iron Longsword","Spear")
		H.set_blindness(0)
		switch(originchoice)
			if("Grenzelhoft")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
				head = /obj/item/clothing/head/roguetown/helmet/sallet/grenzelhoft
				neck = /obj/item/clothing/neck/roguetown/gorget
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
				shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
				gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
				weapons += "Zweihander"
				weapons += "Halberd"
			if("Etrusca")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
				head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/iron
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
				gloves = /obj/item/clothing/gloves/roguetown/plate/iron
				weapons += "Cup-hilt Rapier"
				weapons += "Etruscan Longsword"
			if("Kazengun")
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				head = /obj/item/clothing/head/roguetown/helmet/kettle/jingasa
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/haraate
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun
				gloves = /obj/item/clothing/gloves/roguetown/plate/kote
				weapons += "Hwando"
				weapons += "Ssangsudo"
				weapons += "Naginata"
			if("Raneshen")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
				head = /obj/item/clothing/head/roguetown/helmet/sallet/raneshen
				neck = /obj/item/clothing/neck/roguetown/chaincoif/full
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
				pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				gloves = /obj/item/clothing/gloves/roguetown/chain
				weapons += "Shalal Sabre"
				weapons += "Shamshir"
			if("Pharos") //Generic or elsewhere, essentially.
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
				head = /obj/item/clothing/head/roguetown/helmet/nasal
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass
				pants = /obj/item/clothing/under/roguetown/brigandinelegs
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
				gloves = /obj/item/clothing/gloves/roguetown/chain
				weapons += "Raw Heap of Iron"
				weapons += "Decorated Gladius"
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Iron Longsword")
				H.put_in_hands(new /obj/item/rogueweapon/sword/long/iron)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)
			if("Spear")
				H.put_in_hands(new /obj/item/rogueweapon/spear)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 6, TRUE)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L)
			if("Zweihander")
				H.put_in_hands(new /obj/item/rogueweapon/greatsword/grenz)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L)
			if("Halberd")
				H.put_in_hands(new /obj/item/rogueweapon/halberd)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 6, TRUE)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L)
			if("Cup-hilt Rapier")
				H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/vaquero)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)
			if("Etruscan Longsword")
				H.put_in_hands(new /obj/item/rogueweapon/sword/long/etruscan)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)
			if("Hwando")
				H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/mulyeog)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)
			if("Ssangsudo")
				H.put_in_hands(new /obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)
			if("Naginata")
				H.put_in_hands(new /obj/item/rogueweapon/spear/naginata)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 6, TRUE)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L)
			if("Shalal Sabre")
				H.put_in_hands(new /obj/item/rogueweapon/sword/long/marlin)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)
			if("Shamshir")
				H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/shamshir)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)
			if("Raw Heap of Iron") //Why not. 13 strength is reachable with a +2 strength statpack or a race bonus. Besides, it'd be really funny if they kept dropping it.
				H.put_in_hands(new /obj/item/rogueweapon/sword/long/exe/berserk)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)
			if("Decorated Gladius") //Lucius Artorius Castus
				H.put_in_hands(new /obj/item/rogueweapon/sword/short/gladius/decorated)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)

/datum/outfit/job/roguetown/vet/merc/choose_loadout(mob/living/carbon/human/H)
	H.adjust_blindness(-3)
	if(H.mind)
		var/retirement = list("Pursue Homesteading", "Dabble in Artisan Smithing", "Write an autobiography", "Keep up with your old regimen")
		var/retirement_choice = input(H, "During your retirement, you decided to...", "PICK A HOBBY.") as anything in retirement
		switch(retirement_choice)
			if("Pursue Homesteading")
				ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Dabble in Artisan Smithing")
				ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/ceramics, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Write an autobiography")
				ADD_TRAIT(H, TRAIT_GOODWRITER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
			if("Keep up with your old regimen") //You don't get the +2 to willpower because of the existing statblock.
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
		var/discharged = list("ONE-EYED", "BRITTLE-BONAGE", "HAUNTED", "STIFF-JOINTED")
		var/discharged_choice = input(H, "What forced you into retirement?", "PICK A DEBILITATION.") as anything in discharged
		switch(discharged_choice)
			if("ONE-EYED")
				ADD_TRAIT(H, TRAIT_CYCLOPS_RIGHT, TRAIT_GENERIC)
				H.change_stat(STATKEY_PER, -1)
			if("BRITTLE-BONAGE")
				ADD_TRAIT(H, TRAIT_BRITTLE, TRAIT_GENERIC)
				H.change_stat(STATKEY_CON, -1)
			if("HAUNTED")
				ADD_TRAIT(H, TRAIT_PSYCHOSIS, TRAIT_GENERIC)
				H.change_stat(STATKEY_INT, -1)
			if("STIFF-JOINTED")
				ADD_TRAIT(H, TRAIT_NORUN, TRAIT_GENERIC)
				H.change_stat(STATKEY_SPD, -1)
