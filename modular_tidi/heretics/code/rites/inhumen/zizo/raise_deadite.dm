/mob/living
	var/datum/weakref/ritual_skeleton

/datum/runeritual/god/zizo/raise_deadite
	name = "Raise Deadite"
	desc = "Raises the corpse upon the rune as a greater deadite that serves me, one able to fight as it did in lyfe. The lyving may be given to the rune as well. With no corpse, a greater skeleton answers instead, should a soul be found."
	tier = SKILL_LEVEL_JOURNEYMAN
	layout = list(
		"NW" = /obj/item/natural/bone,
		"NE" = /obj/item/natural/bone,
		"SW" = /obj/item/natural/bone,
		"S" = list(/obj/item/reagent_containers/lux, /obj/item/reagent_containers/lux_impure),
		"SE" = /obj/item/natural/bone,
	)
	banned_atom_types = list(/obj/item/reagent_containers/lux/moss, /obj/item/reagent_containers/lux/eoran_aril)
	chant_lines = list(
		"ZIZO! ZIZO! HARBINGER OF AMBITION! THIEF OF THE DEAD'S STILLNESS!",
		"ZIZO! ZIZO! FILL THE DEAD WITH BREATH AND VIGOR TO WALK AGAIN!",
		"ZIZO! ZIZO! LET THE DEAD RISE AND SERVE!",
	)

/datum/runeritual/god/zizo/raise_deadite/perform(mob/living/user, obj/structure/ritualcircle/zizo/circle)
	var/mob/living/carbon/human/vessel = find_vessel(user, circle)
	if(!can_raise(user, circle, vessel))
		return FALSE
	if(!check_layout(user, circle))
		return FALSE
	if(!chant(user, circle))
		return FALSE
	if(find_vessel(user, circle) != vessel || !can_raise(user, circle, vessel))
		return FALSE
	var/list/selected_atoms = check_layout(user, circle)
	if(!selected_atoms)
		return FALSE
	if(vessel)
		return raise_greater_deadite(user, circle, vessel, selected_atoms)
	return raise_skeleton(user, circle, selected_atoms)

/datum/runeritual/god/zizo/raise_deadite/proc/find_vessel(mob/living/user, obj/structure/ritualcircle/circle)
	for(var/mob/living/carbon/human/body in get_turf(circle))
		if(body != user)
			return body

/datum/runeritual/god/zizo/raise_deadite/proc/can_raise(mob/living/user, obj/structure/ritualcircle/circle, mob/living/carbon/human/vessel)
	var/problem
	if(!vessel)
		var/mob/living/skeleton = user.ritual_skeleton?.resolve()
		if(skeleton && !QDELETED(skeleton) && skeleton.stat != DEAD)
			problem = "My skeleton still walks."
	else if(!vessel.mind)
		problem = "[vessel] has no soul to call back."
	else if(HAS_TRAIT(vessel, TRAIT_ZOMBIE_IMMUNE))
		problem = "[vessel] is warded against the rot."
	else
		var/datum/antagonist/zombie/deadite = vessel.mind.has_antag_datum(/datum/antagonist/zombie)
		if(istype(deadite) && deadite.has_turned)
			problem = "[vessel] is already a deadite."
		for(var/claimed_by in list(/datum/antagonist/vampire, /datum/antagonist/werewolf, /datum/antagonist/skeleton, /datum/antagonist/gnoll))
			if(vessel.mind.has_antag_datum(claimed_by))
				problem = "[vessel]'s soul is already claimed by another unlyfe."
	if(problem)
		deny(user, circle, problem)
		return FALSE
	return TRUE

/datum/runeritual/god/zizo/raise_deadite/proc/raise_greater_deadite(mob/living/user, obj/structure/ritualcircle/circle, mob/living/carbon/human/vessel, list/selected_atoms)
	var/datum/mind/vessel_mind = vessel.mind
	if(vessel_mind.has_antag_datum(/datum/antagonist/zombie))
		vessel_mind.remove_antag_datum(/datum/antagonist/zombie)
	cleanup_atoms(selected_atoms)
	circle.icon_state = "zizo_active"
	addtimer(VARSET_CALLBACK(circle, icon_state, "zizo_chalky"), 12 SECONDS)
	playsound(get_turf(vessel), 'sound/magic/magnet.ogg', 80, TRUE, soundping = TRUE)
	if(vessel.stat != DEAD)
		vessel.visible_message(span_danger("The rune drags the lyfe out of [vessel]!"))
	var/datum/antagonist/zombie/greater/deadite = new
	deadite.master = WEAKREF(user)
	vessel_mind.add_antag_datum(deadite)
	deadite.wake_zombie(vessel.stat != DEAD)
	if(QDELETED(deadite) || !deadite.has_turned)
		return FALSE
	SEND_SIGNAL(user, COMSIG_HERETIC_DEADITE_RAISED, vessel)
	return TRUE

/datum/runeritual/god/zizo/raise_deadite/proc/raise_skeleton(mob/living/user, obj/structure/ritualcircle/circle, list/selected_atoms)
	var/turf/rune_turf = get_turf(circle)
	var/list/candidates = pollGhostCandidates("Do you want to play as a greater skeleton serving [user.real_name]?", ROLE_LICH_SKELETON, null, null, 10 SECONDS, POLL_IGNORE_LICH_SKELETON)
	if(!LAZYLEN(candidates))
		deny(user, circle, "The depths are hollow.")
		return FALSE
	var/mob/candidate = pick(candidates)
	if(!istype(candidate, /mob/dead))
		return FALSE
	if(istype(candidate, /mob/dead/new_player))
		var/mob/dead/new_player/new_player = candidate
		new_player.close_spawn_windows()
	cleanup_atoms(selected_atoms)
	circle.icon_state = "zizo_active"
	addtimer(VARSET_CALLBACK(circle, icon_state, "zizo_chalky"), 12 SECONDS)
	var/mob/living/carbon/human/species/skeleton/no_equipment/skeleton = new(rune_turf)
	skeleton.key = candidate.key
	SSjob.EquipRank(skeleton, "Greater Skeleton", TRUE)
	skeleton.copy_known_languages_from(user, TRUE)
	skeleton.visible_message(span_warning("[skeleton]'s eyes light up with an eerie glow!"))
	to_chat(skeleton, span_narsie("[user.real_name] called me from the depths. I serve [user.p_them()]."))
	addtimer(CALLBACK(skeleton, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "GREATER SKELETON"), 3 SECONDS)
	addtimer(CALLBACK(skeleton, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)
	addtimer(CALLBACK(skeleton, TYPE_PROC_REF(/mob/living/carbon/human, select_skeleton_features)), 7 SECONDS)
	user.ritual_skeleton = WEAKREF(skeleton)
	return TRUE

/datum/antagonist/zombie/greater
	name = "Greater Deadite"
	var/datum/weakref/master

/datum/antagonist/zombie/greater/transform_zombie()
	. = ..()
	var/mob/living/carbon/human/zombie = owner?.current
	if(!zombie || zombie.stat == DEAD)
		return
	REMOVE_TRAIT(zombie, TRAIT_CHUNKYFINGERS, "[type]")
	zombie.base_intents = base_intents
	zombie.update_a_intents()
	var/mob/living/raiser = master?.resolve()
	if(raiser)
		to_chat(zombie, span_narsie("[raiser.real_name] called me back. I serve [raiser.p_them()]."))
