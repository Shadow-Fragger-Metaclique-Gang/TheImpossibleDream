// This file exists because Baothan objectives usually require two steps to complete, doing drugs and doing something else
// It was easier to make a subtype that checks for these multiple stage tasks than having to redefine it every single time
// Step order is not static, you can do them in any order
/datum/objective/heretic/baotha
	heretic_patron = /datum/patron/inhumen/baotha
	var/needs_indulgence = TRUE // Do we need to do drugs or get drunk
	var/indulged = FALSE // Did we do drugs or get drunk
	var/baotha_objective_text // Second objective text, since the first is always doing drugs or getting drunk
	var/baotha_objective_done = FALSE // Did we do it

/datum/objective/heretic/baotha/update_explanation_text()
	if(baotha_objective_text)
		explanation_text = "Snort drugs or get drunk, [baotha_objective_text]."

/datum/objective/heretic/baotha/on_creation()
	. = ..()
	if(owner?.current) // Always listen for causing climaxes, some objectives don't require it but most of them do
		RegisterSignal(owner.current, COMSIG_HERETIC_CLIMAX_CAUSED, PROC_REF(on_climax_caused))
	if(owner?.current && needs_indulgence) // Objective needs us to do drugs? Start listening for us doing drugs
		RegisterSignal(owner.current, COMSIG_DRUG_SNIFFED, PROC_REF(on_drug_sniffed))
		RegisterSignal(owner.current, COMSIG_HERETIC_GOT_DRUNK, PROC_REF(on_drunk))
	update_explanation_text()

/datum/objective/heretic/baotha/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, list(COMSIG_HERETIC_CLIMAX_CAUSED, COMSIG_DRUG_SNIFFED, COMSIG_HERETIC_GOT_DRUNK))
	return ..()

/datum/objective/heretic/baotha/proc/on_climax_caused(datum/source, mob/living/carbon/human/climaxer)
	SIGNAL_HANDLER
	if(completed || climaxer == owner.current)
		return
	on_climax(climaxer)

/datum/objective/heretic/baotha/proc/on_climax(mob/living/carbon/human/climaxer)
	return

/datum/objective/heretic/baotha/proc/on_drug_sniffed(datum/source, mob/living/applier)
	SIGNAL_HANDLER
	if(completed || indulged || !heretic_is_drugged(owner.current.reagents)) // Check if what we snorted put drugs in our blood so you can't snort flour
		return
	indulged = TRUE
	check_progress()

/datum/objective/heretic/baotha/proc/on_drunk(datum/source)
	SIGNAL_HANDLER
	if(completed || indulged)
		return
	indulged = TRUE
	check_progress()

/datum/objective/heretic/baotha/proc/check_progress()
	if(indulged && baotha_objective_done)
		complete()
		return
	to_chat(owner.current, replacetext(replacetext(progress_text(), "- INCOMPLETE", "- [span_red("INCOMPLETE")]"), "- COMPLETE", "- [span_green("COMPLETE")]"))

// We always list "Snort drugs or get drunk" since every two step objective has you doing drugs or getting drunk
// It's very Baothan, isn't it?
/datum/objective/heretic/baotha/progress_text()
	if(!baotha_objective_text)
		return
	return "Snort drugs or get drunk - [indulged ? "COMPLETE" : "INCOMPLETE"] | [capitalize(baotha_objective_text)] - [baotha_objective_done ? "COMPLETE" : "INCOMPLETE"]"

/datum/status_effect/buff/drunk/on_apply()
	. = ..()
	if(.)
		SEND_SIGNAL(owner, COMSIG_HERETIC_GOT_DRUNK)

/datum/sex_controller
	var/datum/weakref/heretic_climax_cause

/datum/sex_controller/New(mob/living/carbon/human/owner)
	. = ..()
	RegisterSignal(user, COMSIG_MOB_EJACULATED, PROC_REF(report_heretic_climax))

/datum/sex_controller/proc/report_heretic_climax(datum/source)
	SIGNAL_HANDLER
	var/list/partners = list()
	var/mob/living/cause = heretic_climax_cause?.resolve()
	if(cause)
		partners |= cause
	if(target && target != user && current_action)
		partners |= target
	for(var/mob/living/carbon/human/partner in range(1, user))
		if(partner != user && partner.sexcon?.target == user && partner.sexcon.current_action)
			partners |= partner
	for(var/mob/living/partner as anything in partners)
		SEND_SIGNAL(partner, COMSIG_HERETIC_CLIMAX_CAUSED, user)

/datum/sex_controller/proc/heretic_force_climax(mob/living/cause)
	if(!can_ejaculate())
		return
	heretic_climax_cause = WEAKREF(cause)
	ejaculate()
	heretic_climax_cause = null
