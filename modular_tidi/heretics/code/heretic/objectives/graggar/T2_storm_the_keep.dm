/datum/objective/heretic/graggar/keep
	name = "STORM THE KEEP"
	heretic_tier = 2

/datum/objective/heretic/graggar/keep/update_explanation_text()
	explanation_text = "Lethally slit the throat of a member of the keep, be they guard, noble, courtier or servant."

/datum/objective/heretic/graggar/keep/on_creation()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_death))
	update_explanation_text()

/datum/objective/heretic/graggar/keep/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/datum/objective/heretic/graggar/keep/proc/on_death(datum/source, mob/living/dead, gibbed)
	SIGNAL_HANDLER
	if(completed)
		return
	var/mob/living/carbon/human/victim = dead
	if(!istype(victim) || victim == owner.current || !victim.is_keep_member() || !victim.throat_slit_by(owner.current))
		return
	complete()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
