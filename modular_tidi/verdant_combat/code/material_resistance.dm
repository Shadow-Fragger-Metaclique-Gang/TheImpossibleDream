#define ARMOR_MATERIAL_POOR 0
#define ARMOR_MATERIAL_MIXED 25
#define ARMOR_MATERIAL_GOOD 50
#define ACID_DURABILITY_MULT 2

GLOBAL_LIST_INIT(armor_material_resistance, list(
	"steel" = list("electrical" = ARMOR_MATERIAL_POOR, "fire" = ARMOR_MATERIAL_GOOD, "frost" = ARMOR_MATERIAL_MIXED, "acid" = ARMOR_MATERIAL_MIXED),
	"bronze" = list("electrical" = ARMOR_MATERIAL_POOR, "fire" = ARMOR_MATERIAL_MIXED, "frost" = ARMOR_MATERIAL_GOOD, "acid" = ARMOR_MATERIAL_MIXED),
	"padded" = list("electrical" = ARMOR_MATERIAL_MIXED, "fire" = ARMOR_MATERIAL_POOR, "frost" = ARMOR_MATERIAL_MIXED, "acid" = ARMOR_MATERIAL_POOR),
	"fur" = list("electrical" = ARMOR_MATERIAL_MIXED, "fire" = ARMOR_MATERIAL_POOR, "frost" = ARMOR_MATERIAL_GOOD, "acid" = ARMOR_MATERIAL_POOR),
	"leather" = list("electrical" = ARMOR_MATERIAL_MIXED, "fire" = ARMOR_MATERIAL_MIXED, "frost" = ARMOR_MATERIAL_MIXED, "acid" = ARMOR_MATERIAL_POOR),
	"precious" = list("electrical" = ARMOR_MATERIAL_POOR, "fire" = ARMOR_MATERIAL_MIXED, "frost" = ARMOR_MATERIAL_MIXED, "acid" = ARMOR_MATERIAL_GOOD),
))

/obj/item/clothing
	var/armor_material

/obj/item/clothing/gloves/roguetown/angle
	armor_material = "leather"

/obj/item/clothing/gloves/roguetown/angle/gronn
	armor_material = "fur"

/obj/item/clothing/gloves/roguetown/angle/gronnfur
	armor_material = "fur"

/obj/item/clothing/gloves/roguetown/angle/atgervi
	armor_material = "fur"

/obj/item/clothing/Initialize(mapload)
	. = ..()
	apply_material_resistance()

/obj/item/clothing/proc/guess_armor_material()
	var/sewn = sewrepair && !anvilrepair
	var/metal = ispath(anvilrepair, /datum/skill/craft/armorsmithing) || ispath(anvilrepair, /datum/skill/craft/blacksmithing) || ispath(anvilrepair, /datum/skill/craft/weaponsmithing)
	// Sewn armors are considered to be primarily made of cloth or leather for the purposes of this mechanic.
	if(!sewn && (metal || ispath(smeltresult, /obj/item/ingot)))
		if(ispath(smeltresult, /obj/item/ingot/bronze) || ispath(smeltresult, /obj/item/ingot/copper))
			return "bronze"
		if(ispath(smeltresult, /obj/item/ingot/gold))
			return "precious"
		return "steel"
	if(anvilrepair)
		return null
	if(ispath(salvage_result, /obj/item/natural/fur))
		return "fur"
	if(ispath(salvage_result, /obj/item/natural/hide))
		return "leather"
	if(ispath(salvage_result, /obj/item/natural/cloth) || ispath(salvage_result, /obj/item/natural/silk) || ispath(salvage_result, /obj/item/natural/fibers))
		return "padded"
	return null

/obj/item/clothing/proc/apply_material_resistance()
	if(!armor)
		return
	if(!armor.blunt && !armor.slash && !armor.stab && !armor.piercing)
		return
	var/list/resistances = GLOB.armor_material_resistance[armor_material || guess_armor_material()]
	if(!resistances)
		return
	armor = armor.setRating(
		fire = max(armor.fire, resistances["fire"]),
		acid = max(armor.acid, resistances["acid"]),
		frost = max(armor.frost, resistances["frost"]),
		electrical = max(armor.electrical, resistances["electrical"]),
	)

/obj/item/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir, armor_penetration = 0, object_damage_multiplier = 1)
	. = ..()
	if(damage_flag == "acid")
		. *= ACID_DURABILITY_MULT
