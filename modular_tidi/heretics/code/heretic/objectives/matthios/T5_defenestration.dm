/datum/objective/heretic/matthios/defenestration
	name = "Defenestration"
	heretic_tier = 5

/datum/objective/heretic/matthios/defenestration/update_explanation_text()
	explanation_text = "Violate the lux of a member of the keep's high nobility using the defenestration ritual."

/datum/objective/heretic/matthios/defenestration/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HERETIC_DEFENESTRATED, PROC_REF(on_defenestrated))
	update_explanation_text()

/datum/objective/heretic/matthios/defenestration/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HERETIC_DEFENESTRATED)
	return ..()

/datum/objective/heretic/matthios/defenestration/proc/on_defenestrated(datum/source, mob/living/carbon/human/victim)
	SIGNAL_HANDLER
	if(completed || !victim.is_high_nobility())
		return
	complete()
	UnregisterSignal(owner.current, COMSIG_HERETIC_DEFENESTRATED)
