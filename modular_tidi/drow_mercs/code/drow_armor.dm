/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/shadowvest
	icon = 'modular_tidi/drow_mercs/icons/drowarmor.dmi'
	mob_overlay_icon = 'modular_tidi/drow_mercs/icons/onmob_drowarmor.dmi'
	name = "drowcraft vest"
	desc = "Traditional Drow armour made from the hide of one of the Underdark's many beasts, underlaid with the chitin plates of a drider. Durable yet still flexible, perfect for skirmishers."
	icon_state = "shadowvest"
	item_state = "shadowvest"
	body_parts_covered = COVERAGE_FULL
	armor = ARMOR_LEATHER
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate
	icon = 'modular_tidi/drow_mercs/icons/drowarmor.dmi'
	mob_overlay_icon = 'modular_tidi/drow_mercs/icons/onmob_drowarmor.dmi'
	body_parts_covered = COVERAGE_FULL

/obj/item/clothing/suit/roguetown/armor/gambeson/shadowrobe
	icon = 'modular_tidi/drow_mercs/icons/drowarmor.dmi'
	mob_overlay_icon = 'modular_tidi/drow_mercs/icons/onmob_drowarmor.dmi'

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
	icon = 'modular_tidi/drow_mercs/icons/drowarmor.dmi'
	mob_overlay_icon = 'modular_tidi/drow_mercs/icons/onmob_drowarmor.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/knight/shadowplate
	icon = 'modular_tidi/drow_mercs/icons/drowhead.dmi'
	mob_overlay_icon = 'modular_tidi/drow_mercs/icons/onmob_drowhead.dmi'
	name = "drow cavalier helm"
	desc = "A greathelm commonly worn by Underdark spider-jockies. The golden wings convey both a feminine elegance and martriarchal tyranny.\
	While lacking an adjustable visor, the winged halo and accompanying plumage can detach from the helm and be worn separately."
	item_state = "gildeddrowhelm"
	icon_state = "gildeddrowhelm"
	adjustable = CAN_CADJUST
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|EARS|HAIR|NOSE|EYES|MOUTH

/obj/item/clothing/head/roguetown/helmet/heavy/knight/shadowplate/ComponentInitialize()
	..()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS), null, 'sound/items/visor.ogg', null, UPD_HEAD)

/obj/item/clothing/head/roguetown/helmet/heavy/knight/shadowplate/attackby(obj/item/W, mob/living/user, params)
	..()
	if(!(istype(W, /obj/item/natural/feather) && !detail_tag))
		return
	user.visible_message(span_warning("[user] adds [W] to [src]."))
	user.transferItemToLoc(W, src, FALSE, FALSE)
	detail_color = COLOR_WHITE
	detail_tag = "_detail"
	update_icon()
	if(loc == user && ishuman(user))
		var/mob/living/carbon/H = user
		H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/knight/shadowplate/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/kettle/shadow
	color = "#323232"

/obj/item/clothing/head/roguetown/helmet/sallet/visored/shadow
	color = "#323232"

/obj/item/clothing/head/roguetown/helmet/elvenbarbute/shadow
	color = "#402c56"
	detail_color = "#cb9d06"

/obj/item/clothing/head/roguetown/helmet/elvenbarbute/shadow/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged/shadow
	color = "#402c56"
	detail_color = "#cb9d06"

/obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged/shadow/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/shadowplate
	icon = 'modular_tidi/drow_mercs/icons/drowhead.dmi'
	mob_overlay_icon = 'modular_tidi/drow_mercs/icons/onmob_drowhead.dmi'
	name = "smiling bascinet"
	desc = "A helmet of drowsmith sporting a gold wreath and a grinning visor."
	icon_state = "drowhelm"
	item_state = "drowhelm"

/obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/maille
	name = "silk-wreathed maille tights"
	desc = "Form-fitting silk tights layered over fine drowsmithed maille."
	armor = ARMOR_MAILLE
	armor_class = ARMOR_CLASS_MEDIUM
	max_integrity = ARMOR_INT_LEG_HARDLEATHER + 25//slight boost cause it's maille or something
	blocksound = CHAINHIT
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	sewrepair = FALSE//only the silk part is sewable, sire.
	resistance_flags = FIRE_PROOF
	anvilrepair = /datum/skill/craft/armorsmithing
