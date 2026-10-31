/datum/objective/heretic
	/// Names of the people this objective was done to, filled by record_victim() before complete() is called.
	var/list/victims = list()
	var/datum/objective/greentext_record/greentext_record

/// Notes down who the objective was done to. Safe to call repeatedly for the same person and after completion.
/datum/objective/heretic/proc/record_victim(mob/living/victim)
	if(!victim)
		return
	var/victim_name = html_encode(victim.real_name || victim.name)
	var/role = victim.mind?.assigned_role
	if(role)
		victim_name = "[victim_name] the [html_encode("[role]")]"
	if(victim_name in victims)
		return
	victims += victim_name
	greentext_record?.refresh_text()

/datum/heretic_path
	/// Every objective this heretic has completed, oldest first. Kept after the live objective is deleted on advancing.
	var/list/datum/objective/greentext_record/greentext_records = list()

/// Snapshots a completed objective. Does nothing if it is unfinished or already snapshotted.
/datum/heretic_path/proc/log_objective(datum/objective/heretic/objective)
	if(!objective?.completed || objective.greentext_record)
		return
	var/datum/objective/greentext_record/record = new
	record.setup(objective, tier)
	objective.greentext_record = record
	greentext_records += record

/// What the heretic's memory lists under Objectives: all completed ones followed by the unfinished current one.
/datum/heretic_path/proc/get_memory_objectives()
	var/list/memory_objectives = greentext_records.Copy()
	if(current_objective && !current_objective.greentext_record)
		memory_objectives += current_objective
	return memory_objectives
