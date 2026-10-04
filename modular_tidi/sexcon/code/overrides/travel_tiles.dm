/obj/structure/fluff/traveltile/perform_travel(obj/structure/fluff/traveltile/T, mob/living/L)
	// handle unknotting
	if(ishuman(L))
		var/mob/living/carbon/human/knot_haver = L
		if(knot_haver.sexcon.knotted_status)
			knot_haver.sexcon.knot_remove()
	if(ishuman(L.pulling)) // also check if pulled mob is knotted
		var/mob/living/carbon/human/H = L.pulling
		if(H.sexcon.knotted_status)
			H.sexcon.knot_remove()
	return ..()
