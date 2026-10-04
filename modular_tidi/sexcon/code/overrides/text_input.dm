/proc/tgui_input_text_nopaste(mob/user, message = "", title = "Text Input", default, max_length = MAX_TGUI_INPUT, multiline = FALSE, encode = TRUE, timeout = 0, ui_state = GLOB.tgui_always_state, bigmodal = FALSE)
	if (!user)
		user = usr
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return null

	if(isnull(user.client))
		return null

	var/datum/tgui_input_text/nopaste/text_input = new(user, message, title, default, max_length, multiline, encode, timeout, ui_state, bigmodal)
	text_input.ui_interact(user)
	text_input.wait()
	if (text_input)
		. = text_input.entry
		qdel(text_input)

/datum/tgui_input_text/nopaste/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SurrealisTextInputNopaste")
		ui.open()
