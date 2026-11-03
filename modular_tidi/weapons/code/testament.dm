/obj/item/rogueweapon/sword/rapier/psy/folding/relic // Yes, the path is rapier, but it's a sabre. Why, you ask me? Well, Getonmob was being weird and made cuts come from the side, and I am not educated enough on how to fix it.
	name = "\"Testament\""
	desc = "Commissioned by the Inquisition and wrought by the blacksmiths of Arkenfeit, this peculiar blade was made for those \
	who could ill afford to announce their calling before the time came to draw steel. Its silvered edge folds neatly into \
	the hilt, concealing a weapon fit for the most delicate of investigations. Many a heretic has mistaken its bearer for \
	a harmless clerk, only to learn that the Inquisition keeps its sharpest judgements close at hand."
	force = 22
	max_integrity = 400 //same as eucharist
	max_blade_int = 400
	is_silver = TRUE
	wdefense = 10
	var/extended = FALSE
	special = /datum/special_intent/shin_swipe
	bigboy = TRUE
	smeltresult = /obj/item/ingot/silver
	icon = 'modular_tidi/weapons/icons/testament.dmi'
	icon_state = "psyfoldingblade_on"
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/cut/sabre/heavy, /datum/intent/sword/thrust/sabre, /datum/intent/sword/strike)

/obj/item/rogueweapon/sword/rapier/psy/folding/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN\
	)

/obj/item/rogueweapon/sword/rapier/psy/folding/relic/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	if(extended)
		possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/cut/sabre/heavy, /datum/intent/sword/thrust/sabre, /datum/intent/sword/strike)
		wlength = WLENGTH_NORMAL
		w_class = WEIGHT_CLASS_BULKY
		sharpness = IS_SHARP
		slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
		equip_delay_self = initial(equip_delay_self)
		unequip_delay_self = initial(unequip_delay_self)
		inv_storage_delay = initial(inv_storage_delay)
		icon_state = "psyfoldingblade_on"
		playsound(user, 'sound/items/knife_open.ogg', 100, TRUE)
	else
		possible_item_intents = list(/datum/intent/sword/strike)
		wlength = WLENGTH_SHORT
		w_class = WEIGHT_CLASS_SMALL
		sharpness = IS_BLUNT
		slot_flags = ITEM_SLOT_HIP
		equip_delay_self = 0 SECONDS
		unequip_delay_self = 0 SECONDS
		inv_storage_delay = 0 SECONDS
		icon_state = "psyfoldingblade_off"
	if(user.a_intent)
		var/datum/intent/I = user.a_intent
		if(istype(I))
			I.afterchange()
	user.update_a_intents()
	update_icon()
