// [SURREALIS-EDIT] - VRCOMBAT
// /proc/remove_rot(mob/living/carbon/human/target, mob/living/user, method = "unknown", damage = 0, success_message = "The rot is removed.", fail_message = "The rot removal failed.", lethal = TRUE) // SURREALIS-EDIT - ORIGINAL
/proc/remove_rot(mob/living/carbon/human/target, mob/living/user, method = "unknown", damage = 0, success_message = "The rot is removed.", fail_message = "The rot removal failed.", lethal = TRUE, cure_flesh = TRUE)
// [/SURREALIS-EDIT]
	if (!istype(target, /mob/living/carbon/human) || QDELETED(target))
		return FALSE

	//Special check preventing skeletons being cautery burned to regrow flesh
	if(istype(target, /mob/living/carbon/human/species/skeleton) && method == "surgery")
		to_chat(user, span_warning("It's going to take a miracle to put flesh back on these bones."))
		return FALSE

	// Check if the target has rot
	var/has_rot = FALSE
	var/datum/antagonist/zombie/was_zombie = target.mind?.has_antag_datum(/datum/antagonist/zombie)

	// [SURREALIS-EDIT] - VRCOMBAT
	// SURREALIS-EDIT - ORIGINAL
	/*
	if (was_zombie)
		has_rot = TRUE
	else if (istype(target, /mob/living/carbon))
		has_rot = check_bodyparts_for_rot(target)
	else if (target.has_status_effect(/datum/status_effect/zombie_infection))
		has_rot = TRUE
	*/
	if (was_zombie || target.has_status_effect(/datum/status_effect/zombie_infection))
		has_rot = TRUE
	else
		has_rot = check_bodyparts_for_rot(target)
	// [/SURREALIS-EDIT]

	// Remove rot component
	remove_rot_component(target)

	// Remove Infected var
	target.infected = FALSE
	target.remove_status_effect(/datum/status_effect/zombie_infection)

	// Clean body parts
	// [SURREALIS-EDIT] - VRCOMBAT
	// clean_body_parts(target) // SURREALIS-EDIT - ORIGINAL
	clean_body_parts(target, cure_flesh)
	// [/SURREALIS-EDIT]

	// Handle failure case
	if (!has_rot)
		to_chat(user, span_warning(fail_message))
		return FALSE

	// [SURREALIS-ADD] - VRCOMBAT
	if (was_zombie && !cure_flesh)
		was_zombie.keep_flesh_rot = TRUE
	// [/SURREALIS-ADD]
	if (was_zombie)
		remove_zombie_antag(target, user, method, lethal)

	//Doing it out of this proc for now
	//to_chat(user, span_notice(success_message))

	return TRUE

/proc/check_bodyparts_for_rot(mob/living/carbon/target)
	for (var/obj/item/bodypart/bodypart in target.bodyparts)
		if (bodypart.rotted || bodypart.skeletonized)
			return TRUE
	return FALSE


/proc/remove_zombie_antag(mob/living/carbon/target, mob/living/user, method, lethal = TRUE)
	var/datum/antagonist/zombie/was_zombie = target.mind?.has_antag_datum(/datum/antagonist/zombie)
	if (!was_zombie)
		return

	was_zombie.become_rotman = FALSE
	if(!lethal)
		target.Unconscious(20 SECONDS)
		target.emote("breathgasp")
		target.Jitter(100)
	else if(was_zombie.has_turned)
		target.death(nocutscene = TRUE)
	target.mind.remove_antag_datum(/datum/antagonist/zombie)

	if (!HAS_TRAIT(target, TRAIT_IWASUNZOMBIFIED) && user?.ckey)
		adjust_playerquality(PQ_GAIN_UNZOMBIFY, user.ckey)
		ADD_TRAIT(target, TRAIT_IWASUNZOMBIFIED, "[method]")

///Removes the rot amount from the target
/proc/remove_rot_component(mob/living/carbon/target)
	var/datum/component/rot/rot = target.GetComponent(/datum/component/rot)
	if (rot)
		rot.amount = 0
		rot.soundloop.stop()

///Cure bodyparts
// [SURREALIS-EDIT] - VRCOMBAT
// /proc/clean_body_parts(mob/living/carbon/target) // SURREALIS-EDIT - ORIGINAL
/proc/clean_body_parts(mob/living/carbon/target, cure_flesh = TRUE)
// [/SURREALIS-EDIT]

	for (var/obj/item/bodypart/bodypart in target.bodyparts)
		// [SURREALIS-EDIT] - VRCOMBAT
		// SURREALIS-EDIT - ORIGINAL
		/*
		bodypart.rotted = FALSE
		bodypart.skeletonized = FALSE
		*/
		if(cure_flesh)
			bodypart.cure_rot()
		// [/SURREALIS-EDIT]
		bodypart.update_limb()
		bodypart.update_disabled()

	if(ishuman(target))
		var/mob/living/carbon/human/H = target

		if(H.client && H.client.prefs)
			H.skin_tone = H.client.prefs.skin_tone

		else if(H.original_skin_tone)
			H.skin_tone = H.original_skin_tone
			H.original_skin_tone = null

	target.update_body()
