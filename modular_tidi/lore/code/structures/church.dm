/obj/effect/proc_holder/spell/self/convertrole/templar
	recruitment_message = "Serve the Gods, %RECRUIT!"
	accept_message = "FOR THE PENTACLE!"

/obj/effect/proc_holder/spell/self/convertrole/monk
	recruitment_message = "Serve the Gods, %RECRUIT!"
	accept_message = "FOR THE GODS!"

/obj/structure/fluff/psycross/get_mechanics_examine(mob/user)
	. = ..()
	var/mob/living/living_user = user
	if(user.mind.assigned_role == "Bishop")
		. += span_info("As the Pontifex, you can marry two people by having them both bite an apple, then offering it to the cross.")
	else if(istype(living_user) && HAS_TRAIT(living_user, TRAIT_MARRIAGE_CAPABLE))
		. += span_info("As an Eoran, you can marry two people by having them both bite an apple, then offering it to the cross.")
