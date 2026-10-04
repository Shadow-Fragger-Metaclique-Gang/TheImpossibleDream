/obj/item/reagent_containers/glass/attack(mob/M, mob/user, obj/target)
	if(user.used_intent.type == INTENT_FILL)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			H.try_milking(user, src)
			return
	return ..()
