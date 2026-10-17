/datum/objective/heretic/matthios/churn/key
	name = "Opened Lock"
	heretic_tier = 3
	heretic_branch = HERETIC_PATH_THIEF

/datum/objective/heretic/matthios/churn/key/update_explanation_text()
	explanation_text = "Use CHURN VALUE on a key to the temple, the armory or the inquisition in view of another."

/datum/objective/heretic/matthios/churn/key/is_worthy(obj/item/churned, value)
	var/obj/item/roguekey/key = churned
	if(!istype(key) || !key.lockhash)
		return FALSE
	var/sacred_lock = FALSE
	for(var/lockid in list("church", "priest", "armory", "inquisition", "puritan"))
		if(GLOB.lockids[lockid] == key.lockhash)
			sacred_lock = TRUE
	if(!sacred_lock)
		return FALSE
	for(var/mob/living/carbon/human/witness in viewers(7, owner.current))
		if(witness != owner.current && witness.client && witness.stat == CONSCIOUS)
			return TRUE
	return FALSE
