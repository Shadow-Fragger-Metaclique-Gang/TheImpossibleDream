/datum/sex_action/lick_ears
	name = "Lick their ears"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_JAWS

/datum/sex_action/lick_ears/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return FALSE
	if(!user.sexcon.Adjacent_Or_Closet(target))
		return FALSE
	return TRUE

/datum/sex_action/lick_ears/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] places [user.p_their()] tongue against [target] ear..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/lick_ears/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	var/sensitive_ears = has_sensitive_ears(target) == TRUE || iself(target) || ishalfelf(target) || isdarkelf(target) || ishalforc(target) || isgoblinp(target) || isgnoll(target)
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = do_subtle

	if(sensitive_ears)
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] licks [target]'s ear... [target.p_their()] weakness..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] licks [target]'s ear..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

	if(!do_subtle)
		user.sexcon.make_sucking_noise()

	if(sensitive_ears)
		user.sexcon.perform_sex_action(target, 10, 0, TRUE)
	else
		user.sexcon.perform_sex_action(target, 1, 0, TRUE)

	target.sexcon.handle_passive_ejaculation(user)
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE

/datum/sex_action/lick_ears/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] stops licking [target]'s ear ..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/lick_ears/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
