/datum/objective/heretic/graggar/contract
	name = "CONTRACT"
	heretic_tier = 5
	heretic_branch = HERETIC_PATH_ASSASSIN
	var/marks_killed = 0
	var/marks_killed_required = 2
	var/datum/action/cooldown/spell/assassin/get_targets/recall

/datum/objective/heretic/graggar/contract/update_explanation_text()
	explanation_text = "Land the killing blow against two people marked for death."

/datum/objective/heretic/graggar/contract/on_creation()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_death))
	if(owner?.current)
		recall = new
		recall.Grant(owner.current)
	update_explanation_text()

/datum/objective/heretic/graggar/contract/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	QDEL_NULL(recall)
	return ..()

/datum/objective/heretic/graggar/contract/proc/on_death(datum/source, mob/living/dead, gibbed)
	SIGNAL_HANDLER
	if(completed)
		return
	var/mob/living/carbon/human/victim = dead
	if(!istype(victim) || !victim.has_flaw(/datum/charflaw/targeted) || !victim.last_hit_by(owner.current))
		return
	marks_killed++
	if(marks_killed < marks_killed_required)
		to_chat(owner.current, span_cult("<i>[marks_killed] of [marks_killed_required] slain.</i>"))
		return
	QDEL_NULL(recall)
	complete()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)

/datum/objective/heretic/graggar/contract/progress_text()
	return "[marks_killed] of [marks_killed_required] slain."
