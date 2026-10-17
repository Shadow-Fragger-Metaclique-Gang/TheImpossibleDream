/obj/structure/underworld/carriageman/examine(mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_RITUALIST))
		return
	if((user.patron?.type == /datum/patron/divine/necra) && user.get_skill_level(/datum/skill/magic/ritualist))
		. += (span_cult(" I could exchange a toll to refresh my rites..."))

/obj/structure/underworld/carriageman/attack_hand(mob/living/user)
	var/refreshing = !istype(user, /mob/living/carbon/spirit) && HAS_TRAIT(user, TRAIT_SOUL_EXAMINE) && toll
	. = ..()
	if(!refreshing)
		return
	for(var/rite_type in subtypesof(/datum/runeritual/god))
		if(TIMER_COOLDOWN_RUNNING(user, rite_type))
			S_TIMER_COOLDOWN_RESET(user, rite_type)
