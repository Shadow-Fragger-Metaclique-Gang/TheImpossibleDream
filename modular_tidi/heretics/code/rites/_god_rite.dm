GLOBAL_LIST_INIT(god_rite_tiles, list(
	"NW" = NORTHWEST,
	"N" = NORTH,
	"NE" = NORTHEAST,
	"W" = WEST,
	"C" = 0,
	"E" = EAST,
	"SW" = SOUTHWEST,
	"S" = SOUTH,
	"SE" = SOUTHEAST,
))

GLOBAL_LIST_EMPTY(surrealis_type_icons)

/proc/surrealis_type_icon(atom/thing_type)
	if(!GLOB.surrealis_type_icons[thing_type])
		GLOB.surrealis_type_icons[thing_type] = icon2base64(icon(initial(thing_type.icon), initial(thing_type.icon_state), SOUTH, 1))
	return GLOB.surrealis_type_icons[thing_type]

/datum/runeritual/god
	abstract_type = /datum/runeritual/god
	category = "Divine"
	blacklisted = TRUE
	var/cooldown = 0
	var/flavor
	var/list/layout
	var/list/chant_lines
	var/chant_delay = 5 SECONDS

/datum/runeritual/god/proc/is_hidden(mob/living/user, obj/structure/ritualcircle/circle)
	return FALSE

/datum/runeritual/god/proc/get_layout(mob/living/user)
	return layout

/datum/runeritual/god/proc/lock_reason(mob/living/user, obj/structure/ritualcircle/circle)
	if(tier > user.get_skill_level(/datum/skill/magic/ritualist))
		return "Requires [skill_to_string(tier)] Ritualism."
	if(cooldown && TIMER_COOLDOWN_RUNNING(user, type))
		return "I must rest before performing this rite again.\n[DisplayTimeText(S_TIMER_COOLDOWN_TIMELEFT(user, type), 60)] remaining."

/datum/runeritual/god/proc/deny(mob/living/user, obj/structure/ritualcircle/circle, message)
	to_chat(user, span_warning("<i>[replacetext(message, "\n", "<br>")]</i>"))
	circle.fail_invoke()

/datum/runeritual/god/proc/match_layout(obj/structure/ritualcircle/circle, mob/living/user)
	var/list/selected_atoms = list()
	var/list/rite_layout = get_layout(user)
	for(var/tile in rite_layout)
		selected_atoms[tile] = null
		var/turf/T = tile == "C" ? get_turf(circle) : get_step(circle, GLOB.god_rite_tiles[tile])
		var/list/wanted = islist(rite_layout[tile]) ? rite_layout[tile] : list(rite_layout[tile])
		for(var/atom/movable/AM as anything in T)
			if(AM == circle || AM.invisibility || (AM.type in banned_atom_types))
				continue
			if(isitem(AM))
				var/obj/item/I = AM
				if(I.item_flags & ABSTRACT)
					continue
			if(is_type_in_list(AM, wanted))
				selected_atoms[tile] = AM
				break
	return selected_atoms

/datum/runeritual/god/proc/check_layout(mob/living/user, obj/structure/ritualcircle/circle)
	var/list/selected_atoms = match_layout(circle, user)
	var/list/rite_layout = get_layout(user)
	var/list/what_are_we_missing = list()
	for(var/tile in selected_atoms)
		if(!selected_atoms[tile])
			what_are_we_missing += requirement_name(rite_layout[tile])
	if(length(what_are_we_missing))
		deny(user, circle, "Ritual failed, missing components!\nYou are missing [english_list(what_are_we_missing)] in order to complete the ritual \"[name]\".")
		return FALSE
	return selected_atoms

/datum/runeritual/god/proc/chant(mob/living/user, obj/structure/ritualcircle/circle)
	for(var/line in chant_lines)
		if(!do_after(user, chant_delay, target = circle))
			return FALSE
		user.say(line)
	return TRUE

/datum/runeritual/god/proc/perform(mob/living/user, obj/structure/ritualcircle/circle)
	if(!check_layout(user, circle) || !chant(user, circle))
		return FALSE
	var/list/selected_atoms = check_layout(user, circle)
	if(!selected_atoms || !on_finished_recipe(user, selected_atoms, get_turf(circle)))
		return FALSE
	cleanup_atoms(selected_atoms)
	return TRUE

