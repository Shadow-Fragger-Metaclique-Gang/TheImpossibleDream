/datum/sex_action/rub_horns
	name = "Rub their horns"
	check_same_tile = FALSE
	category = SEX_CATEGORY_HANDS
	target_sex_part = SEX_PART_HORNS

/datum/sex_action/rub_horns/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/rub_horns/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(user == target)
		return FALSE
	if(!user.sexcon.Adjacent_Or_Closet(target)) // Should fix the long range horn gropes...
		return FALSE
	return TRUE

/datum/sex_action/rub_horns/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] places [user.p_their()] hands on [target]'s horns..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/rub_horns/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)

	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = do_subtle

	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] rubs [target]'s horns..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

	user.sexcon.perform_sex_action(target, 0.5, 0, TRUE)

	user.sexcon.handle_passive_ejaculation(target)
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE

/datum/sex_action/rub_horns/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] stops rubbing [target]'s horns ..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/rub_horns/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
