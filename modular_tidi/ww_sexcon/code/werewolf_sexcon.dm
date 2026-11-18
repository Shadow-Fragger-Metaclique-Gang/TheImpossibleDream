
/datum/sex_controller/update_erect_state()
	..()
	if(user.mind)
		var/datum/antagonist/werewolf/W = user.mind.has_antag_datum(/datum/antagonist/werewolf/)
		if(W && W.transformed == TRUE)
			user.regenerate_icons()

/datum/species/werewolf/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'modular_tidi/ww_sexcon/icons/werewolf.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	if(H.gender == MALE)
		H.icon_state = "wwolf_m"
	else
		H.icon_state = "wwolf_f"
	if(H.getorganslot(ORGAN_SLOT_PENIS)) //gock compatible
		if(H.sexcon.arousal >= 20 && H.sexcon.manual_arousal == 1 || H.sexcon.manual_arousal == 4)
			H.icon_state = "wwolf_m-e"
		else if(H.sexcon.arousal >= 10 && H.sexcon.manual_arousal == 1 || H.sexcon.manual_arousal == 3)
			H.icon_state = "wwolf_m-p"
		else
			H.icon_state = "wwolf_m"
	H.update_damage_overlays()
	return TRUE
/* Leaving this copy of the old code here for reuse later.

	if(H.gender == MALE)
		H.icon_state = "wwolf_m"
	else
		H.icon_state = "wwolf_f"
	if(H.getorganslot(ORGAN_SLOT_PENIS)) //gock compatible
		H.cut_overlays()
		var/image/benis = image(icon = H.icon)
		if(H.sexcon.arousal >= 20 && H.sexcon.manual_arousal == 1 || H.sexcon.manual_arousal == 4)
			benis.icon_state = "wwolf_benis-e"
		else if(H.sexcon.arousal >= 10 && H.sexcon.manual_arousal == 1 || H.sexcon.manual_arousal == 3)
			benis.icon_state = "wwolf_benis-p"
		else
			benis.icon_state = "wwolf_benis-f"
		H.add_overlay(benis) */
