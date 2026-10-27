/datum/objective/heretic/graggar/worthy_foe
	name = "CUTTHROAT"
	heretic_tier = 2
	var/kills = 0
	var/kills_required = 1
	var/steelhearted_only = FALSE

/datum/objective/heretic/graggar/worthy_foe/update_explanation_text()
	explanation_text = "Land the killing blow against someone. Hylics do not count."

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
	if(!istype(victim) || victim == owner.current || !victim.mind || !victim.last_hit_by(owner.current))
		return
	if(steelhearted_only && !HAS_TRAIT(victim, TRAIT_STEELHEARTED))
		return
	kills++
	if(kills < kills_required)
		to_chat(owner.current, span_cult("<i>[kills] of [kills_required] slain.</i>"))
		return
	complete()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)

/datum/objective/heretic/graggar/worthy_foe/progress_text()
	if(kills_required > 1)
		return "[kills] of [kills_required] slain."
