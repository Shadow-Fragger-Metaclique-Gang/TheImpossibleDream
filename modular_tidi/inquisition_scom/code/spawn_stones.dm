/// Slots checked, in order, for a storage item with room.
GLOBAL_LIST_INIT(inquisition_stone_storage_slots, list(SLOT_BACK_L, SLOT_BACK_R, SLOT_BELT, SLOT_BELT_L, SLOT_BELT_R, SLOT_CLOAK))

/// Creates a stone and puts it in the first worn storage item with room, then in a free hand, then on the floor.
/proc/give_inquisition_scomstone(mob/living/carbon/human/H, stone_type)
	if(!H)
		return
	var/obj/item/stone = new stone_type(get_turf(H))
	for(var/slot in GLOB.inquisition_stone_storage_slots)
		var/obj/item/container = H.get_item_by_slot(slot)
		if(container && SEND_SIGNAL(container, COMSIG_TRY_STORAGE_INSERT, stone, null, TRUE, TRUE))
			return
	H.put_in_hands(stone)

/datum/advclass/absolver/post_equip(mob/living/carbon/human/H)
	. = ..()
	give_inquisition_scomstone(H, /obj/item/scomstone/inquisition)

/datum/advclass/psydoniantemplar/post_equip(mob/living/carbon/human/H)
	. = ..()
	give_inquisition_scomstone(H, /obj/item/scomstone/inquisition)

/datum/advclass/disciple/post_equip(mob/living/carbon/human/H)
	. = ..()
	give_inquisition_scomstone(H, /obj/item/scomstone/inquisition)

/datum/advclass/sojourner/post_equip(mob/living/carbon/human/H)
	. = ..()
	give_inquisition_scomstone(H, /obj/item/scomstone/inquisition)

/datum/advclass/confessor/post_equip(mob/living/carbon/human/H)
	. = ..()
	give_inquisition_scomstone(H, /obj/item/scomstone/inquisition)

/datum/advclass/psyaltrist/post_equip(mob/living/carbon/human/H)
	. = ..()
	give_inquisition_scomstone(H, /obj/item/scomstone/inquisition)

/datum/advclass/dungeoneer/post_equip(mob/living/carbon/human/H)
	. = ..()
	give_inquisition_scomstone(H, /obj/item/scomstone/inquisition)

/datum/advclass/inquisitor/inspector/post_equip(mob/living/carbon/human/H)
	. = ..()
	give_inquisition_scomstone(H, /obj/item/scomstone/inquisition/puritan)

/datum/advclass/inquisitor/ordinator/post_equip(mob/living/carbon/human/H)
	. = ..()
	give_inquisition_scomstone(H, /obj/item/scomstone/inquisition/puritan)
