/datum/keybinding/living/sprinthold
	hotkey_keys = list()
	name = "sprinthold"
	full_name = "Sprint (hold)"
	description = "Sprinting can be dangerous to your health if you aren't careful. This requires a constant hold input."

/datum/keybinding/living/sprinthold/down(client/user)
	var/mob/M = user.mob
	if(!isliving(M))
		return
	if(M.m_intent == MOVE_INTENT_WALK)
		M.toggle_rogmove_intent(MOVE_INTENT_RUN)
	return TRUE
/datum/keybinding/living/sprinthold/up(client/user)
	var/mob/M = user.mob
	if(!isliving(M))
		return
	if(M.m_intent == MOVE_INTENT_RUN)
		M.toggle_rogmove_intent(MOVE_INTENT_WALK)
	return TRUE


/datum/keybinding/living/jumphold
	hotkey_keys = list()
	name = "jumphold"
	full_name = "Jump (hold)"
	description = "Selects Jump Intent. This requires a constant hold input."

/datum/keybinding/living/jumphold/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_JUMP) //These detoggle each other as needed
	return TRUE
/datum/keybinding/living/jumphold/up(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_JUMP)
	return TRUE


/datum/keybinding/carbon/throwhold
	name = "toggle_throw_mode_hold"
	full_name = "Throw mode (hold)"
	description = "Toggle throwing the current item or not. Requires a held input."
	category = CATEGORY_CARBON

/datum/keybinding/carbon/throwhold/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.throw_mode_on()
	return TRUE
/datum/keybinding/carbon/throwhold/up(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.throw_mode_off()
	return TRUE
