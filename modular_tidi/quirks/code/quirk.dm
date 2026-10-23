/datum/quirk
	var/point_cost = 1
	var/warning_text
	var/drawback = FALSE
	/// An associative list containing any skills we want to adjust. You can also pass list objects into this in the following format: list(SKILL_TYPE, SKILL_INCREASE, SKILL_MAXIMUM) as needed.
	var/list/added_skills = list()
	/// An associative list containing any items we want to add to our stash.
	var/list/added_stashed_items = list()
	/// A list containing any extra languages we need to add to the mob.
	var/list/added_languages = list()
	/// An associative list containing any extra stats we need to add to the mob. NOTE: GENERALLY should not add stats unless it imposes serious downsides.
	var/list/added_stats = list()
	/// Mutually exclusive virtues.
	var/list/incompatible_virtues = list()
	/// Mutually exclusive quirks.
	var/list/incompatible_quirks = list()
	/// Mutually exclusive vices.
	var/list/incompatible_vices = list()
	/// If someone already has traits deemed incompatible, don't apply the quirk at all.
	var/list/incompatible_traits = list()

/datum/quirk/none
	point_cost = 0

/proc/surrealis_apply_quirk(mob/living/carbon/human/recipient, datum/quirk/quirk_type)
	if(!quirk_type || istype(quirk_type, /datum/quirk/none))
		return FALSE
	var/applied = quirk_type.apply_generic_effects(recipient)
	if(applied)
		record_featured_object_stat(FEATURED_STATS_QUIRKS, quirk_type.name, 1)
	return applied

/datum/quirk/proc/blocked_by_incompatible_traits(mob/living/carbon/human/recipient)
	for(var/trait in incompatible_traits)
		if(HAS_TRAIT(recipient, trait))
			return trait
	return FALSE

// Shared proc for applying crap.
/datum/quirk/proc/apply_generic_effects(mob/living/carbon/human/recipient)
	if(blocked_by_incompatible_traits(recipient))
		return FALSE
	apply_to_human(recipient)
	handle_traits(recipient)
	handle_skills(recipient)
	handle_stashed_items(recipient)
	handle_added_languages(recipient)
	handle_stats(recipient)
	return TRUE

/datum/quirk/proc/handle_skills(mob/living/carbon/human/recipient)
	if(!recipient.mind || !LAZYLEN(added_skills))
		return
	for(var/skill in added_skills)
		if(!islist(skill))
			recipient.adjust_skillrank(skill, added_skills[skill], TRUE)
		else
			var/list/skill_block = skill
			var/datum/skill/the_skill = skill_block[1]
			var/increase_by = skill_block[2]
			var/maximum_skill = skill_block[3]
			var/our_skill = recipient.get_skill_level(the_skill)
			if(our_skill < maximum_skill)
				if((our_skill + increase_by) > maximum_skill) // we'll be pushing it higher than our max with 1 addition, so lower increase_by
					increase_by = (maximum_skill - our_skill)
				recipient.adjust_skillrank(the_skill, increase_by, TRUE)
			else
				to_chat(recipient, span_notice("This cannot influence my skill with [LOWER_TEXT(initial(the_skill.name))] any further."))

/datum/quirk/proc/handle_stashed_items(mob/living/carbon/human/recipient)
	if(!recipient.mind || !LAZYLEN(added_stashed_items))
		return
	for(var/stashed_item in added_stashed_items)
		recipient.mind?.special_items[stashed_item] = added_stashed_items[stashed_item]

/datum/quirk/proc/handle_added_languages(mob/living/carbon/human/recipient)
	if(!LAZYLEN(added_languages))
		return
	for(var/language in added_languages)
		recipient.grant_language(language)

/datum/quirk/proc/handle_stats(mob/living/carbon/human/recipient)
	if(!LAZYLEN(added_stats))
		return
	for(var/stat in added_stats)
		var/value = added_stats[stat]
		recipient.change_stat(stat, value)

/datum/quirk/constant_ui_data()
	var/list/data = ..()
	data["point_cost"] = point_cost
	data["drawback"] = drawback
	data["warning_text"] = warning_text
	var/list/incompatible = list()
	for(var/datum/virtue/V as anything in incompatible_virtues)
		incompatible += "Virtue: [V::name]"
	for(var/datum/charflaw/C as anything in incompatible_vices)
		incompatible += "Vice: [C::name]"
	for(var/datum/quirk/other as anything in incompatible_quirks)
		incompatible += "Quirk: [other::name]"
	data["incompatible"] = incompatible
	return data
