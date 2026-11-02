/datum/job/roguetown/sergeant
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)

/datum/job/roguetown/manorguard
	job_traits = list(TRAIT_STEELHEARTED)

// Replaced by the Dendor job in NEW_JOBS.
/datum/job/roguetown/warden
	total_positions = 0
	spawn_positions = 0
	hidden_job = TRUE
	always_show_on_latechoices = FALSE

/// Swaps the worn iron-tier or plain pieces for the garrison upgrade: padded gambeson, steel maille, steel gorget.
/datum/advclass/proc/garrison_steel_upgrade(mob/living/carbon/human/H)
	var/static/list/upgrades = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy, SLOT_SHIRT),
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron = list(/obj/item/clothing/suit/roguetown/armor/chainmail, SLOT_SHIRT),
		/obj/item/clothing/neck/roguetown/gorget = list(/obj/item/clothing/neck/roguetown/gorget/steel, SLOT_NECK),
	)
	for(var/obj/item/worn in list(H.wear_shirt, H.wear_neck))
		var/list/upgrade = upgrades[worn.type]
		if(!upgrade)
			continue
		var/new_type = upgrade[1]
		H.temporarilyRemoveItemFromInventory(worn, TRUE)
		qdel(worn)
		H.equip_to_slot_or_del(new new_type(H), upgrade[2], TRUE)
	// Steel mask. Worn if the face is free, otherwise carried.
	var/obj/item/clothing/mask/rogue/facemask/steel/mask = new(get_turf(H))
	if(H.wear_mask || !H.equip_to_slot_if_possible(mask, SLOT_WEAR_MASK, FALSE, TRUE, FALSE, TRUE, TRUE))
		H.equip_to_slot_if_possible(mask, SLOT_IN_BACKPACK, FALSE, TRUE, FALSE, TRUE, TRUE)

/datum/advclass/manorguard/footsman/post_equip(mob/living/carbon/human/H)
	. = ..()
	garrison_steel_upgrade(H)

/datum/advclass/manorguard/skirmisher/post_equip(mob/living/carbon/human/H)
	. = ..()
	garrison_steel_upgrade(H)

/datum/advclass/manorguard/cavalry/post_equip(mob/living/carbon/human/H)
	. = ..()
	garrison_steel_upgrade(H)

/datum/advclass/manorguard/bailiff/post_equip(mob/living/carbon/human/H)
	. = ..()
	garrison_steel_upgrade(H)

/datum/advclass/manorguard/standard_bearer/post_equip(mob/living/carbon/human/H)
	. = ..()
	garrison_steel_upgrade(H)

/datum/advclass/sergeant/sergeant/post_equip(mob/living/carbon/human/H)
	. = ..()
	garrison_steel_upgrade(H)