/datum/runeritual/god/proc/try_perform(mob/living/user, obj/structure/ritualcircle/circle)
	var/locked = lock_reason(user, circle)
	if(locked)
		deny(user, circle, locked)
		return FALSE
	if(!perform(user, circle))
		return FALSE
	playsound(circle, 'sound/magic/soulsteal.ogg', 50, TRUE)
	var/mob/living/carbon/human/H = user
	if(is_heretical_rune(circle) && istype(H))
		H.adjust_blood_corruption(15)
	if(cooldown)
		S_TIMER_COOLDOWN_START(user, type, cooldown)
	return TRUE

/datum/runeritual/god/cleanup_atoms(list/selected_atoms)
	var/list/sacrifices = list()
	for(var/tile in selected_atoms)
		var/atom/movable/sacrificed = selected_atoms[tile]
		if(QDELETED(sacrificed) || isliving(sacrificed))
			continue
		new /obj/effect/temp_visual/rite_consumed(get_turf(sacrificed), sacrificed)
		sacrifices += sacrificed
	return ..(sacrifices)

/datum/runeritual/god/parse_required_item(atom/item_path, number_of_things)
	if(ispath(item_path, /mob/living/carbon/human))
		return "a lyving person"
	if(ispath(item_path, /mob/living))
		return "a lyving creature"
	return initial(item_path.name)

/datum/runeritual/god/proc/requirement_name(requirement)
	var/list/names = list()
	for(var/requirement_type in (islist(requirement) ? requirement : list(requirement)))
		names += parse_required_item(requirement_type)
	return english_list(names, and_text = " or ")

/datum/runeritual/god/proc/requirement_icons(requirement)
	var/list/icons = list()
	for(var/requirement_type in (islist(requirement) ? requirement : list(requirement)))
		if(ispath(requirement_type, /mob/living))
			icons |= surrealis_type_icon(/mob/living/simple_animal/hostile/rogue/skeleton)
			continue
		for(var/atom/candidate as anything in typesof(requirement_type))
			if(length(icons) >= 8)
				break
			if(IS_ABSTRACT(candidate) || (candidate in banned_atom_types) || !icon_exists(initial(candidate.icon), initial(candidate.icon_state)))
				continue
			icons |= surrealis_type_icon(candidate)
	return icons

/obj/effect/temp_visual/rite_consumed
	duration = 1 SECONDS
	randomdir = FALSE

/obj/effect/temp_visual/rite_consumed/Initialize(mapload, atom/movable/consumed)
	. = ..()
	if(!consumed)
		return
	appearance = consumed.appearance
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	animate(src, color = "#2a2a2a", time = 0.4 SECONDS)
	animate(pixel_y = pixel_y + 10, alpha = 0, time = 0.6 SECONDS, easing = QUAD_EASING | EASE_IN)

/obj/structure/ritualcircle
	var/allowed_patron
	var/list/rites = list()
	var/unworthy_message = "I don't know the proper rites for this..."
	var/rites_title = "Rituals"
	var/list/rite_datums
	var/performing_rite = FALSE

/obj/structure/ritualcircle/proc/fail_invoke()
	visible_message(span_warning("The markings pulse with a small flash of light, then fall dark."))
	var/oldcolor = color
	color = rgb(255, 0, 0)
	animate(src, color = oldcolor, time = 5)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 0.5 SECONDS)

/obj/structure/ritualcircle/proc/can_use_rites(mob/living/user)
	return user.patron?.type == allowed_patron

/obj/structure/ritualcircle/proc/get_rite_datums()
	if(!rite_datums)
		rite_datums = list()
		for(var/rite_type in rites)
			rite_datums += new rite_type
	return rite_datums

/obj/structure/ritualcircle/proc/use_rites(mob/living/user)
	if(!allow_dreamwalkers && HAS_TRAIT(user, TRAIT_DREAMWALKER))
		to_chat(user, span_danger("<i>Only the rune of stirring calls to me now...</i>"))
		fail_invoke()
		return FALSE
	if(!can_use_rites(user))
		to_chat(user, span_warning("<i>[unworthy_message]</i>"))
		fail_invoke()
		return FALSE
	ui_interact(user)
	return TRUE

