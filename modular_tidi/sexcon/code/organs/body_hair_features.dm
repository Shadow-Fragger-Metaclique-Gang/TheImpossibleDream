/datum/bodypart_feature/chastity
	name = "Chastity"
	feature_slot = BODYPART_FEATURE_CHASTITY
	body_zone = BODY_ZONE_CHEST
	var/obj/item/chastity/chastity_item

/datum/bodypart_feature/chastity/set_accessory_type(new_accessory_type, colors, mob/living/carbon/owner)
	. = ..()
	if(!chastity_item)
		var/datum/sprite_accessory/chastity/accessory = SPRITE_ACCESSORY(accessory_type)
		chastity_item = new accessory.chastity_type(owner)
	if(owner.chastity_device && owner.chastity_device != chastity_item)
		QDEL_NULL(owner.chastity_device)
	owner.chastity_device = chastity_item
	chastity_item.chastity_feature = src
	chastity_item.color = accessory_colors

/datum/bodypart_feature/pubes
	name = "Pubic Hair"
	feature_slot = BODYPART_FEATURE_PUBES
	body_zone = BODY_ZONE_CHEST
	var/material = BODY_HAIR_MATERIAL_HAIR

/datum/bodypart_feature/pubes/proc/set_material(new_material)
	material = sanitize_integer(
		new_material,
		BODY_HAIR_MATERIAL_HAIR,
		BODY_HAIR_MATERIAL_BRAIDS,
		BODY_HAIR_MATERIAL_HAIR,
	)
	switch(material)
		if(BODY_HAIR_MATERIAL_FUR)
			name = "Pubic Fur"
		if(BODY_HAIR_MATERIAL_FEATHERS)
			name = "Pubic Feathers"
		if(BODY_HAIR_MATERIAL_FUZZ)
			name = "Pubic Fuzz"
		if(BODY_HAIR_MATERIAL_BRAIDS)
			name = "Pubic Braids"
		else
			name = "Pubic Hair"
	return material

/datum/bodypart_feature/pubes/proc/get_description_name()
	switch(material)
		if(BODY_HAIR_MATERIAL_FUR)
			return "pubic fur"
		if(BODY_HAIR_MATERIAL_FEATHERS)
			return "pubic feathers"
		if(BODY_HAIR_MATERIAL_FUZZ)
			return "pubic fuzz"
		if(BODY_HAIR_MATERIAL_BRAIDS)
			return "pubic braids"
	return "pubic hair"

/datum/bodypart_feature/pits
	name = "Armpit Hair"
	feature_slot = BODYPART_FEATURE_PITS
	body_zone = BODY_ZONE_CHEST
	var/material = BODY_HAIR_MATERIAL_HAIR

/datum/bodypart_feature/pits/proc/set_material(new_material)
	material = sanitize_integer(
		new_material,
		BODY_HAIR_MATERIAL_HAIR,
		BODY_HAIR_MATERIAL_BRAIDS,
		BODY_HAIR_MATERIAL_HAIR,
	)
	switch(material)
		if(BODY_HAIR_MATERIAL_FUR)
			name = "Armpit Fur"
		if(BODY_HAIR_MATERIAL_FEATHERS)
			name = "Armpit Feathers"
		if(BODY_HAIR_MATERIAL_FUZZ)
			name = "Armpit Fuzz"
		if(BODY_HAIR_MATERIAL_BRAIDS)
			name = "Armpit Braids"
		else
			name = "Armpit Hair"
	return material

/datum/bodypart_feature/pits/proc/get_description_name()
	switch(material)
		if(BODY_HAIR_MATERIAL_FUR)
			return "armpit fur"
		if(BODY_HAIR_MATERIAL_FEATHERS)
			return "armpit feathers"
		if(BODY_HAIR_MATERIAL_FUZZ)
			return "armpit fuzz"
		if(BODY_HAIR_MATERIAL_BRAIDS)
			return "armpit braids"
	return "armpit hair"
