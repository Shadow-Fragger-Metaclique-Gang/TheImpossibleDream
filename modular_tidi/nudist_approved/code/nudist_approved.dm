// NUDIST_APPROVED
/datum/controller/global_vars/Initialize(mapload)
	. = ..()
	roguetraits[TRAIT_NUDIST] = "I <b>refuse</b> to wear clothes. They are a hindrance to my freedom. I can tolerate certain accessories."
	roguetraits[TRAIT_NUDE_SLEEPER] = span_warning("I can't fall asleep unless I'm nude and resting comfortably. Unremovable clothing and certain accessories are allowed.")

/obj/item
	/// Permits Nudists to wear these, reserved for some niche things like bandage gloves for punching,
	/// and some accessories. A nudist wont wear a t-shirt, but they will wear a floral crown.
	var/nudist_approved = FALSE

/obj/item/examine(mob/user)
	. = ..()
	if(nudist_approved)
		if(HAS_TRAIT(user, TRAIT_NUDE_SLEEPER))
			. += span_smallnotice("I can tolerate having this on when I sleep.")
		else if(HAS_TRAIT(user, TRAIT_NUDIST))
			. += span_smallnotice("I can tolerate wearing this.")

/// Only voluntary sleep is restricted. Forced sleep and existing sleep regeneration keep their normal behavior.
/mob/living/carbon/handle_sleep()
	if(client && ishuman(src) && stat == CONSCIOUS && !IsSleeping() && eyesclosed && HAS_TRAIT(src, TRAIT_NUDE_SLEEPER) && (!(mobility_flags & MOBILITY_STAND) || buckled?.sleepy))
		var/reason = nude_sleep_block_reason()
		if(reason)
			if(!fallingas)
				to_chat(src, span_warning(reason))
			fallingas = TRUE
			return
	return ..()

/// Uses the same beds, buckled furniture, and Outdoorsman branches as handle_sleep().
/mob/living/carbon/proc/nude_sleep_block_reason()
	var/comfortable = !!buckled?.sleepy
	if(!comfortable && isturf(loc) && !(mobility_flags & MOBILITY_STAND))
		var/obj/structure/bed/rogue/bed = locate() in loc
		comfortable = !!bed
		if(!comfortable && HAS_TRAIT(src, TRAIT_OUTDOORSMAN))
			var/obj/structure/flora/newbranch/branch = locate() in loc
			comfortable = !!branch
	if(!comfortable)
		return "I need to rest on something more comfortable!"
	for(var/obj/item/item in get_equipped_items())
		if(item.nudist_approved || HAS_TRAIT(item, ABSTRACT_ITEM_TRAIT) || HAS_TRAIT(item, TRAIT_NODROP))
			continue
		return "I can't sleep while wearing clothes!"
	return null

/mob/living/get_strip_delay_mult(mob/living/target, obj/item/what)
	. = ..()
	// Preserve the existing corpse/surrender multipliers without stacking another discount.
	if(. == 1 && isliving(target) && HAS_TRAIT(target, TRAIT_NUDE_SLEEPER) && target.IsSleeping() && what?.nudist_approved)
		return 0.5

/datum/special_trait/nude_sleeper
	greet_text = span_boldwarning("I can't fall asleep unless I'm nude and resting comfortably. Unremovable clothing and certain accessories are allowed.")

/datum/species/can_equip(obj/item/I, slot, disable_warning, mob/living/carbon/human/H, bypass_equip_delay_self = FALSE)
	if(slot == SLOT_HEAD && HAS_TRAIT(H, TRAIT_NUDIST) && !I.nudist_approved)
		return FALSE
	return ..()
