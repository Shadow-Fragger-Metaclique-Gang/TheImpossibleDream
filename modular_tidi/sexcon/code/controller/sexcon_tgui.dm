/datum/sex_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SurrealisSexSession", "Sate Desire")
		ui.open()

/datum/sex_controller/ui_state(mob/user)
	return GLOB.conscious_state

/datum/sex_controller/ui_status(mob/user, datum/ui_state/state)
	if(user != src.user)
		return UI_CLOSE
	return ..()

/datum/sex_controller/proc/get_max_speed()
	return (HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || HAS_TRAIT(user, TRAIT_DEPRAVED) || user.has_status_effect(/datum/status_effect/debuff/emberwine)) ? SEX_SPEED_MAX : SEX_SPEED_MAX - 1

/datum/sex_controller/proc/get_max_force()
	return (HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || HAS_TRAIT(user, TRAIT_DEPRAVED) || user.has_status_effect(/datum/status_effect/debuff/emberwine)) ? SEX_FORCE_MAX : SEX_FORCE_MAX - 1

/datum/sex_controller/ui_static_data(mob/user)
	var/list/data = list()
	data["speed_names"] = list("SLOW", "STEADY", "QUICK", "UNRELENTING", "FURIOUS")
	data["force_names"] = list("GENTLE", "FIRM", "ROUGH", "BRUTAL", "FERAL")
	data["manual_arousal_names"] = list("NATURAL", "UNAROUSED", "PARTIALLY ERECT", "FULLY ERECT")
	return data

/datum/sex_controller/ui_data(mob/user)
	var/list/data = list()
	var/obj/item/organ/penis/got_cock = src.user.getorganslot(ORGAN_SLOT_PENIS)
	var/obj/item/organ/vagina/got_pussy = src.user.getorganslot(ORGAN_SLOT_VAGINA)

	if(!target || target == src.user)
		data["title"] = "Interacting with yourself..."
	else
		data["title"] = "Interacting with [target]..."
	data["doing_unto"] = (!target || target == src.user) ? "Doing unto yourself" : "Doing unto [target]'s"

	data["speed"] = speed
	data["force"] = force
	data["max_speed"] = get_max_speed()
	data["max_force"] = get_max_force()
	data["has_penis"] = !!got_cock
	data["manual_arousal"] = manual_arousal

	data["do_until_finished"] = do_until_finished
	if(got_cock && !got_pussy)
		data["exposure_label"] = "PINTLE"
	else if(!got_cock && got_pussy)
		data["exposure_label"] = "PUSSY"
	else
		data["exposure_label"] = "CROTCH"
	data["bottom_exposed"] = bottom_exposed
	data["has_genitals"] = !!(got_cock || got_pussy || src.user.getorganslot(ORGAN_SLOT_TESTICLES))
	data["hide_pintle_visuals"] = hide_pintle_visuals
	data["freeuse"] = freeuse
	data["doing_subtly"] = do_subtle_action

	data["knot_mode"] = null
	var/active_action = (current_action && !desire_stop) ? current_action : null
	if(active_action)
		var/datum/sex_action/action = SEX_ACTION(active_action)
		if(action.knot_on_finish)
			if((action.user_sex_part & SEX_PART_COCK) && knot_penis_type())
				data["knot_mode"] = "top"
			else if((action.target_sex_part & SEX_PART_COCK) && target?.sexcon?.knot_penis_type())
				data["knot_mode"] = "bottom"
	data["do_knot_action"] = do_knot_action
	data["do_knot_action_as_bottom"] = do_knot_action_as_bottom

	data["arousal"] = min(100, (arousal / ACTIVE_EJAC_THRESHOLD) * 100)
	data["frozen"] = arousal_frozen
	data["can_freeze"] = (aphrodisiac == 1 && !src.user.has_flaw(/datum/charflaw/addiction/thrillseeker))

	data["category"] = action_category
	data["categories"] = list(
		list("name" = "OTHER", "value" = SEX_CATEGORY_MISC),
		list("name" = "HANDS", "value" = SEX_CATEGORY_HANDS),
		list("name" = "PENETRATE", "value" = SEX_CATEGORY_PENETRATE),
	)

	data["current_action"] = active_action ? "[active_action]" : null

	var/list/actions = list()
	var/list/can_perform = list()
	var/user_is_incapacitated = src.user.incapacitated()
	src.user.sexcon.update_all_accessible_body_zones()
	if(target && target != src.user)
		target.sexcon.update_all_accessible_body_zones()
	for(var/action_type in GLOB.sex_actions)
		var/datum/sex_action/action = SEX_ACTION(action_type)
		if(!(action_category & action.category))
			continue
		if(istype(action, /datum/sex_action/chastityplay) && !chastity_content_enabled_for_pair())
			continue
		if(!action.shows_on_menu(src.user, target))
			continue
		actions += list(list(
			"name" = action.name,
			"type" = "[action_type]",
			"description" = "",
			"requires_grab" = action.require_grab,
		))
		if(can_perform_action(action_type, user_is_incapacitated))
			can_perform += "[action_type]"
	data["actions"] = actions
	data["can_perform"] = can_perform
	return data

/datum/sex_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(usr != user)
		return
	switch(action)
		if("start_action")
			var/action_path = text2path(params["action_type"])
			if(!SEX_ACTION(action_path))
				return
			try_start_action(action_path)
		if("stop_action")
			try_stop_current_action()
		if("set_speed")
			adjust_speed(text2num(params["value"]) - speed)
		if("set_force")
			adjust_force(text2num(params["value"]) - force)
		if("set_manual_arousal")
			adjust_arousal_manual(text2num(params["value"]) - manual_arousal)
		if("toggle_finished")
			do_until_finished = !do_until_finished
			update_exposure()
		if("toggle_bottom_exposed")
			if(user.incapacitated(ignore_restraints = TRUE))
				to_chat(user, span_warning("I can't do that right now!"))
			else
				bottom_exposed = !bottom_exposed
				update_exposure()
		if("toggle_hide_pintle_visuals")
			hide_pintle_visuals = !hide_pintle_visuals
			update_exposure()
		if("toggle_freeuse")
			freeuse = !freeuse
			to_chat(user, span_notice("Positioning and exposure checks are now [freeuse ? "disabled" : "enabled"]."))
		if("set_arousal_value")
			var/amount = text2num(params["amount"])
			if(isnull(amount))
				return
			if(amount > arousal)
				try_apply_false_sensation()
			if(aphrodisiac > 1 && amount > 0)
				set_arousal(amount * aphrodisiac)
			else
				set_arousal(amount)
		if("freeze_arousal")
			if(aphrodisiac == 1 && !user.has_flaw(/datum/charflaw/addiction/thrillseeker))
				arousal_frozen = !arousal_frozen
				if(arousal > 60)
					try_apply_false_sensation()
		if("set_category")
			var/new_category = text2num(params["value"])
			if(new_category in list(SEX_CATEGORY_MISC, SEX_CATEGORY_HANDS, SEX_CATEGORY_PENETRATE))
				action_category = new_category
		if("toggle_subtle")
			do_subtle_action = !do_subtle_action
		if("toggle_knot")
			do_knot_action = !do_knot_action
		if("toggle_knot_bottom")
			do_knot_action_as_bottom = !do_knot_action_as_bottom
		if("refresh")
			update_static_data(user, ui)
	return TRUE
