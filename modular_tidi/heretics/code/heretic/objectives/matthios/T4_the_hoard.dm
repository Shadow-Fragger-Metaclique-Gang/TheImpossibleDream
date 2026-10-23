/datum/objective/heretic/matthios/hoard
	name = "The Hoard"
	heretic_tier = 4
	heretic_branch = HERETIC_PATH_DRAKE
	var/hoard_needed = 1000

/datum/objective/heretic/matthios/hoard/update_explanation_text()
	explanation_text = "Carry a hoard of [hoard_needed] mammon in coin."

/datum/objective/heretic/matthios/hoard/on_creation()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(count_hoard)), 5 SECONDS, TIMER_STOPPABLE | TIMER_LOOP)
	update_explanation_text()

/datum/objective/heretic/matthios/hoard/progress_text()
	return "My hoard is worth [hoard_value()] of [hoard_needed] mammon."

/datum/objective/heretic/matthios/hoard/proc/hoard_value()
	var/mob/living/carbon/human/heretic = owner?.current
	if(!istype(heretic))
		return 0
	var/value = 0
	for(var/obj/item/roguecoin/coin in heretic.GetAllContents())
		value += coin.get_real_price()
	return value

/datum/objective/heretic/matthios/hoard/proc/count_hoard()
	var/mob/living/carbon/human/heretic = owner?.current
	if(completed || !istype(heretic) || heretic.stat == DEAD)
		return
	if(hoard_value() < hoard_needed)
		return
	complete()
