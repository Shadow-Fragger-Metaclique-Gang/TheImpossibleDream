/obj/item/rogueweapon/greataxe/steel/doublehead/minotaur
	item_flags = GIANT_WEAPON

/obj/item/rogueweapon/stoneaxe/woodcut/troll
	item_flags = GIANT_WEAPON

/obj/item/clothing/mask/rogue/eyepatch
	desc = "An eyepatch, fitted for the right eye, used by pirates and those with poked eyes, the patch itself makes parrying to perform on the blindspot"
	max_integrity = 50
	armor = list("blunt" = 10, "slash" = 10, "stab" = 5, "piercing" = 2, "fire" = 0, "acid" = 0, "frost" = 0, "electrical" = 0, "magic" = 0)

/obj/item/clothing/mask/rogue/eyepatch/left
	desc = "An eyepatch, fitted for the left eye, used by pirates and those with poked eyes, the patch itself makes parrying to perform on the blindspot"

/obj/item/rogueweapon/proc/try_self_disembowel(mob/living/M, mob/living/user)
	if(user != M || !iscarbon(user) || user.used_intent?.blade_class != BCLASS_STAB || !istype(user.rmb_intent, /datum/rmb_intent/weak))
		return FALSE
	if(user.zone_selected != BODY_ZONE_PRECISE_STOMACH && user.zone_selected != BODY_ZONE_CHEST)
		return FALSE
	if(user.doing)
		to_chat(user, span_warning("You're already in the process of disemboweling yourself!"))
		return TRUE
	user.visible_message(span_danger("[user] presses [src] to their stomach, preparing to disembowel themselves!"), span_notice("You press the blade to your stomach and begin to push..."))
	if(!do_after(user, 40, 1, user, 1))
		to_chat(user, span_warning("You stop before you can disembowel yourself!"))
		return TRUE
	var/mob/living/carbon/C = user
	C.get_bodypart(BODY_ZONE_CHEST)?.add_wound(/datum/wound/slash/disembowel)
	var/static/list/spilled_slots = list(ORGAN_SLOT_STOMACH, ORGAN_SLOT_LIVER, ORGAN_SLOT_HEART)
	for(var/slot in spilled_slots)
		var/obj/item/organ/spilled = C.getorganslot(slot)
		if(!spilled)
			continue
		spilled.Remove(C)
		spilled.forceMove(C.drop_location())
	C.update_damage_overlays()
	user.visible_message(span_danger("[user] disembowels themselves, their organs spilling out!"), span_notice("You feel a horrible pain as your organs spill out!"))
	user.emote("scream", null, null, TRUE, TRUE)
	user.overlay_fullscreen("painflash", /atom/movable/screen/fullscreen/painflash)
	return TRUE

/obj/item/rogueweapon/huntingknife/attack(mob/living/M, mob/living/user)
	if(try_self_disembowel(M, user))
		return
	return ..()

/obj/item/rogueweapon/sword/attack(mob/living/M, mob/living/user)
	if(try_self_disembowel(M, user))
		return
	return ..()
