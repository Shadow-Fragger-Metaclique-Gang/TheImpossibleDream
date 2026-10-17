/datum/objective/heretic/graggar/culling
	name = "CULLING GAMES"
	heretic_tier = 3
	var/datum/culling_duel/heretic/duel
	var/seek_timer
	var/warned_no_contender = FALSE

/datum/objective/heretic/graggar/culling/update_explanation_text()
	explanation_text = "Another follower of GRAGGAR has been chosen to participate in a culling game. Hunt them down and eat their heart before they eat mine."

// Mostly a bootleg of the pre existing culling game god event
/datum/objective/heretic/graggar/culling/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HERETIC_CULLING_WIN, PROC_REF(on_culling_win))
		RegisterSignal(owner.current, COMSIG_HERETIC_CULLING_HEART_DESTROYED, PROC_REF(on_heart_destroyed))
	update_explanation_text()
	seek_contender()

/datum/objective/heretic/graggar/culling/Destroy()
	if(seek_timer)
		deltimer(seek_timer)
	duel = null
	if(owner?.current)
		UnregisterSignal(owner.current, list(COMSIG_HERETIC_CULLING_WIN, COMSIG_HERETIC_CULLING_HEART_DESTROYED))
	return ..()

/datum/objective/heretic/graggar/culling/proc/seek_contender()
	seek_timer = null
	var/mob/living/carbon/human/first_chosen = owner?.current
	if(completed || duel || QDELETED(first_chosen))
		return
	var/datum/culling_duel/heretic/existing = heretic_culling_duel_of(first_chosen)
	if(istype(existing)) // If we're already in a culling, officially join it
		join_culling(existing)
		return
	var/list/contenders = list()
	for(var/mob/living/carbon/human/candidate in GLOB.player_list)
		if(candidate == first_chosen || candidate.stat == DEAD || !candidate.client || !candidate.mind)
			continue
		if(!HAS_TRAIT(candidate, TRAIT_HORDE) || is_species(candidate, /datum/species/gnoll)) // No gnolls
			continue
		if(!candidate.getorganslot(ORGAN_SLOT_HEART) || heretic_culling_duel_of(candidate) || heretic_culling_area_blacklist(candidate)) // Check they're not already in a culling and aren't in a blacklisted area
			continue
		contenders += candidate
	if(!length(contenders) || !first_chosen.getorganslot(ORGAN_SLOT_HEART))
		if(!warned_no_contender)
			warned_no_contender = TRUE
			to_chat(first_chosen, span_cult("<i>GRAGGAR searches for prey worthy of me. I must wait.</i>"))
		seek_timer = addtimer(CALLBACK(src, PROC_REF(seek_contender)), 3 MINUTES, TIMER_STOPPABLE) // If we can't find a target, check again in three minutes
		return
	var/mob/living/carbon/human/second_chosen = pick(contenders)
	var/datum/culling_duel/heretic/new_duel = new(first_chosen, second_chosen)
	GLOB.graggar_cullings += new_duel
	join_culling(new_duel)
	new_duel.begin()

/datum/objective/heretic/graggar/culling/proc/join_culling(datum/culling_duel/heretic/new_duel)
	duel = new_duel
	if(seek_timer)
		deltimer(seek_timer)
		seek_timer = null

/datum/objective/heretic/graggar/culling/proc/on_culling_win(datum/source, mob/living/loser)
	SIGNAL_HANDLER
	duel = null
	complete()

/datum/objective/heretic/graggar/culling/proc/on_heart_destroyed(datum/source)
	SIGNAL_HANDLER
	duel = null
	warned_no_contender = FALSE
	seek_timer = addtimer(CALLBACK(src, PROC_REF(seek_contender)), 1 MINUTES, TIMER_STOPPABLE)

/datum/objective/heretic/graggar/culling/progress_text()
	if(!duel)
		return "GRAGGAR has yet to find me a worthy opponent."
	var/mob/living/rival = duel.challenger?.resolve() == owner.current ? duel.target?.resolve() : duel.challenger?.resolve()
	return rival ? "My opponent is [rival.real_name]!" : null

/datum/culling_duel/heretic // Override so we don't annihilate AP's culling games even though we're disabling it

