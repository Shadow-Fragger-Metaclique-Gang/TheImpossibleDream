/datum/preferences
	var/list/quirks = list()

/datum/charflaw
	var/point_value = 1 // Quirk points granted by this vice. Insignificant vices set this to zero.

/datum/charflaw/constant_ui_data()
	var/list/data = ..()
	data["point_value"] = point_value
	return data

/datum/charflaw/noflaw
	point_value = 0 // Not a flaw.

/datum/charflaw/badsight
	point_value = 2

/datum/charflaw/clingy
	point_value = 0 // Most popular flaw and it's barely considered one. No points for being wholly inconsequential.

/datum/charflaw/noeyer
	point_value = 2

/datum/charflaw/noeyel
	point_value = 2

/datum/charflaw/noeyeall
	point_value = 2

/datum/charflaw/colorblind
	point_value = 2

/datum/charflaw/unintelligible
	point_value = 2

/datum/charflaw/narcoleptic
	point_value = 2

/datum/charflaw/sleepless
	point_value = 2

/datum/charflaw/mute
	point_value = 2

/datum/charflaw/critweakness
	point_value = 2

/datum/charflaw/leprosy
	name = "Leper"
	point_value = 2

/datum/charflaw/mind_broken
	name = "Asundered Mind"
	point_value = 2

/datum/charflaw/wanted
	name = "Wanted"

/datum/charflaw/limbloss/arm_l
	point_value = 2

/datum/charflaw/limbloss/arm_r
	point_value = 2

/mob/living/carbon/human
	var/unspent_quirk_points = 0

// Quirk points gained from selected vices. Your first vice doesn't give any at all.
/datum/preferences/proc/get_quirk_points_earned()
	var/points = 0
	for(var/i = 2 to length(charflaws))
		var/datum/charflaw/vice = GLOB.character_flaws_singletons[charflaws[i]]
		if(vice)
			points += vice.point_value
	return points

/datum/preferences/proc/get_quirk_points_spent()
	var/points = 0
	for(var/datum/quirk/Q in quirks)
		if(Q)
			points += Q.point_cost
	return points

/datum/preferences/proc/get_quirk_points_remaining()
	return get_quirk_points_earned() - get_quirk_points_spent()

// For when you don't have enough quirk points, you can pay the collateral with triumphs
/datum/preferences/proc/get_triumph_collateral()
	var/remaining = get_quirk_points_remaining()
	if(remaining >= 0)
		return 0
	return -remaining * 2

/datum/preferences/proc/get_quirk_typepaths()
	var/list/types = list()
	for(var/datum/quirk/Q in quirks)
		if(Q)
			types += Q.type
	return types

/datum/preferences/proc/has_quirk(quirk_typepath)
	for(var/datum/quirk/Q in quirks)
		if(Q && Q.type == quirk_typepath)
			return TRUE
	return FALSE

/datum/preferences/proc/quirk_pick_error(datum/quirk/Q)
	if(LAZYLEN(Q.restricted_species) && (pref_species.type in Q.restricted_species))
		return "Restricted from species \"[pref_species.name]\"."
	if(LAZYLEN(Q.allowed_species) && !(pref_species.type in Q.allowed_species))
		var/exempt = FALSE
		if(LAZYLEN(Q.allowed_virtues) && ((virtue?.type in Q.allowed_virtues) || (statpack.virtuous && (virtuetwo?.type in Q.allowed_virtues))))
			exempt = TRUE
		for(var/datum/quirk/other in quirks)
			if(other.type in Q.allowed_quirks)
				exempt = TRUE
		if(!exempt)
			var/out = "Only allowed for species: "
			for(var/datum/species/S as anything in Q.allowed_species)
				if(ispath(S, /datum/species))
					out += "[S::name], "
			out = copytext(out, 1, -2)
			var/without = "without"
			if(length(Q.allowed_virtues))
				out += ", without an exempting virtue: "
				for(var/datum/virtue/V as anything in Q.allowed_virtues)
					out += "[V::name], "
				out = copytext(out, 1, -2)
				without = "or"
			if(length(Q.allowed_quirks))
				out += ", [without] an exempting quirk: "
				for(var/datum/quirk/QU as anything in Q.allowed_quirks)
					out += "[QU::name], "
				out = copytext(out, 1, -2)
			return (out + ".")
	var/datum/virtue/conflicting_virtue = check_quirk_virtue_conflict(Q.type)
	if(conflicting_virtue)
		return "[Q.name] conflicts with [conflicting_virtue.name]!"
	var/datum/charflaw/conflicting_vice = check_pick_vice_conflict(Q.type)
	if(conflicting_vice)
		return "[Q.name] conflicts with [conflicting_vice.name] vice!"
	var/datum/quirk/conflicting_quirk = check_pick_quirk_conflict(Q.type)
	if(conflicting_quirk)
		return "[Q.name] conflicts with [conflicting_quirk.name]!"
	return null

/datum/preferences/proc/check_pick_vice_conflict(pick_type, show_message = FALSE, mob/user = null)
	var/datum/quirk/pick = GLOB.quirks[pick_type]
	if(!pick || !length(pick.incompatible_vices))
		return FALSE
	for(var/flaw_type in charflaws)
		var/datum/charflaw/vice = GLOB.character_flaws_singletons[flaw_type]
		if(vice && (vice.type in pick.incompatible_vices))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name] conflicts with [vice.name] vice!"))
			return vice
	return FALSE

