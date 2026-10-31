/datum/preferences/ui_data_popup_quirk(mob/user)
	var/list/data = list(
		"quirks" = get_quirk_typepaths(),
		"quirk_availability" = null,
		"points" = list(
			"earned" = get_quirk_points_earned(),
			"spent" = get_quirk_points_spent(),
			"remaining" = get_quirk_points_remaining(),
			"collateral" = get_triumph_collateral(),
		),
		"malodorous_scent" = malodorous_scent,
	)

	var/list/quirk_availability = list()
	for(var/path as anything in GLOB.quirks)
		var/datum/quirk/Q = GLOB.quirks[path]
		if(!Q.name || istype(Q, /datum/quirk/none))
			continue
		UNTYPED_LIST_ADD(quirk_availability, list(
			"path" = path,
			"unavailable" = quirk_pick_error(Q),
		))
	data["quirk_availability"] = quirk_availability

	return data

/datum/preferences/ui_act_popup_quirk(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user
	switch(action)
		if("select_quirk")
			var/path = text2path(params["quirk"])
			var/datum/quirk/Q = GLOB.quirks[path]
			if(!Q || istype(Q, /datum/quirk/none) || has_quirk(path))
				return CHARACTER_ACT_DATA_UPDATE
			var/pick_error = quirk_pick_error(Q)
			if(pick_error)
				to_chat(user, span_warning(pick_error))
				return CHARACTER_ACT_DATA_UPDATE
			quirks += new path()
			verbose_pref_log_notification(user, "notice", "Added quirk [Q.name]")
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("remove_quirk")
			var/path = text2path(params["quirk"])
			for(var/datum/quirk/Q in quirks)
				if(Q.type == path)
					quirks -= Q
					verbose_pref_log_notification(user, "notice", "Removed quirk [Q.name]")
					qdel(Q)
					return CHARACTER_ACT_PREVIEW_UPDATE
			return CHARACTER_ACT_DATA_UPDATE
		if("malodorous_scent")
			var/new_scent = tgui_input_text(user, "Describe the scent - in game it reads \"They reek of...\" followed by your text:", "Malodorous", malodorous_scent || "rotting meat and sour sweat", max_length = 100, encode = FALSE)
			if(isnull(new_scent))
				return CHARACTER_ACT_DATA_UPDATE
			if(!length(trim(new_scent)))
				new_scent = "rotting meat and sour sweat"
			malodorous_scent = new_scent
			return CHARACTER_ACT_DATA_UPDATE

/datum/preferences/ui_data_character_creator_identity(mob/user)
	var/list/data = ..()
	data["quirk_points"] = list(
		"earned" = get_quirk_points_earned(),
		"spent" = get_quirk_points_spent(),
		"remaining" = get_quirk_points_remaining(),
		"collateral" = get_triumph_collateral(),
	)
	return data

/datum/preferences/ui_data_character_creator_identity_quirks(mob/user)
	var/list/data = list()
	for(var/datum/quirk/Q in quirks)
		UNTYPED_LIST_ADD(data, list(
			"path" = Q.type,
			"name" = Q.name,
			"point_cost" = Q.point_cost,
			"drawback" = Q.drawback,
			"spawn_error" = quirk_pick_error(Q),
		))
	return data

/datum/preferences/ui_data_popup_virtue(mob/user)
	var/list/data = ..()
	for(var/list/entry in data["virtue_availability"])
		if(entry["unavailable"])
			continue
		var/datum/virtue/V = GLOB.virtues[entry["path"]]
		var/datum/quirk/Q = check_virtue_quirk_conflict(V.type)
		if(Q)
			entry["unavailable"] = "[V.name] conflicts with [Q.name]!"
	return data

/datum/preferences/ui_act_popup_virtue_select(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(check_virtue_quirk_conflict(text2path(params["virtue"]), TRUE, ui.user))
		return CHARACTER_ACT_DATA_UPDATE
	return ..()