/datum/culling_duel/heretic/proc/begin()
	var/mob/living/carbon/human/first_chosen = challenger.resolve()
	var/mob/living/carbon/human/second_chosen = target.resolve()
	var/first_chosen_location = first_chosen.prepare_deathsight_message()
	var/second_chosen_location = second_chosen.prepare_deathsight_message()

	first_chosen.add_stress(/datum/stressevent/graggar_culling_unfinished)
	first_chosen.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/extract_heart)
	var/obj/effect/proc_holder/spell/self/graggar_scent/first_scent = new
	first_scent.tracked = WEAKREF(second_chosen)
	first_chosen.mind.AddSpell(first_scent)
	add_verb(first_chosen, /mob/living/carbon/human/proc/remember_culling)
	to_chat(first_chosen, span_userdanger("MIGHT MAKES RIGHT! CONSUME THE WEAK!"))
	to_chat(first_chosen, span_red("The weak feed the strong. Eat the heart of [span_notice(second_chosen.real_name)], the [second_chosen.job], and take their strength. Fail, and YOU will be the one eaten instead!"))
	to_chat(first_chosen, span_red("[span_notice(second_chosen.real_name)] is somewhere in [span_notice(second_chosen_location)]. Follow their scent."))
	first_chosen.playsound_local(first_chosen, 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE)
	var/datum/objective/heretic/graggar/culling/first_objective = first_chosen.mind?.heretic_path?.current_objective
	if(istype(first_objective))
		first_objective.join_culling(src)

	second_chosen.add_stress(/datum/stressevent/graggar_culling_unfinished)
	second_chosen.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/extract_heart)
	var/obj/effect/proc_holder/spell/self/graggar_scent/second_scent = new
	second_scent.tracked = WEAKREF(first_chosen)
	second_chosen.mind.AddSpell(second_scent)
	add_verb(second_chosen, /mob/living/carbon/human/proc/remember_culling)
	to_chat(second_chosen, span_userdanger("A GREAT HUNT BEGINS!"))
	to_chat(second_chosen, span_red("You have been marked for culling by GRAGGAR! Eat the heart of [span_notice(first_chosen.real_name)], the [first_chosen.job], and take their strength before they do the same to YOU!"))
	to_chat(second_chosen, span_red("[span_notice(first_chosen.real_name)] is somewhere in [span_notice(first_chosen_location)]. Follow their scent."))
	second_chosen.playsound_local(second_chosen, 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE)
	var/datum/objective/heretic/graggar/culling/second_objective = second_chosen.mind?.heretic_path?.current_objective
	if(istype(second_objective))
		second_objective.join_culling(src)

// AP culling games gives an omnistat boost and triumphs to the winner and a stat penalty to the loser
// Also AP inexplicably annihilates your stats if your heart gets destroyed instead of being eaten for whatever reason??????????
/datum/culling_duel/heretic/process_win(mob/living/winner, mob/living/loser)
	winner.remove_stress(/datum/stressevent/graggar_culling_unfinished)
	remove_verb(winner, /mob/living/carbon/human/proc/remember_culling)
	winner.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/extract_heart)
	winner.mind?.RemoveSpell(/obj/effect/proc_holder/spell/self/graggar_scent)
	if(!is_species(loser, /datum/species/gnoll)) // For the tier four gnoll variant, don't grant culling game victory stats for eating the gnoll's heart
		winner.change_stat(STATKEY_STR, 1)
		winner.change_stat(STATKEY_WIL, 1)
		winner.change_stat(STATKEY_CON, 1)
	to_chat(winner, span_danger("THE GORESTAR SMILES UPON ME! Victory is mine, and with it comes the strength of the conquered!"))
	winner.add_stress(/datum/stressevent/graggar_culling_finished)
	winner.playsound_local(winner, 'sound/magic/marked.ogg', 100)
	SEND_SIGNAL(winner, COMSIG_HERETIC_CULLING_WIN, loser)

	if(loser)
		loser.remove_stress(/datum/stressevent/graggar_culling_unfinished)
		remove_verb(loser, /mob/living/carbon/human/proc/remember_culling)
		loser.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/extract_heart)
		loser.mind?.RemoveSpell(/obj/effect/proc_holder/spell/self/graggar_scent)
		to_chat(loser, span_boldred("MY HEART! THE GORESTAR LAUGHS AT MY FAILURE!"))
		loser.mind?.lose_heretic_awakening()

	qdel(src)

/datum/culling_duel/heretic/handle_heart_destroyed(which_heart)
	var/mob/living/carbon/human/winner
	var/mob/living/carbon/human/loser

	if(which_heart == "target")
		winner = challenger.resolve()
		loser = target.resolve()
	else if(which_heart == "challenger")
		winner = target.resolve()
		loser = challenger.resolve()

	if(winner)
		winner.remove_stress(/datum/stressevent/graggar_culling_unfinished)
		remove_verb(winner, /mob/living/carbon/human/proc/remember_culling)
		winner.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/extract_heart)
		winner.mind?.RemoveSpell(/obj/effect/proc_holder/spell/self/graggar_scent)
		to_chat(winner, span_red("My rival's heart has been destroyed. I have been denied my feast, but the hunt will begin anew soon..."))
		SEND_SIGNAL(winner, COMSIG_HERETIC_CULLING_HEART_DESTROYED)
	if(loser)
		loser.remove_stress(/datum/stressevent/graggar_culling_unfinished)
		remove_verb(loser, /mob/living/carbon/human/proc/remember_culling)
		loser.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/extract_heart)
		loser.mind?.RemoveSpell(/obj/effect/proc_holder/spell/self/graggar_scent)
		to_chat(loser, span_boldred("MY HEART! THE GORESTAR LAUGHS AT MY FAILURE!"))
		loser.mind?.lose_heretic_awakening()

	qdel(src)

