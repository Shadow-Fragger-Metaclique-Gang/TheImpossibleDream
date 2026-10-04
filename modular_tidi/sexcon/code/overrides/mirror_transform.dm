/proc/mirror_transform_penis_choices()
	var/list/valid_penis_types = list()
	for(var/choice_path in subtypesof(/datum/customizer_choice/organ/penis))
		var/datum/customizer_choice/organ/penis/choice = new choice_path()
		if(!choice?.organ_type)
			continue
		if(valid_penis_types[choice.name])
			continue
		valid_penis_types[choice.name] = list(
			"organ_type" = choice.organ_type,
			"accessories" = choice.sprite_accessories.Copy(),
		)
	return valid_penis_types

/proc/mirror_transform_swap_penis(mob/living/carbon/human/H, list/selection)
	var/new_organ_type = selection?["organ_type"] || /obj/item/organ/penis
	var/list/accessories = selection?["accessories"]
	var/new_accessory_type = null
	if(length(accessories) > 1)
		var/list/valid_accessories = list()
		for(var/accessory_path in accessories)
			var/datum/sprite_accessory/penis/accessory = SPRITE_ACCESSORY(accessory_path)
			if(accessory)
				valid_accessories[accessory.name] = accessory_path
		var/new_accessory = input(H, "Choose your penis style", "Penis Customization") as null|anything in valid_accessories
		if(!new_accessory)
			return null
		new_accessory_type = valid_accessories[new_accessory]
	else if(length(accessories))
		new_accessory_type = accessories[1]

	var/obj/item/organ/penis/old_penis = H.getorganslot(ORGAN_SLOT_PENIS)
	var/new_size = old_penis?.penis_size || DEFAULT_PENIS_SIZE
	var/new_functional = isnull(old_penis) ? TRUE : old_penis.functional
	var/new_massive = old_penis?.massive

	if(old_penis)
		old_penis.Remove(H)
		qdel(old_penis)

	var/obj/item/organ/penis/penis = new new_organ_type()
	penis.penis_size = new_size
	penis.functional = new_functional
	penis.massive = new_massive
	if(new_accessory_type)
		penis.accessory_type = new_accessory_type
	return penis

/proc/mirror_transform_pubes(mob/living/carbon/human/H)
	var/should_update = FALSE
	var/list/valid_pubes = list("none")
	for(var/pubes_type in subtypesof(/datum/sprite_accessory/pubes))
		if(is_abstract(pubes_type))
			continue
		var/datum/sprite_accessory/pubes/pube_accessory = SPRITE_ACCESSORY(pubes_type)
		if(!pube_accessory)
			continue
		valid_pubes[pube_accessory.name] = pubes_type

	var/new_pubes = input(H, "Style your pubic hair", "Pube Styling") as null|anything in valid_pubes
	if(new_pubes)
		var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
		if(chest)
			var/datum/bodypart_feature/pubes/current_pubes
			for(var/datum/bodypart_feature/pubes/pubes_feature in chest.bodypart_features)
				current_pubes = pubes_feature
				break

			if(new_pubes == "none")
				if(current_pubes)
					chest.remove_bodypart_feature(current_pubes)
					should_update = TRUE
			else if(current_pubes)
				current_pubes.set_accessory_type(valid_pubes[new_pubes], current_pubes.accessory_colors, H)
				should_update = TRUE
			else
				var/default_material = BODY_HAIR_MATERIAL_HAIR
				var/datum/species/current_species = H.dna.species
				for(var/customizer_type as anything in current_species.customizers)
					if(!ispath(customizer_type, /datum/customizer/bodypart_feature/pubes))
						continue
					var/datum/customizer/bodypart_feature/pubes/pubes_customizer = CUSTOMIZER(customizer_type)
					if(pubes_customizer)
						default_material = pubes_customizer.default_material
					break
				var/datum/bodypart_feature/pubes/pubes_feature = new()
				pubes_feature.set_material(default_material)
				pubes_feature.set_accessory_type(valid_pubes[new_pubes], null, H)
				chest.add_bodypart_feature(pubes_feature)
				should_update = TRUE
	return should_update

/proc/mirror_transform_pits(mob/living/carbon/human/H)
	var/should_update = FALSE
	var/list/valid_pits = list("none")
	for(var/pits_type in subtypesof(/datum/sprite_accessory/pits))
		if(is_abstract(pits_type))
			continue
		var/datum/sprite_accessory/pits/pits_accessory = SPRITE_ACCESSORY(pits_type)
		if(!pits_accessory)
			continue
		valid_pits[pits_accessory.name] = pits_type

	var/new_pits = input(H, "Style your armpit hair", "Pithair Styling") as null|anything in valid_pits
	if(new_pits)
		var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
		if(chest)
			var/datum/bodypart_feature/pits/current_pits
			for(var/datum/bodypart_feature/pits/pits_feature in chest.bodypart_features)
				current_pits = pits_feature
				break

			if(new_pits == "none")
				if(current_pits)
					chest.remove_bodypart_feature(current_pits)
					should_update = TRUE
			else if(current_pits)
				current_pits.set_accessory_type(valid_pits[new_pits], current_pits.accessory_colors, H)
				should_update = TRUE
			else
				var/default_material = BODY_HAIR_MATERIAL_HAIR
				var/datum/species/current_species = H.dna.species
				for(var/customizer_type as anything in current_species.customizers)
					if(!ispath(customizer_type, /datum/customizer/bodypart_feature/pits))
						continue
					var/datum/customizer/bodypart_feature/pits/pits_customizer = CUSTOMIZER(customizer_type)
					if(pits_customizer)
						default_material = pits_customizer.default_material
					break
				var/datum/bodypart_feature/pits/pits_feature = new()
				pits_feature.set_material(default_material)
				pits_feature.set_accessory_type(valid_pits[new_pits], null, H)
				chest.add_bodypart_feature(pits_feature)
				should_update = TRUE
	return should_update