/obj/structure/ritualcircle/proc/invoke_rite(mob/living/user, datum/runeritual/god/rite)
	performing_rite = TRUE
	rite.try_perform(user, src)
	performing_rite = FALSE

/obj/structure/ritualcircle/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SurrealisRitualMenu", rites_title)
		ui.open()

/obj/structure/ritualcircle/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/ritualcircle/ui_status(mob/user, datum/ui_state/state)
	if(!isliving(user) || !can_use_rites(user))
		return UI_CLOSE
	return ..()

/obj/structure/ritualcircle/ui_static_data(mob/user)
	var/list/data = list()
	var/datum/patron/circle_patron = allowed_patron
	data["patron"] = circle_patron ? initial(circle_patron.name) : name
	data["theme"] = ispath(allowed_patron, /datum/patron/inhumen) ? "surrealis_heretic" : "grimoire"
	data["tiles"] = GLOB.god_rite_tiles.Copy()
	data["rune_name"] = name
	data["rune_icon"] = surrealis_type_icon(type)
	var/list/rite_list = list()
	for(var/datum/runeritual/god/rite as anything in get_rite_datums())
		if(rite.is_hidden(user, src))
			continue
		var/list/rite_layout = rite.get_layout(user)
		var/list/tile_names = list()
		var/list/tile_icons = list()
		for(var/tile in rite_layout)
			tile_names[tile] = rite.requirement_name(rite_layout[tile])
			tile_icons[tile] = rite.requirement_icons(rite_layout[tile])
		rite_list += list(list(
			"id" = "[rite.type]",
			"name" = rite.name,
			"desc" = rite.desc,
			"flavor" = rite.flavor,
			"ascension" = istype(rite, /datum/runeritual/god/ascension),
			"tier" = rite.tier,
			"tier_name" = skill_to_string(rite.tier),
			"cooldown" = rite.cooldown ? DisplayTimeText(rite.cooldown) : null,
			"tile_names" = tile_names,
			"tile_icons" = tile_icons,
		))
	data["rites"] = rite_list
	return data

/obj/structure/ritualcircle/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/living_user = user
	data["ritualism"] = skill_to_string(living_user.get_skill_level(/datum/skill/magic/ritualist))
	data["performing"] = performing_rite
	var/list/states = list()
	for(var/datum/runeritual/god/rite as anything in get_rite_datums())
		var/list/tile_states = list()
		var/list/selected_atoms = rite.match_layout(src, living_user)
		for(var/tile in selected_atoms)
			tile_states[tile] = !!selected_atoms[tile]
		states["[rite.type]"] = list(
			"locked" = rite.lock_reason(living_user, src),
			"cooldown_left" = S_TIMER_COOLDOWN_TIMELEFT(living_user, rite.type) || 0,
			"tile_states" = tile_states,
		)
	data["rite_states"] = states
	data["heretic"] = living_user.mind?.heretic_path?.menu_data()
	return data

/obj/structure/ritualcircle/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || action != "invoke")
		return
	var/mob/living/user = usr
	if(!istype(user) || performing_rite)
		return
	for(var/datum/runeritual/god/rite as anything in get_rite_datums())
		if("[rite.type]" != params["rite"] || rite.is_hidden(user, src))
			continue
		var/locked = rite.lock_reason(user, src)
		if(locked)
			rite.deny(user, src, locked)
			return
		if(!rite.check_layout(user, src))
			return
		ui.close()
		INVOKE_ASYNC(src, PROC_REF(invoke_rite), user, rite)
		return TRUE

/obj/effect/decal/cleanable/roguerune/god/can_invoke(mob/living/user, list/invokers)
	if(!istype(user.patron, allowed_patron))
		to_chat(user, span_warning("<i>I don't know the proper rites for this...</i>"))
		return FALSE
	return TRUE

/datum/status_effect/debuff/ritesexpended/on_apply()
	return FALSE

/datum/status_effect/debuff/ritesexpended_heavy/on_apply()
	return FALSE

/datum/status_effect/debuff/armamentrites/on_apply()
	return FALSE
