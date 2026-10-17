/datum/objective/heretic/matthios/vault
	name = "Greed"
	heretic_tier = 4
	heretic_branch = HERETIC_PATH_THIEF

/datum/objective/heretic/matthios/vault/update_explanation_text()
	explanation_text = "Enter the keep's vault."

/datum/objective/heretic/matthios/vault/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HERETIC_VAULT_ENTERED, PROC_REF(on_vault_entered))
	update_explanation_text()

/datum/objective/heretic/matthios/vault/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HERETIC_VAULT_ENTERED)
	return ..()

/datum/objective/heretic/matthios/vault/proc/on_vault_entered(datum/source, area/vault)
	SIGNAL_HANDLER
	if(completed)
		return
	complete()
	UnregisterSignal(owner.current, COMSIG_HERETIC_VAULT_ENTERED)

/area/rogue/indoors/town/vault/Entered(atom/movable/M, atom/OldLoc)
	. = ..()
	if(isliving(M))
		SEND_SIGNAL(M, COMSIG_HERETIC_VAULT_ENTERED, src)
