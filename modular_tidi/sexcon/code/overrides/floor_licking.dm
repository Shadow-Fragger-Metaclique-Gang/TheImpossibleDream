/mob/living/proc/on_floor_cum_licked()
	var/datum/status_effect/facial/facial = has_status_effect(/datum/status_effect/facial)
	if(!facial)
		apply_status_effect(/datum/status_effect/facial)
	else
		facial.refresh_cum()
	if(reagents)
		reagents.add_reagent(/datum/reagent/erpjuice/cum, 1)
