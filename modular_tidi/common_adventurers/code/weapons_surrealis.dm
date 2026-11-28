/* * * * * **
 *			*
 *	Weapons	*
 *			*
 * * * * * **/

// =================================================================================
// -------------- bronze ----------------- Surrealis edit Sprites by Dromkii

/obj/item/rogueweapon/stoneaxe/handaxe/bronze
	name = "bronze hatchet"
	desc = "A small bronze hatchet, useful for chopping wood or cutting through flesh."
	icon_state = "b_hatchet"
	icon = 'modular_tidi/common_adventurers/icons/weapons_32x32.dmi'
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/mace/goden/bronze
	force = 15
	force_wielded = 30
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/bash/ranged) //Fluffed as either buttstroking with the Grand Mace, or ineffectually swinging it.
	gripped_intents = list(/datum/intent/mace/strike/grand, /datum/intent/mace/smash/grand, /datum/intent/mace/rangedthrust/short, /datum/intent/effect/daze)
	name = "bronze warclub"
	desc = "An ancient weapon of bronze, forged for the purpose of crushing skulls. The Grand Mace is a weapon of the past, and is now only used by those who wish to emulate the Ancient war."
	icon_state = "bronze_warclub"
	icon = 'modular_tidi/common_adventurers/icons/weapons_64x64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	associated_skill = /datum/skill/combat/maces
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/mace/goden/bronze/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
