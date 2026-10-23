/datum/runeritual/god/graggar/armaments
	name = "Rite of Armaments"
	desc = "Clads the member of the Horde standing upon the rune in vicious plate and teaches them the axe. Only those Expert in Ritualism may summon full plate."
	layout = list(
		"NW" = /obj/item/natural/bone,
		"NE" = /obj/item/natural/bone,
		"W" = /obj/item/ingot/steel,
		"C" = /mob/living/carbon/human,
		"E" = /obj/item/ingot/steel,
		"S" = /obj/item/organ/heart,
	)
	tier = SKILL_LEVEL_APPRENTICE
	cooldown = 30 MINUTES

/datum/runeritual/god/graggar/armaments/perform(mob/living/user, obj/structure/ritualcircle/graggar/circle)
	if(!check_layout(user, circle))
		return FALSE
	var/list/hosting = match_layout(circle)
	var/mob/living/carbon/human/target = hosting["C"]
	if(!HAS_TRAIT(target, TRAIT_HORDE))
		deny(user, circle, "[target] is no Graggarite. The one upon the rune must bear slaughter in their heart.")
		return FALSE
	if(!do_after(user, 5 SECONDS))
		return FALSE
	var/list/helm_options = list(
		"Vicious Helmet" = image(icon = 'icons/roguetown/clothing/head.dmi', icon_state = "graggarplatehelm"),
		"Vicious Skullhelm" = image(icon = 'icons/roguetown/clothing/head.dmi', icon_state = "graggarplatehelm_heavy"),
	)
	var/helm_choice = show_radial_menu(user, circle, helm_options, require_near = TRUE, tooltips = TRUE)
	if(!helm_choice)
		helm_choice = "Vicious Helmet"

	var/list/armor_options = list(
		"Vicious Half-Plate" = image(icon = 'icons/roguetown/clothing/armor.dmi', icon_state = "graggarplate"),
	)
	if(user.get_skill_level(/datum/skill/magic/ritualist) >= SKILL_LEVEL_EXPERT)
		armor_options["Vicious Full-Plate"] = image(icon = 'icons/roguetown/clothing/armor.dmi', icon_state = "graggarplate_heavy")
	var/armor_choice = show_radial_menu(user, circle, armor_options, require_near = TRUE, tooltips = TRUE)
	if(!armor_choice)
		armor_choice = "Vicious Half-Plate"

	var/list/weapon_options = list(
		"Vicious Greataxe" = image(icon = /obj/item/rogueweapon/greataxe/steel/doublehead/graggar::icon, icon_state = /obj/item/rogueweapon/greataxe/steel/doublehead/graggar::icon_state),
		"Vicious Tomahawk" = image(icon = /obj/item/rogueweapon/stoneaxe/woodcut/steel/graggar::icon, icon_state = /obj/item/rogueweapon/stoneaxe/woodcut/steel/graggar::icon_state),
	)
	var/weapon_choice = show_radial_menu(user, circle, weapon_options, require_near = TRUE, tooltips = TRUE)
	if(!weapon_choice)
		weapon_choice = "Vicious Greataxe"
	user.say("MOTIVE FORCE, O' VIOLENCE!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("A GORGEOUS FEAST OF VIOLENCE, FOR YOU, FOR YOU!!")
	if(!do_after(user, 5 SECONDS))
		return FALSE
	user.say("GIFT ME THE POWER, FOR A SLAUGHTER AWAAAIIIIIITS!!") // see the numbers taste the violence
	if(!do_after(user, 5 SECONDS))
		return FALSE
	var/list/selected_atoms = check_layout(user, circle)
	if(!selected_atoms)
		return FALSE
	if(selected_atoms["C"] != target)
		deny(user, circle, "The arrangement was disturbed, and the rite falls apart.")
		return FALSE
	cleanup_atoms(selected_atoms)
	circle.icon_state = "graggar_active"
	addtimer(VARSET_CALLBACK(circle, icon_state, "graggar_chalky"), 12 SECONDS)
	circle.graggararmor(target, helm_choice, armor_choice, weapon_choice)
	return TRUE

/obj/structure/ritualcircle/graggar/graggararmor(mob/living/carbon/human/target, helm_choice, armor_choice, weapon_choice)
	if(!HAS_TRAIT(target, TRAIT_HORDE))
		fail_invoke()
		return
	var/obj/item/clothing/head/roguetown/helmet/heavy/helm_path
	var/outfit_path
	switch(helm_choice)
		if("Vicious Helmet")
			helm_path = /obj/item/clothing/head/roguetown/helmet/heavy/graggar
		if("Vicious Skullhelm")
			helm_path = /obj/item/clothing/head/roguetown/helmet/heavy/graggar/skull
	switch(armor_choice)
		if("Vicious Half-Plate")
			outfit_path = /datum/outfit/job/roguetown/viciousrite
		if("Vicious Full-Plate")
			outfit_path = /datum/outfit/job/roguetown/viciousrite/heavy
	if(!helm_path)
		helm_path = /obj/item/clothing/head/roguetown/helmet/heavy/graggar
	if(!outfit_path)
		outfit_path = /datum/outfit/job/roguetown/viciousrite
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("<i>UNIMAGINABLE PAIN!</i>"))
	target.emote("superagony")
	playsound(loc, 'sound/misc/smelter_fin.ogg', 50)
	loc.visible_message(span_cult("[target]'s lux pours from their nose and into the rune! The motive force manifests across their body, chaining it with shackles of vicious plate!"))
	sleep(2 SECONDS)
	if(QDELETED(target))
		return
	playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
	var/datum/outfit/job/roguetown/viciousrite/ritual_outfit = new outfit_path()
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
		"mask" = target.get_item_by_slot(SLOT_WEAR_MASK),
		"neck" = target.get_item_by_slot(SLOT_NECK),
		"cloak" = target.get_item_by_slot(SLOT_CLOAK),
		"r_hand" = target.get_item_for_held_index(2),
		"l_hand" = target.get_item_for_held_index(1),
	), list("armor", "shirt", "pants", "shoes", "wrists", "gloves", "head", "mask", "neck", "cloak", "r_hand", "l_hand"))
	target.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), target, span_cult("<i>Break them.</i>")), 4 SECONDS)

	if(!target.mind?.has_spell(/datum/action/cooldown/spell/miracle/intervention) && target.devotion?.max_devotion == CLERIC_REQ_4)	// Devotion check to make sure we give it to the HWretch not some Guy
		target.mind.AddSpell(new /datum/action/cooldown/spell/miracle/intervention)

/datum/outfit/job/roguetown/viciousrite
	var/selected_weapon_choice

/datum/outfit/job/roguetown/viciousrite/proc/apply_weapon_choice()
	switch(selected_weapon_choice)
		if("Vicious Greataxe")
			r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead/graggar
			l_hand = null
		if("Vicious Tomahawk")
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/steel/graggar
			l_hand = /obj/item/rogueweapon/shield/iron/graggar

/datum/outfit/job/roguetown/viciousrite/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	apply_weapon_choice()

/datum/outfit/job/roguetown/viciousrite/heavy/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	apply_weapon_choice()