/obj/item/organ/heart/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	for(var/datum/culling_duel/heretic/duel in GLOB.graggar_cullings)
		if(duel.challenger_heart?.resolve() == src || duel.target_heart?.resolve() == src)
			var/mob/living/challenger = duel.challenger?.resolve()
			var/mob/living/target = duel.target?.resolve()
			challenger?.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/extract_heart)
			target?.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/extract_heart)

/proc/heretic_culling_duel_of(mob/living/contender)
	for(var/datum/culling_duel/duel in GLOB.graggar_cullings)
		if(duel.challenger?.resolve() == contender || duel.target?.resolve() == contender)
			return duel

/proc/heretic_culling_area_blacklist(mob/living/target)
	var/static/list/excluded_areas = list(
		/area/rogue/indoors/town/cell, // I think only on Lyndvhar actually
		/area/rogue/under/town/basement/keep, // Don't target a guy in the dungeons
		/area/rogue/indoors/inq, // Don't target a guy in the INQUISITION'S dungeons
		/area/rogue/indoors/town/tavern, // ERP safe zone
		/area/rogue/indoors/banditcamp, // Be for real
		/area/rogue/outdoors/banditcamp,
		/area/rogue/outdoors/woods/wretch_lair, // Be for real
		/area/rogue/under/cave/inhumen,
	)
	var/area/target_area = get_area(target)
	for(var/excluded in excluded_areas)
		if(istype(target_area, excluded))
			return TRUE
	return FALSE

// Used for the tier four culling games that spawns either a gnoll or an assassin
/datum/objective/heretic/graggar/culling/proc/spawn_hunter(mob/candidate, rank, class_tag)
	if(!istype(candidate, /mob/dead))
		return
	if(istype(candidate, /mob/dead/new_player))
		var/mob/dead/new_player/new_player = candidate
		new_player.close_spawn_windows()
	var/turf/spawn_turf
	for(var/obj/effect/landmark/start/start_landmark in GLOB.start_landmarks_list)
		if(start_landmark.name == rank)
			spawn_turf = get_turf(start_landmark)
			break
	var/mob/living/carbon/human/hunter = new(spawn_turf)
	if(!spawn_turf)
		SSjob.SendToLateJoin(hunter)
	hunter.key = candidate.key
	hunter.load_char_or_namechoice()
	if(QDELETED(hunter))
		return
	SSjob.EquipRank(hunter, rank, TRUE)
	var/list/class_tags = list()
	class_tags[class_tag] = 20
	SSrole_class_handler.setup_class_handler(hunter, class_tags)
	return hunter

/obj/effect/proc_holder/spell/invoked/extract_heart/cast(list/targets, mob/living/user)
	. = ..()
	if(.)
		user.playsound_local(user, 'modular_tidi/heretics/sound/heart_tear.ogg', 100, FALSE)

/obj/effect/proc_holder/spell/self/graggar_scent
	name = "Scent of the Prey"
	desc = "The nose of a GRAGGAR beest allows me to track my prey from afar."
	overlay_icon = 'icons/mob/actions/gnollmiracles.dmi'
	action_icon = 'icons/mob/actions/gnollmiracles.dmi'
	overlay_state = "sniff"
	action_icon_state = "sniff"
	recharge_time = 5 SECONDS
	antimagic_allowed = TRUE
	ignore_cockblock = TRUE
	range = -1
	var/datum/weakref/tracked

/obj/effect/proc_holder/spell/self/graggar_scent/cast(list/targets, mob/user)
	. = ..()
	var/mob/living/prey = tracked?.resolve()
	if(!prey || QDELETED(prey))
		to_chat(user, span_warning("The scent has gone cold."))
		return
	var/turf/user_turf = get_turf(user)
	var/turf/prey_turf = get_turf(prey)
	var/area/prey_area = get_area(prey_turf)
	if(prey_area?.area_sniff_message)
		to_chat(user, span_notice(prey_area.area_sniff_message))
	if(user_turf.z != prey_turf.z)
		to_chat(user, span_notice("The scent of [prey.real_name] drifts from [user_turf.z > prey_turf.z ? "below" : "above"] me."))
		return
	var/dist = get_dist(user, prey)
	var/dir_text = dir2text(get_dir(user, prey))
	if(dist <= 1)
		to_chat(user, span_boldnotice("The prey is right here! Blood and steel!"))
	else if(dist < 10)
		to_chat(user, span_notice("The scent is thick to the [dir_text]. They are very close."))
	else
		to_chat(user, span_notice("I catch a faint whiff of [prey.real_name] to the [dir_text]."))

/datum/round_event_control/graggar_culling
	weight = 0

/datum/round_event_control/graggar_culling/canSpawnEvent(players_amt, gamemode, fake_check)
	return FALSE
