/// A permanent, lightweight snapshot of a completed antagonist objective.
/// Unlike the live objective, it holds no signals or references, so it outlives the objective and can be listed in memories and the round-end report.
/// Deliberately not under /datum/objective/heretic so heretics can never roll it as a real objective.
/datum/objective/greentext_record
	name = "greentext record"
	flavor = "Objective"
	completed = TRUE
	triumph_count = 0
	var/base_text
	var/tier
	var/list/victims = list()

/datum/objective/greentext_record/proc/setup(datum/objective/heretic/source, record_tier)
	name = source.name
	base_text = source.explanation_text
	tier = record_tier
	victims = source.victims
	refresh_text()

/// Memories only print explanation_text, so the victims are folded into it.
/datum/objective/greentext_record/proc/refresh_text()
	explanation_text = base_text
	if(length(victims))
		explanation_text += " <i>(Done to: [english_list(victims)])</i>"

/datum/objective/greentext_record/check_completion()
	return TRUE
