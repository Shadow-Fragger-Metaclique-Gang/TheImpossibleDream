/datum/objective/heretic/matthios/churn
	name = "Avarice"
	heretic_tier = 1
	var/value_churned = 0

/datum/objective/heretic/matthios/churn/update_explanation_text()
	explanation_text = "Use CHURN VALUE to destroy things worth a hundred mammon in total."

/datum/objective/heretic/matthios/churn/on_creation()
	. = ..()
	var/mob/living/carbon/human/H = owner?.current
	if(istype(H))
		H.grant_churn_value()
		RegisterSignal(H, COMSIG_HERETIC_VALUE_CHURNED, PROC_REF(on_value_churned))
	update_explanation_text()

/datum/objective/heretic/matthios/churn/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HERETIC_VALUE_CHURNED)
	return ..()

/datum/objective/heretic/matthios/churn/proc/on_value_churned(datum/source, obj/item/churned, value)
	SIGNAL_HANDLER
	if(completed)
		return
	value_churned += value
	if(!is_worthy(churned, value))
		return
	complete()
	UnregisterSignal(owner.current, COMSIG_HERETIC_VALUE_CHURNED)

/datum/objective/heretic/matthios/churn/proc/is_worthy(obj/item/churned, value)
	return value_churned >= 100

/datum/objective/heretic/matthios/churn/progress_text()
	return "[value_churned] of 100 mammon churned."
