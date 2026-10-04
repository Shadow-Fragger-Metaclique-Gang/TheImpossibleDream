/datum/sex_action/stompjob
	name = "Stomp on them"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_BALLS

/datum/sex_action/stompjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return FALSE
	if(user.resting)
		return FALSE
	return TRUE

/datum/sex_action/stompjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return FALSE
	if(user.resting)
		return FALSE
	if(!target.resting)
		return FALSE
	return TRUE

/datum/sex_action/stompjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] puts [user.p_their()] feet on [target]..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/stompjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] stomps [target]'s balls with [user.p_their()] feet..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	playsound(user, 'sound/combat/hits/kick/stomp.ogg', 30, TRUE, (do_subtle ? -6 : -2), ignore_walls = FALSE)
	// and i had never had c hance to interact with the jesters...
	if(istype(user.shoes, /obj/item/clothing/shoes/roguetown/jester))
		playsound(user, SFX_JINGLE_BELLS, 30, TRUE, -2, ignore_walls = FALSE)

	if(istype(user.shoes, /obj/item/clothing/shoes/roguetown))
		user.sexcon.perform_sex_action(target, 2, 10, TRUE)
	else
		user.sexcon.perform_sex_action(target, 2, 4, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/stompjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [user.p_their()] feet off [target]..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/stompjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
