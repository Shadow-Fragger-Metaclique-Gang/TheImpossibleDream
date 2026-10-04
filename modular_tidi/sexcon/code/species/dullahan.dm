/datum/species/dullahan/New()
	. = ..()
	customizers += list(
		/datum/customizer/bodypart_feature/pits,
		/datum/customizer/bodypart_feature/pubes,
		/datum/customizer/organ/tail/manticore,
	)

/datum/species/dullahan/on_erp_location_accessible(datum/source, list/check_args)
	// Allows Dullahan heads but not necro.
	var/obj/item/bodypart/bodypart = check_args[ERP_BODYPART]
	var/mob/living/carbon/human/target = check_args[ERP_TARGET]
	var/mob/living/carbon/human/user = check_args[ERP_USER]
	var/self_target = check_args[ERP_SELF_TARGET]
	var/datum/sex_action/action = check_args[ERP_ACTION]

	var/success_flags = 0
	// This datum is the user, get target's species.
	if(check_zone(check_args[ERP_LOCATION]) == BODY_ZONE_HEAD && !bodypart && isdullahan(target))
		var/datum/species/dullahan/dullahan = target.dna.species
		bodypart = dullahan.my_head

		// Not close to the bodypart they want to interact with.
		var/same_tile = (get_turf(bodypart) == get_turf(user))
		if(!same_tile && !user.is_holding(bodypart))
			return SIG_CHECK_FAIL
		success_flags |= SKIP_ADJACENCY_CHECK
	check_args[ERP_BODYPART] = bodypart

	if(action.check_same_tile && (user != target || self_target))
		var/same_tile = (get_turf(user) == get_turf(target))
		var/grab_bypass = (action.aggro_grab_instead_same_tile && user.get_highest_grab_state_on(target) == GRAB_AGGRESSIVE)
		var/same_tile_bodypart = (get_turf(bodypart) == get_turf(user)) || user.is_holding(bodypart)

		if(!same_tile && !grab_bypass && !same_tile_bodypart)
			return SIG_CHECK_FAIL
		success_flags |= SKIP_TILE_CHECK

	if(action.require_grab && (user != target || self_target))
		var/grabstate = user.get_highest_grab_state_on(target)

		if((grabstate == null || grabstate < action.required_grab_state) && !user.is_holding(bodypart))
			return SIG_CHECK_FAIL
		success_flags |= SKIP_GRAB_CHECK

	return success_flags
