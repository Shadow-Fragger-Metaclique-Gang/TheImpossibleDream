/datum/species/handle_digestion(mob/living/carbon/human/H)
	. = ..()
	if(H.nutrition <= 0 || H.stat == DEAD || HAS_TRAIT(H, TRAIT_NOHUNGER))
		return
	var/hunger_rate = HUNGER_FACTOR
	var/obj/item/organ/breasts/breasts = H.has_breasts()
	if(breasts)
		if(H.nutrition > NUTRITION_LEVEL_HUNGRY && breasts.lactating && breasts.milk_max > breasts.milk_stored) //Vrell - numbers may need to be tweaked for balance but hey this works for now.
			var/milk_to_make = min(hunger_rate, breasts.milk_max - breasts.milk_stored)
			breasts.milk_stored += milk_to_make
			H.adjust_nutrition(-milk_to_make)

		else if(H.nutrition < NUTRITION_LEVEL_STARVING && breasts.lactating) //Vrell - If starving, your milk drains automatically to slow your starvation.
			var/milk_to_take = min(hunger_rate, breasts.milk_stored)
			breasts.milk_stored -= milk_to_take
			H.adjust_nutrition(milk_to_take)

/datum/species/proc/can_jiggle_breasts(mob/living/carbon/human/H)
	if(!H || H.cmode)
		return FALSE
	var/obj/item/organ/breasts/B = H.getorganslot(ORGAN_SLOT_BREASTS)
	if(!B || B.is_jiggling)
		return FALSE
	if(!B.can_jiggle || B.breast_size < MIN_JIGGLE_BREASTS_SIZE)
		return FALSE
	return TRUE
