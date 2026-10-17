/datum/supply_pack/rogue/underdark/spiderurumi
	name = "Drow Urumi"
	cost = 95
	contains = list(/obj/item/rogueweapon/whip/urumi/spider)

/datum/supply_pack/rogue/underdark/stalker_falx
	name = "Stalker Falx"
	cost = 95
	contains = list(/obj/item/rogueweapon/sword/falx/stalker)

/datum/supply_pack/rogue/underdark/spider_greatsabre
	name = "Greatsabre"
	cost = 190
	contains = list(/obj/item/rogueweapon/sword/long/elf/stalker)

/datum/supply_pack/rogue/underdark/spider_longsword
	name = "Thrusting Longsword"
	cost = 190
	contains = list(/obj/item/rogueweapon/sword/long/stalker)

/datum/supply_pack/rogue/underdark/spider_messer
	name = "Drow Kriegmesser"
	cost = 190
	contains = list(/obj/item/rogueweapon/sword/long/kriegmesser/stalker)

/datum/supply_pack/rogue/underdark/spider_shotel
	name = "Drow Shotel"
	cost = 95
	contains = list(/obj/item/rogueweapon/sword/long/shotel/stalker)

/datum/supply_pack/rogue/underdark/spider_hooksword
	name = "Drow Hooksword"
	cost = 95
	contains = list(/obj/item/rogueweapon/sword/sabre/hook/stalker)

/datum/supply_pack/rogue/underdark/spider_aruval
	name = "Drow Aruval"
	cost = 190
	contains = list(/obj/item/rogueweapon/sword/long/rhomphaia/stalker)

/datum/supply_pack/rogue/underdark/spider_bardiche
	name = "Drow Bardiche"
	cost = 190
	contains = list(/obj/item/rogueweapon/halberd/bardiche/stalker)

/datum/supply_pack/rogue/underdark/spider_spikedflail
	name = "Drow Spined-Greatflail"
	cost = 190
	contains = list(/obj/item/rogueweapon/flail/peasantwarflail/stalker)

/datum/supply_pack/rogue/underdark/spider_greatflail
	name = "Drow Hefty Greatflail"
	cost = 190
	contains = list(/obj/item/rogueweapon/flail/peasantwarflail/stalker/alt)

/datum/supply_pack/rogue/underdark/scourge_helm
	name = "Crocs Cavallier's Helm"
	cost = 130
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight/shadowplate)

/datum/supply_pack/rogue/underdark/smiling_helm
	name = "Smiling Helm"
	cost = 90
	contains = list(/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/shadowplate)

/datum/supply_pack/rogue/underdark/drowcraft_vest
	name = "Drowcraft Vest"
	cost = 130
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/shadowvest)

/datum/supply_pack/rogue/underdark/crossbow
	name = "Stalker Slurbow"
	cost = 190
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/stalker)

/datum/supply_pack/rogue/underdark/slurbow
	name = "Underdark Slurbow"
	cost = 150
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/stalker/lesser)

/datum/supply_pack/rogue/underdark/light_bolts
	name = "Quiver of Light Bolts"
	cost = 40
	contains = list(/obj/item/quiver/bolt/light)

/datum/merchant_catalog/underdark
	name = "Crocs de l'araignée Armory"

/datum/merchant_catalog/underdark/New()
	. = ..()
	stock += list(
		/datum/supply_pack/rogue/underdark/spiderurumi = 2,
		/datum/supply_pack/rogue/underdark/spider_greatsabre = 2,
		/datum/supply_pack/rogue/underdark/spider_longsword = 2,
		/datum/supply_pack/rogue/underdark/spider_messer = 2,
		/datum/supply_pack/rogue/underdark/spider_shotel = 2,
		/datum/supply_pack/rogue/underdark/spider_hooksword = 2,
		/datum/supply_pack/rogue/underdark/spider_aruval = 2,
		/datum/supply_pack/rogue/underdark/spider_bardiche = 2,
		/datum/supply_pack/rogue/underdark/spider_spikedflail = 2,
		/datum/supply_pack/rogue/underdark/spider_greatflail = 2,
		/datum/supply_pack/rogue/underdark/scourge_helm = 2,
		/datum/supply_pack/rogue/underdark/smiling_helm = 2,
		/datum/supply_pack/rogue/underdark/slurbow = 2,
		/datum/supply_pack/rogue/underdark/light_bolts = 5,
	)
