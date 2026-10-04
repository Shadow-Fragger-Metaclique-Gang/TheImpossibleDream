/mob/living/get_extra_mob_descriptors()
	. = ..()
	. += /datum/mob_descriptor/pits

/proc/surrealis_build_cool_description(list/descriptors, mob/living/described, mob/watcher)
	var/list/lines = list()
	var/list/desc_copy = descriptors.Copy()

	var/first_line = surrealis_build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_HEIGHT, MOB_DESCRIPTOR_SLOT_BODY, MOB_DESCRIPTOR_SLOT_STATURE, MOB_DESCRIPTOR_SLOT_FACE_SHAPE, MOB_DESCRIPTOR_SLOT_FACE_EXPRESSION), "You see %DESC1%, %DESC2% %DESC3% with %DESC4%, %DESC5%.", watcher)
	if(first_line)
		lines += first_line

	var/second_line = surrealis_build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_AGE, MOB_DESCRIPTOR_SLOT_SKIN, MOB_DESCRIPTOR_SLOT_VOICE), "%THEY% %DESC1%, %DESC2% and %DESC3%.", watcher)
	if(second_line)
		lines += second_line

	var/third_line = surrealis_build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PROMINENT, MOB_DESCRIPTOR_SLOT_PROMINENT), "%THEY% %DESC1% and %DESC2%.", watcher)
	if(third_line)
		lines += third_line

	var/fourth_line = surrealis_build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PROMINENT, MOB_DESCRIPTOR_SLOT_PROMINENT), "%THEY% %DESC1% and %DESC2%.", watcher)
	if(fourth_line)
		lines += fourth_line

	var/fifth = surrealis_build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PENIS, MOB_DESCRIPTOR_SLOT_TESTICLES), "%THEY% %DESC1% and %DESC2%.", watcher)
	if(fifth)
		lines += fifth

	var/sixth = surrealis_build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_BREASTS, MOB_DESCRIPTOR_SLOT_VAGINA), "%THEY% %DESC1% and %DESC2%.", watcher)
	if(sixth)
		lines += sixth

	var/pits_line = surrealis_build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PITS), "%THEY% %DESC1%.", watcher)
	if(pits_line)
		lines += pits_line

	/// Print the remaining ones in seperate lines
	for(var/descriptor_type in desc_copy)
		var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(descriptor_type)
		lines += treat_mob_descriptor_string(descriptor.get_standalone_text(described, watcher), described)

	return lines

/proc/surrealis_build_cool_description_unknown(list/descriptors, mob/living/described, mob/watcher)
	var/list/lines = list()
	var/list/desc_copy = descriptors.Copy()

	var/first_line = surrealis_build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_HEIGHT, MOB_DESCRIPTOR_SLOT_BODY, MOB_DESCRIPTOR_SLOT_STATURE), "You see %DESC1%, %DESC2% %DESC3%.", watcher)
	if(first_line)
		lines += first_line

	var/second_line = surrealis_build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_VOICE), "%THEY% %DESC1%.", watcher)
	if(second_line)
		lines += second_line

	var/third_line = surrealis_build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PROMINENT, MOB_DESCRIPTOR_SLOT_PROMINENT), "%THEY% %DESC1% and %DESC2%.", watcher)
	if(third_line)
		lines += third_line

	var/fourth_line = surrealis_build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PROMINENT, MOB_DESCRIPTOR_SLOT_PROMINENT), "%THEY% %DESC1% and %DESC2%.", watcher)
	if(fourth_line)
		lines += fourth_line

	var/fifth = surrealis_build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PENIS, MOB_DESCRIPTOR_SLOT_TESTICLES), "%THEY% %DESC1% and %DESC2%.", watcher)
	if(fifth)
		lines += fifth

	var/sixth = surrealis_build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_BREASTS, MOB_DESCRIPTOR_SLOT_VAGINA), "%THEY% %DESC1% and %DESC2%.", watcher)
	if(sixth)
		lines += sixth

	var/pits_line = surrealis_build_coalesce_description(desc_copy, described, list(MOB_DESCRIPTOR_SLOT_PITS), "%THEY% %DESC1%.", watcher)
	if(pits_line)
		lines += pits_line

	for(var/descriptor_type in desc_copy)
		var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(descriptor_type)
		if(descriptor.show_obscured)
			lines += treat_mob_descriptor_string(descriptor.get_standalone_text(described, watcher), described)

	return lines

/proc/surrealis_build_coalesce_description(list/descriptors, mob/living/described, list/slots, string, mob/watcher)
	var/list/descs = described.get_descriptor_slot_list(slots, descriptors)
	if(!descs)
		return
	var/list/used_verbage = list()
	descriptors -= descs
	for(var/i in 1 to descs.len)
		var/desc_type = descs[i]
		var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(desc_type)
		string = replacetext(string, "%DESC[i]%", descriptor.get_coalesce_text(described, used_verbage, watcher))
		var/used_verb = descriptor.get_verbage(described)
		if(used_verb)
			used_verbage |= used_verb
	string = treat_mob_descriptor_string(string, described)
	return string
