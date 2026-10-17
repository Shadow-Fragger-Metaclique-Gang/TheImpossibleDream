/datum/objective/heretic/matthios/churn
	name = "Avarice"
	heretic_tier = 1

/datum/objective/heretic/matthios/churn/update_explanation_text()
	explanation_text = "Use CHURN VALUE to destroy something worth at least a hundred mammon."

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
	if(completed || !is_worthy(churned, value))
		return
	complete()
	UnregisterSignal(owner.current, COMSIG_HERETIC_VALUE_CHURNED)

/datum/objective/heretic/matthios/churn/proc/is_worthy(obj/item/churned, value)
	return value >= 100
