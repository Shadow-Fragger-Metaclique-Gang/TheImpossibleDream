/mob/living/proc/start_sex_session(mob/living/target)
	sexcon.start(target)

/obj/item/bodypart/head/dullahan/proc/check_closest_zones(mob/living/carbon/human/target)
	var/mob/living/carbon/human/user = original_owner
	var/datum/species/dullahan/user_species = user.dna.species
	var/list/acceptable = list()
	if(!user_species.headless)
		return FALSE
	var/datum/sex_controller/target_con = target.sexcon
	var/check_con = FALSE
	if(target.is_holding(src))
		var/obj/item/bodypart/holding_bodypart = target.get_holding_bodypart_of_item(src)
		// Someone will have to maintain this if they add more than two hands.
		// However at that point they have bigger problems.
		acceptable += holding_bodypart.aux_zone
		check_con = TRUE
	if(get_turf(src) == get_turf(target))
		check_con = TRUE

	if(check_con && target_con.target == user)
		acceptable += target_con.using_zones

	return user.zone_selected in acceptable
