/mob/living/carbon/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/leash))
		return I.attack(src, user)
	return ..()

/mob/living/carbon/resist_leash()
	to_chat(src, span_notice("I reach for the hook on my collar..."))
	//Determine how long it takes to remove the leash
	var/deleash = 5 SECONDS
	if(src.handcuffed)
		deleash = 20 SECONDS
	if(move_after(src, deleash, 0, target = src))
		if(!QDELETED(src))
			to_chat(src, "<span class='warning'>[src] has removed their leash!</span>")
			src.remove_status_effect(/datum/status_effect/leash_pet)
