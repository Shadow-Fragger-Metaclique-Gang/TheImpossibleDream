/datum/mob_descriptor
	var/descriptor_color
	/// colors genital descriptor depending on arousal state
	var/aroused_descriptor_color
	var/aroused_descriptor_threshold = 30

/datum/mob_descriptor/get_standalone_text(mob/living/described, mob/watcher)
	return "%THEY% [get_coalesce_text(described, null, watcher)]."

/datum/mob_descriptor/get_coalesce_text(mob/living/described, list/used_verbage, mob/watcher)
	var/descriptor_text = "[should_add_verbage(described, used_verbage) ? "[get_verbage(described)] " : ""][get_pre_string(described)][get_description_for_watcher(described, watcher)][post_string]"
	var/color = get_descriptor_color(described, watcher)
	if(color)
		return "<span style='color:[color]'>[descriptor_text]</span>"
	return descriptor_text

/datum/mob_descriptor/proc/get_description_for_watcher(mob/living/described, mob/watcher)
	return get_description(described)

/datum/mob_descriptor/proc/get_descriptor_color(mob/living/described, mob/watcher)
	if(!user_allows_descriptor_color(watcher))
		return
	if(!aroused_descriptor_color || !ishuman(described))
		return descriptor_color
	var/mob/living/carbon/human/H = described
	if(H.sexcon?.arousal > aroused_descriptor_threshold)
		return aroused_descriptor_color
	return descriptor_color

/datum/mob_descriptor/proc/user_allows_descriptor_color(mob/user)
	var/datum/preferences/viewer_preferences = user?.client?.prefs
	return !viewer_preferences || viewer_preferences.descriptor_color
