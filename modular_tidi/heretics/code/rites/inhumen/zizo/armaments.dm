/datum/runeritual/god/zizo/armaments
	name = "Rite of Armaments"
	desc = "Clads the member of the Cabal standing upon the rune in avantyne armor and arms them with an avantyne weapon of my choosing. Only those Expert in Ritualism may summon full plate."
	layout = list(
		"NW" = /obj/item/natural/bone,
		"NE" = /obj/item/natural/bone,
		"W" = /obj/item/ingot/steel,
		"C" = /mob/living/carbon/human,
		"E" = /obj/item/ingot/steel,
		"S" = /obj/item/skull,
	)
	tier = SKILL_LEVEL_JOURNEYMAN
	cooldown = 30 MINUTES

/datum/runeritual/god/zizo/armaments/perform(mob/living/user, obj/structure/ritualcircle/zizo/circle)
	if(!check_layout(user, circle))
		return FALSE
	var/list/hosting = match_layout(circle)
	var/mob/living/carbon/human/target = hosting["C"]
	if(!HAS_TRAIT(target, TRAIT_CABAL))
		deny(user, circle, "[target] is not of the Cabal.")
		return FALSE
	if(!do_after(user, 5 SECONDS))
		return FALSE
	var/list/helm_options = list(
		"Avantyne Barbute" = image(icon = 'icons/roguetown/clothing/head.dmi', icon_state = "zizobarbute"),
		"Avantyne Froggemund" = image(icon = 'icons/roguetown/clothing/head.dmi', icon_state = "zizofrogmouth"),
		"Avantyne Volf-Plate" = image(icon = 'icons/roguetown/clothing/head.dmi', icon_state = "volfplate_avantyne"),
		"Avantyne Bascinet" = image(icon = 'icons/roguetown/clothing/head.dmi', icon_state = "zizobascinet")
	)

	var/helm_choice = show_radial_menu(user, circle, helm_options, require_near = TRUE, tooltips = TRUE)
	if(!helm_choice)
		helm_choice = "Avantyne Barbute"

	var/list/armor_options = list(
		"Avantyne Half-Plate" = image(icon = 'icons/roguetown/clothing/armor.dmi', icon_state = "zizoplatechest_med"),
	)
	if(user.get_skill_level(/datum/skill/magic/ritualist) >= SKILL_LEVEL_EXPERT)
		armor_options["Avantyne Full-Plate"] = image(icon = 'icons/roguetown/clothing/armor.dmi', icon_state = "zizoplate")

	var/armor_choice = show_radial_menu(user, circle, armor_options, require_near = TRUE, tooltips = TRUE)
	if(!armor_choice)
		armor_choice = "Avantyne Half-Plate"

	var/list/weapon_options = list(
		"Avantyne Longsword" = image(icon = /obj/item/rogueweapon/sword/long/zizo::icon, icon_state = /obj/item/rogueweapon/sword/long/zizo::icon_state),
		"Avantyne Arming Sword" = image(icon = /obj/item/rogueweapon/sword/zizo::icon, icon_state = /obj/item/rogueweapon/sword/zizo::icon_state),
		"Avantyne Greatsword" = image(icon = /obj/item/rogueweapon/greatsword/avantyne/zizo::icon, icon_state = /obj/item/rogueweapon/greatsword/avantyne/zizo::icon_state),
		"Avantyne Rapier" = image(icon = /obj/item/rogueweapon/sword/rapier/avantyne/zizo::icon, icon_state = /obj/item/rogueweapon/sword/rapier/avantyne/zizo::icon_state),
		"Avantyne Billhook" = image(icon = /obj/item/rogueweapon/spear/billhook/avantyne/zizo::icon, icon_state = /obj/item/rogueweapon/spear/billhook/avantyne/zizo::icon_state),
	)
	var/weapon_choice = show_radial_menu(user, circle, weapon_options, require_near = TRUE, tooltips = TRUE)
	if(!weapon_choice)
		weapon_choice = armor_choice == "Avantyne Half-Plate" ? "Avantyne Arming Sword" : "Avantyne Longsword"

	user.say("ZIZO! ZIZO! GODSLAYER TRUE, BRINGER OF THE SHATTERING - O, WINNOWER!")
	playsound(user, 'sound/misc/carriage4.ogg', 100, FALSE, -1)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("ZIZO! ZIZO! HEED MY CALL!")
	playsound(user, 'sound/misc/carriage2.ogg', 100, FALSE, -1)
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("ZIZO! ZIZO! ARMS AND ARMOR; FORGED BY THE IS-NOT - MANIFEST TO REND REALITY!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	var/list/selected_atoms = check_layout(user, circle)
	if(!selected_atoms)
		return FALSE
	if(selected_atoms["C"] != target)
		deny(user, circle, "The arrangement was disturbed, and the rite falls apart.")
		return FALSE
	cleanup_atoms(selected_atoms)
	circle.icon_state = "zizo_active"
	addtimer(VARSET_CALLBACK(circle, icon_state, "zizo_chalky"), 12 SECONDS)
	circle.zizolightsnuff(circle)
	target.Stun(5) //Long enough to hit them w/ the armaments rite on/next to the circle.
	sleep(0.5 SECONDS)
	if(QDELETED(target))
		return TRUE
	new /obj/effect/temp_visual/zizorite(get_turf(target))
	circle.zizoarmaments(target, helm_choice, armor_choice, weapon_choice)
	return TRUE

/obj/structure/ritualcircle/zizo/zizoarmaments(mob/living/carbon/human/target, helm_choice, armor_choice, weapon_choice)
	if(!HAS_TRAIT(target, TRAIT_CABAL))
		fail_invoke()
		return
	var/obj/item/clothing/head/roguetown/helmet/heavy/helm_path
	var/outfit_path = /datum/outfit/job/roguetown/darksteelrite
	switch(helm_choice)
		if("Avantyne Barbute")
			helm_path = /obj/item/clothing/head/roguetown/helmet/heavy/zizo
		if("Avantyne Froggemund")
			helm_path = /obj/item/clothing/head/roguetown/helmet/heavy/zizo/frogge
		if("Avantyne Volf-Plate")
			helm_path = /obj/item/clothing/head/roguetown/helmet/heavy/zizo/volfhelm
		if("Avantyne Bascinet")
			helm_path = /obj/item/clothing/head/roguetown/helmet/heavy/zizo/bascinet
	switch(armor_choice)
		if("Avantyne Half-Plate")
			outfit_path = /datum/outfit/job/roguetown/darksteelrite/medium
		if("Avantyne Full-Plate")
			outfit_path = /datum/outfit/job/roguetown/darksteelrite
	if(!helm_path)
		helm_path = /obj/item/clothing/head/roguetown/helmet/heavy/zizo
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
	target.emote("superagony")
	playsound(loc, 'sound/combat/newstuck.ogg', 50)
	loc.visible_message(span_cult("Great hooks come from the rune, embedding into [target]'s ankles, pulling them onto the rune. Then, into their wrists. Their lux is torn from their chest, reformed into a veil of billowing avantyne!"))
	sleep(2 SECONDS)
	if(QDELETED(target))
		return
	playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
	var/datum/outfit/job/roguetown/darksteelrite/ritual_outfit = new outfit_path()
	ritual_outfit.selected_helm_path = helm_path
	ritual_outfit.selected_weapon_choice = weapon_choice
	target.equipOutfit(ritual_outfit)
	tag_kit_items(target, list(
		"armor" = target.get_item_by_slot(SLOT_ARMOR),
		"shirt" = target.get_item_by_slot(SLOT_SHIRT),
		"pants" = target.get_item_by_slot(SLOT_PANTS),
		"shoes" = target.get_item_by_slot(SLOT_SHOES),
		"wrists" = target.get_item_by_slot(SLOT_WRISTS),
		"gloves" = target.get_item_by_slot(SLOT_GLOVES),
		"head" = target.get_item_by_slot(SLOT_HEAD),
		"neck" = target.get_item_by_slot(SLOT_NECK),
		"backr" = target.get_item_by_slot(SLOT_BACK_R),
		"r_hand" = target.get_item_for_held_index(2),
		"l_hand" = target.get_item_for_held_index(1),
	), list("armor", "shirt", "pants", "shoes", "wrists", "gloves", "head", "neck", "backr", "r_hand", "l_hand"))
	var/weapon_skill = weapon_choice == "Avantyne Billhook" ? /datum/skill/combat/polearms : /datum/skill/combat/swords
	target.adjust_skillrank_up_to(weapon_skill, SKILL_LEVEL_EXPERT, TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), target, span_purple("<br>They are ignorant, backwards, without hope. You. You will be powerful.<br>")), 4 SECONDS)

/datum/outfit/job/roguetown/darksteelrite/proc/apply_weapon_choice()
	switch(selected_weapon_choice)
		if("Avantyne Longsword")
			r_hand = /obj/item/rogueweapon/sword/long/zizo
			l_hand = null
		if("Avantyne Arming Sword")
			r_hand = /obj/item/rogueweapon/sword/zizo
			l_hand = /obj/item/rogueweapon/shield/tower/metal/zizo
		if("Avantyne Greatsword")
			r_hand = /obj/item/rogueweapon/greatsword/avantyne/zizo
			l_hand = null
		if("Avantyne Rapier")
			r_hand = /obj/item/rogueweapon/sword/rapier/avantyne/zizo
			l_hand = null
		if("Avantyne Billhook")
			r_hand = /obj/item/rogueweapon/spear/billhook/avantyne/zizo
			l_hand = null

/datum/outfit/job/roguetown/darksteelrite/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	apply_weapon_choice()

/datum/outfit/job/roguetown/darksteelrite/medium/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	apply_weapon_choice()
