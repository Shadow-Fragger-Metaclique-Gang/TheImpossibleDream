#define STATUE_PREF_MESSAGE_MAX 300

/datum/preferences
	var/statue_merc_message = ""
	var/statue_adv_optin = FALSE
	var/statue_adv_message = ""
	var/statue_wretch_nom = ""
	var/statue_wretch_message = ""

/datum/preferences/load_character(slot)
	. = ..()
	if(!path || !fexists(path))
		return
	var/savefile/S = new /savefile(path)
	if(!S)
		return
	S.cd = "/character[default_slot]"
	S["statue_merc_message"] >> statue_merc_message
	S["statue_adv_optin"] >> statue_adv_optin
	S["statue_adv_message"] >> statue_adv_message
	S["statue_wretch_nom"] >> statue_wretch_nom
	S["statue_wretch_message"] >> statue_wretch_message
	statue_merc_message = strip_html_simple(sanitize_text(statue_merc_message, ""), STATUE_PREF_MESSAGE_MAX + 1)
	statue_adv_message = strip_html_simple(sanitize_text(statue_adv_message, ""), STATUE_PREF_MESSAGE_MAX + 1)
	statue_wretch_message = strip_html_simple(sanitize_text(statue_wretch_message, ""), STATUE_PREF_MESSAGE_MAX + 1)
	statue_wretch_nom = strip_html_simple(sanitize_text(statue_wretch_nom, ""), NOM_DE_GUERRE_MAX_LENGTH + 1)
	statue_adv_optin = sanitize_bool(statue_adv_optin, FALSE)

/datum/preferences/save_character()
	. = ..()
	if(!path)
		return
	var/savefile/S = new /savefile(path)
	if(!S)
		return
	S.cd = "/character[default_slot]"
	WRITE_FILE(S["statue_merc_message"], statue_merc_message)
	WRITE_FILE(S["statue_adv_optin"], statue_adv_optin)
	WRITE_FILE(S["statue_adv_message"], statue_adv_message)
	WRITE_FILE(S["statue_wretch_nom"], statue_wretch_nom)
	WRITE_FILE(S["statue_wretch_message"], statue_wretch_message)

/datum/preferences/ui_data_character_creator(mob/user)
	var/list/data = ..()
	data["statue_merc_message"] = statue_merc_message
	data["statue_adv_optin"] = statue_adv_optin
	data["statue_adv_message"] = statue_adv_message
	data["statue_wretch_nom"] = statue_wretch_nom
	data["statue_wretch_message"] = statue_wretch_message
	return data

/datum/preferences/ui_act_character_creator(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	switch(action)
		if("statue_merc_message")
			var/new_message = tgui_input_text(user, "Message shown on the Mercenary statue (max [STATUE_PREF_MESSAGE_MAX] characters). Leave empty to clear.", "Mercenary Statue Message", statue_merc_message, max_length = STATUE_PREF_MESSAGE_MAX, encode = FALSE)
			if(isnull(new_message))
				return CHARACTER_ACT_DATA_UPDATE
			statue_merc_message = strip_html_simple(new_message, STATUE_PREF_MESSAGE_MAX + 1)
			return CHARACTER_ACT_DATA_UPDATE
		if("statue_adv_optin")
			statue_adv_optin = !statue_adv_optin
			return CHARACTER_ACT_DATA_UPDATE
		if("statue_adv_message")
			var/new_message = tgui_input_text(user, "Message shown on the Mercenary statue's Adventurer roster (max [STATUE_PREF_MESSAGE_MAX] characters). Leave empty to clear.", "Adventurer Statue Message", statue_adv_message, max_length = STATUE_PREF_MESSAGE_MAX, encode = FALSE)
			if(isnull(new_message))
				return CHARACTER_ACT_DATA_UPDATE
			statue_adv_message = strip_html_simple(new_message, STATUE_PREF_MESSAGE_MAX + 1)
			return CHARACTER_ACT_DATA_UPDATE
		if("statue_wretch_nom")
			var/new_nom = tgui_input_text(user, "Nom de guerre shown on the Wretch roster (max [NOM_DE_GUERRE_MAX_LENGTH] characters). Leave empty to be given one based on your class.", "Wretch Nom de Guerre", statue_wretch_nom, max_length = NOM_DE_GUERRE_MAX_LENGTH, encode = FALSE)
			if(isnull(new_nom))
				return CHARACTER_ACT_DATA_UPDATE
			statue_wretch_nom = strip_html_simple(new_nom, NOM_DE_GUERRE_MAX_LENGTH + 1)
			return CHARACTER_ACT_DATA_UPDATE
		if("statue_wretch_message")
			var/new_message = tgui_input_text(user, "Description shown on the Wretch roster (max [STATUE_PREF_MESSAGE_MAX] characters). Leave empty to clear.", "Wretch Statue Description", statue_wretch_message, max_length = STATUE_PREF_MESSAGE_MAX, encode = FALSE)
			if(isnull(new_message))
				return CHARACTER_ACT_DATA_UPDATE
			statue_wretch_message = strip_html_simple(new_message, STATUE_PREF_MESSAGE_MAX + 1)
			return CHARACTER_ACT_DATA_UPDATE

/proc/statue_prefs_of(mob/living/carbon/human/H)
	if(!H)
		return null
	if(H.client?.prefs)
		return H.client.prefs
	var/ckey_to_use = H.ckey || ckey(H.mind?.key)
	return ckey_to_use ? GLOB.preferences_datums[ckey_to_use] : null

#undef STATUE_PREF_MESSAGE_MAX
