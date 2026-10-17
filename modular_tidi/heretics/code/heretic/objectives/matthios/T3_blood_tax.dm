/datum/objective/heretic/matthios/blood_tax
	name = "Blood Tax"
	heretic_tier = 3
	heretic_branch = HERETIC_PATH_DRAKE

/datum/objective/heretic/matthios/blood_tax/update_explanation_text()
	explanation_text = "Lethally slit the throat of a noble."

/datum/objective/heretic/matthios/blood_tax/on_creation()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_death))
	update_explanation_text()

/datum/objective/heretic/matthios/blood_tax/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/datum/objective/heretic/matthios/blood_tax/proc/on_death(datum/source, mob/living/dead, gibbed)
	SIGNAL_HANDLER
	if(completed)
		return
	var/mob/living/carbon/human/victim = dead
	if(!istype(victim) || !victim.is_noble() || !victim.throat_slit_by(owner.current))
		return
	complete()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
