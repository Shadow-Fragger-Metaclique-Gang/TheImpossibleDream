// Port of Rotwood-Vale/Ratwood-2.0#3017, using this fork's combat and grip systems.
/datum/intent/spear/thrust/pike/skewer/standard
	icon_state = "inimpale"

/datum/intent/spear/thrust/standard_glaive
	damfactor = 1.1
	chargetime = 0

/datum/intent/mace/smash/eaglebeak/standard_poleaxe
	name = "poleaxe smash"
	damfactor = 1

/datum/alt_grip/standard_poleaxe
	name = "hammer grip"
	two_handed = TRUE
	grip_intents = list(
		/datum/intent/spear/bash/polehammer,
		/datum/intent/mace/smash/eaglebeak/standard_poleaxe,
		/datum/intent/mace/sweep,
	)
	var_overrides = list("sharpness" = IS_BLUNT)

/obj/item/rogueweapon/spear/keep_standard
	icon = 'modular_tidi/job_weapon_overrides/icons/ducal_standards.dmi'
	icon_state = "standard_old"
	force = 12
	force_wielded = 34
	throwforce = 32
	thrown_bclass = BCLASS_PICK
	gripped_intents = list(
		/datum/intent/spear/thrust/pike,
		/datum/intent/spear/thrust/pike/skewer/standard,
		/datum/intent/lance,
		/datum/intent/mace/smash/eaglebeak,
	)
	detail_tag = "_det"
	altdetail_tag = "_detailalt"
	slot_flags = ITEM_SLOT_BACK
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	inv_storage_delay = 1 SECONDS
	var/mutable_appearance/standard_alt_detail_overlay

/obj/item/rogueweapon/spear/keep_standard/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/rogueweapon/spear/keep_standard/lordcolor(primary, secondary)
	altdetail_color = secondary
	return ..()

/obj/item/rogueweapon/spear/keep_standard/refresh_detail_overlay()
	. = ..()
	if(standard_alt_detail_overlay)
		cut_overlay(standard_alt_detail_overlay)
		standard_alt_detail_overlay = null
	if(!get_altdetail_tag())
		return
	var/mutable_appearance/banner_detail = mutable_appearance(icon, "[icon_state][get_altdetail_tag()]")
	banner_detail.appearance_flags = RESET_COLOR
	if(get_altdetail_color())
		banner_detail.color = get_altdetail_color()
	add_overlay(banner_detail)
	standard_alt_detail_overlay = banner_detail

/obj/item/rogueweapon/spear/keep_standard/poleaxe
	desc = "The local lord's banner, fashioned to a poleaxe and turned into a deadly instrument of war. \
	The man who wields this is said to bring great fortune to his house, and those who keep him safe. \
	<small>Runes glow near the head of the weapon, visible for the faintest of moments. A sure sign of the arcyne.</small>"
	icon_state = "standard"
	force = 30
	force_wielded = 30
	max_blade_int = 200
	max_integrity = 260
	smeltresult = /obj/item/ingot/steel
	possible_item_intents = list(
		SPEAR_THRUST,
		/datum/intent/spear/cut/glaive,
		/datum/intent/axe/chop/scythe,
		/datum/intent/mace/smash/eaglebeak,
	)
	gripped_intents = list(
		/datum/intent/spear/thrust/standard_glaive,
		/datum/intent/spear/cut/glaive/sweep,
		/datum/intent/axe/cut/long,
		/datum/intent/axe/chop/long,
	)
	alt_grips = list(/datum/alt_grip/standard_poleaxe)
	var/standard_manoeuvre_selected = FALSE
	var/list/standard_manoeuvres = list(
		/datum/special_intent/polearm_backstep,
		/datum/special_intent/axe_swing,
		/datum/special_intent/wave_swing/greatsword,
		/datum/special_intent/ground_smash,
	)

/obj/item/rogueweapon/spear/keep_standard/poleaxe/examine(mob/user)
	. = ..()
	if(!standard_manoeuvre_selected)
		. += span_notice("The Special Manoeuvre of this weapon can be changed. Right-click it with a free hand to select one. This can only be done once.")

/obj/item/rogueweapon/spear/keep_standard/poleaxe/attack_right(mob/user)
	. = ..()
	if(standard_manoeuvre_selected)
		return
	var/list/special_options = list()
	for(var/datum/special_intent/manoeuvre as anything in standard_manoeuvres)
		special_options[manoeuvre::name] = manoeuvre
	var/choice = input(user, "Choose the Manoeuvre", "MANOEUVRE") as null|anything in special_options
	if(!choice || QDELETED(src) || standard_manoeuvre_selected || !user.Adjacent(src))
		return
	qdel(special)
	var/datum/special_intent/selected_manoeuvre = special_options[choice]
	special = new selected_manoeuvre()
	standard_manoeuvre_selected = TRUE