/datum/preferences/proc/check_pick_quirk_conflict(pick_type, show_message = FALSE, mob/user = null)
	var/datum/quirk/pick = GLOB.quirks[pick_type]
	if(!pick)
		return FALSE
	for(var/datum/quirk/Q in quirks)
		if(!Q || Q.type == pick_type)
			continue
		if(length(pick.incompatible_quirks) && (Q.type in pick.incompatible_quirks))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name] conflicts with [Q.name]!"))
			return Q
		if(length(Q.incompatible_quirks) && (pick_type in Q.incompatible_quirks))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name] conflicts with [Q.name]!"))
			return Q
	return FALSE

/datum/preferences/proc/check_vice_pick_conflict(vice_type, show_message = FALSE, mob/user = null)
	if(!vice_type)
		return FALSE
	for(var/datum/quirk/pick in quirks)
		if(length(pick.incompatible_vices) && (vice_type in pick.incompatible_vices))
			if(show_message && user)
				var/datum/charflaw/vice = GLOB.character_flaws_singletons[vice_type]
				to_chat(user, span_warning("[vice?.name || "This vice"] conflicts with [pick.name]!"))
			return pick
	return FALSE

/datum/preferences/proc/check_quirk_virtue_conflict(quirk_type, show_message = FALSE, mob/user = null)
	var/datum/quirk/pick = GLOB.quirks[quirk_type]
	if(!pick)
		return FALSE
	for(var/datum/virtue/virt in list(virtue, statpack.virtuous ? virtuetwo : null))
		if(virt && (virt.type in pick.incompatible_virtues))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name] conflicts with [virt.name]!"))
			return virt
	return FALSE

/datum/preferences/proc/check_virtue_quirk_conflict(virtue_type, show_message = FALSE, mob/user = null)
	var/datum/virtue/pick = GLOB.virtues[virtue_type]
	for(var/datum/quirk/Q in quirks)
		if(Q && (virtue_type in Q.incompatible_virtues))
			if(show_message && user)
				to_chat(user, span_warning("[pick?.name] conflicts with [Q.name]!"))
			return Q
	return FALSE

/datum/preferences/_load_quirk(S)
	var/list/quirk_types
	S["quirks"] >> quirk_types
	S["malodorous_scent"] >> malodorous_scent
	malodorous_scent = sanitize_text(malodorous_scent, "")

	quirks = list()
	if(!islist(quirk_types))
		return
	for(var/quirk_type in quirk_types)
		if(ispath(quirk_type, /datum/quirk))
			quirks += new quirk_type()

/datum/preferences/save_character()
	. = ..()
	if(!.)
		return
	var/savefile/S = new /savefile(path)
	S.cd = "/character[default_slot]"
	WRITE_FILE(S["quirks"], get_quirk_typepaths())
	WRITE_FILE(S["malodorous_scent"], malodorous_scent)

// Quirks are paid for with quirk points first, then real TRIUMPH for any shortfall at two per point.
// Skip a quirk if your untriumphant broke ass still can't afford it. Bank excess points for the roundend rebate.
/proc/surrealis_apply_prefs_quirks(mob/living/carbon/human/character, client/player)
	if(!player)
		player = character.client
	if(isnull(player))
		return
	if(!player.prefs)
		return

	var/datum/job/job = SSjob.GetJob(character.job)
	var/available_points = player.prefs.get_quirk_points_earned()
	var/triumphs_spent = 0
	for(var/datum/quirk/Q in player.prefs.quirks)
		if(job && length(job.quirk_restrictions) && (Q.type in job.quirk_restrictions))
			to_chat(character, span_warning("My duties as \a [character.job] leave no room for [Q.name]. It will not be applied."))
			continue
		var/pick_error = player.prefs.quirk_pick_error(Q)
		if(pick_error)
			to_chat(character, "Incorrect [Q.name] parameters! ([pick_error]) It will not be applied.")
			continue
		var/conflicting_trait = Q.blocked_by_incompatible_traits(character)
		if(conflicting_trait)
			to_chat(character, span_warning("[Q.name] conflicts with [conflicting_trait], something I already have. It will not be applied."))
			continue

		if(available_points >= Q.point_cost)
			available_points -= Q.point_cost
		else
			var/points_short = Q.point_cost - available_points
			var/triumph_cost = points_short * 2
			if(character.get_triumphs() < triumphs_spent + triumph_cost)
				continue
			triumphs_spent += triumph_cost
			available_points = 0
		surrealis_apply_quirk(character, Q)

	if(triumphs_spent)
		character.adjust_triumphs(-triumphs_spent, FALSE)
	character.unspent_quirk_points = available_points

/datum/controller/subsystem/ticker/declare_completion()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat != DEAD)
			if(H.unspent_quirk_points > 0)
				to_chat(H, "\n<font color='purple'>TRIUMPH[H.unspent_quirk_points > 1 ? "S" : ""] AWARDED for [H.unspent_quirk_points] unspent quirk point[H.unspent_quirk_points > 1 ? "s" : ""].</font>")
				H.playsound_local(get_turf(H), 'sound/misc/notice (2).ogg', 100, FALSE, pressure_affected = FALSE)
				H.adjust_triumphs(H.unspent_quirk_points)
				H.unspent_quirk_points = 0
	return ..()
