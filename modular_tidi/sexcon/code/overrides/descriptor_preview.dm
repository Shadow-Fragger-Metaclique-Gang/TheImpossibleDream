/datum/preferences/preview_descriptors(mob/user)
	if(!COOLDOWN_FINISHED(src, descriptor_preview))
		to_chat(user, span_warning("You must wait before previewing descriptors again."))
		return
	COOLDOWN_START(src, descriptor_preview, 5 SECONDS)
	to_chat(user, span_notice("-- Preview of [real_name]'s descriptors --"))

	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
	copy_to(mannequin, FALSE, TRUE, TRUE)
	apply_descriptors(mannequin)

	// Calculate speaking name
	to_chat(user, \
		"[SPAN_TOOLTIP("This will be displayed when you speak when your face is hidden or out of view range.", span_notice("Anonymous Speaking Name"))]: \
		<font color='[voice_color]'>[get_speaking_name_preview(mannequin)]</font>")

	// Calculate visible name
	var/list/descriptors = mannequin.get_mob_descriptors(FALSE, null)
	to_chat(user, \
		"[SPAN_TOOLTIP("This will be displayed when you emote or are examined when your face is hidden.", span_notice("Anonymous Visible Name"))]: \
		<font color='[voice_color]'>[get_visible_name_preview(mannequin, descriptors.Copy())]</font>")

	// Calculate descriptor blurb
	var/list/desc_lines = surrealis_build_cool_description(descriptors, mannequin)
	unset_busy_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)

	// Output blurb
	to_chat(user, span_notice("<b>Details</b>"))
	for(var/line in desc_lines)
		to_chat(user, span_info(line))
