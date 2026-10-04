/datum/sex_action/tailpegging_oral
	name = "Prod their throat with a tail"
	plaptext = "glck!"
	check_same_tile = FALSE
	stamina_cost = 1.0
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_JAWS
	user_sex_part = SEX_PART_TAIL

/datum/sex_action/tailpegging_oral/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] slides [user.p_their()] tail into [target]'s throat!"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/tailpegging_oral/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] prods [target]'s throat with [user.p_their()] tail..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.make_sucking_noise()

	user.sexcon.perform_sex_action(target, 3, 7, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/tailpegging_oral/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [user.p_their()] tail out of [target]'s throat."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/tailpegging_oral/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
