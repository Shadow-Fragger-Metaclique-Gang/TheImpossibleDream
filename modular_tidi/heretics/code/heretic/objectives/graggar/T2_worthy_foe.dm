/datum/objective/heretic/graggar/worthy_foe
	name = "WORTHY FOE"
	heretic_tier = 2
	var/throats_slit = 0
	var/throats_slit_required = 1

/datum/objective/heretic/graggar/worthy_foe/update_explanation_text()
	explanation_text = "Lethally slit the throat of a steelhearted opponent."

/datum/objective/heretic/graggar/worthy_foe/on_creation()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_death))
	update_explanation_text()

/datum/objective/heretic/graggar/worthy_foe/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/datum/objective/heretic/graggar/worthy_foe/proc/on_death(datum/source, mob/living/dead, gibbed)
	SIGNAL_HANDLER
	if(completed)
		return
	var/mob/living/carbon/human/victim = dead
	if(!istype(victim) || !HAS_TRAIT(victim, TRAIT_STEELHEARTED) || !victim.throat_slit_by(owner.current))
		return
	throats_slit++
	if(throats_slit < throats_slit_required)
		to_chat(owner.current, span_cult("<i>[throats_slit] of [throats_slit_required] worthy throats.</i>"))
		return
	complete()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)

/datum/objective/heretic/graggar/worthy_foe/progress_text()
	if(throats_slit_required > 1)
		return "[throats_slit] of [throats_slit_required] worthy throats."
