/datum/objective/heretic/zizo/avantyne
	name = "Steel Against Faith"
	heretic_tier = 3
	heretic_branch = HERETIC_PATH_AVANTYNE
	var/throats_slit = 0
	var/throats_slit_required = 1

/datum/objective/heretic/zizo/avantyne/update_explanation_text()
	explanation_text = "Clad in avantyne, lethally slit the throat of a member of the clergy or the inquisition."

/datum/objective/heretic/zizo/avantyne/on_creation()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_death))
	update_explanation_text()

/datum/objective/heretic/zizo/avantyne/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/datum/objective/heretic/zizo/avantyne/proc/on_death(datum/source, mob/living/dead, gibbed)
	SIGNAL_HANDLER
	if(completed)
		return
	var/mob/living/carbon/human/victim = dead
	if(!istype(victim) || !is_quarry(victim) || !victim.throat_slit_by(owner.current))
		return
	var/mob/living/carbon/human/heretic = owner.current
	if(!istype(heretic) || !istype(heretic.wear_armor, /obj/item/clothing/suit/roguetown/armor/plate/full/zizo) && !istype(heretic.wear_armor, /obj/item/clothing/suit/roguetown/armor/plate/fluted/zizo))
		return
	throats_slit++
	if(throats_slit < throats_slit_required)
		to_chat(heretic, span_cult("<i>[throats_slit] of [throats_slit_required] slain.</i>"))
		return
	complete()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)

/datum/objective/heretic/zizo/avantyne/proc/is_quarry(mob/living/carbon/human/victim)
	return victim.is_clergy_or_inquisition()

/datum/objective/heretic/zizo/avantyne/progress_text()
	if(throats_slit_required > 1)
		return "[throats_slit] of [throats_slit_required] slain."
