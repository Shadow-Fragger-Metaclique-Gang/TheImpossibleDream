/obj/item/clothing/neck/roguetown/coif
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD|ITEM_SLOT_MASK

/obj/item/clothing/neck/roguetown/coif/padded
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD|ITEM_SLOT_MASK

/obj/item/clothing/neck/roguetown/coif/heavypadding
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD|ITEM_SLOT_MASK

/obj/item/clothing/neck/roguetown/chaincoif
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD|ITEM_SLOT_MASK

/proc/is_coif(obj/item/I)
	return istype(I, /obj/item/clothing/neck/roguetown/coif) || istype(I, /obj/item/clothing/neck/roguetown/chaincoif)

/datum/species/proc/wearing_other_coif(obj/item/I, mob/living/carbon/human/H, disable_warning)
	if(!is_coif(I))
		return FALSE
	for(var/obj/item/worn as anything in list(H.wear_mask, H.wear_neck, H.head))
		if(worn && worn != I && is_coif(worn))
			if(!disable_warning)
				to_chat(H, span_warning("I'm already wearing a coif!"))
			return TRUE
	return FALSE
