/mob/living/attempt_disarm(mob/living/user, obj/item/weapon)
	if(istype(user.used_intent, /datum/intent/sword/disarm))
		var/datum/intent/sword/disarm/disarm_intent = user.used_intent
		return disarm_intent.attempt_weapon_disarm(src, user, weapon)
	return ..()

/datum/intent/sword/disarm
	desc = "Hook the targeted hand to take or knock away its weapon. Two-handed grips and paired weapons improve the odds; exposed, baited, or off-balanced targets are especially vulnerable."

/datum/intent/sword/disarm/proc/attempt_weapon_disarm(mob/living/H, mob/living/user, obj/item/weapon)
	if(!iscarbon(H) || H == user)
		return
	if(QDELETED(weapon))
		return

	var/skill_diff = 0
	var/obj/item/I
	if(user.zone_selected == BODY_ZONE_PRECISE_L_HAND && H.active_hand_index == 1)
		I = H.get_active_held_item()
	else if(user.zone_selected == BODY_ZONE_PRECISE_R_HAND && H.active_hand_index == 2)
		I = H.get_active_held_item()
	else
		I = H.get_inactive_held_item()
	if(user.mind && weapon.associated_skill)
		skill_diff += user.get_skill_level(weapon.associated_skill)
	if(H.mind)
		skill_diff -= H.get_skill_level(/datum/skill/combat/wrestling)
	user.stamina_add(rand(3,8))
	var/probby = clamp((((3 + (((user.STASTR - H.STASTR)/4) + skill_diff)) * 10)), 5, 95)
	if(!I)
		to_chat(user, span_warning("They aren't holding anything on that hand!"))
		return
	if(H.mind)
		if(I.associated_skill)
			probby -= H.get_skill_level(I.associated_skill) * 5
	var/obj/item/mainhand = user.get_active_held_item()
	var/obj/item/offhand = user.get_inactive_held_item()
	if(weapon.wielded || (HAS_TRAIT(user, TRAIT_DUALWIELDER) && istype(offhand, mainhand)))
		probby += 20
	if(H.has_status_effect(/datum/status_effect/debuff/exposed) || H.has_status_effect(/datum/status_effect/debuff/baited) || H.IsOffBalanced())//this is so you dont need to be a STR beast wrestle chud to disarm with any reliability
		probby += 40
	var/disarm_success = prob(probby)
	// Occupied offhands and two-handed grips can knock weapons away, but cannot take them.
	if(disarm_success && !weapon.wielded && !user.get_inactive_held_item())
		if(!H.dropItemToGround(I, force = FALSE, silent = FALSE))
			return
		user.stop_pulling()
		user.put_in_inactive_hand(I)
		H.visible_message(span_danger("[user] takes [I] from [H]'s hand!"), \
			span_userdanger("[user] takes [I] from my hand!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
		user.changeNext_move(12)//avoids instantly attacking with the new weapon
		playsound(weapon.loc, 'sound/combat/weaponr1.ogg', 100, FALSE, -1)
		if(!H.mind)
			H.Stun(10)
	else
		probby += 20
		if(disarm_success || prob(probby))
			if(!H.dropItemToGround(I, force = FALSE, silent = FALSE))
				return
			H.visible_message(span_danger("[user] disarms [H] of [I]!"), \
				span_userdanger("[user] disarms me of [I]!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
			if(!H.mind)
				H.Stun(20)	//high delay to pick up weapon
			else
				H.Stun(6)	//slight delay to pick up the weapon
		else
			user.Immobilize(10)
			H.Immobilize(10)
			H.visible_message(span_notice("[user.name] struggles to disarm [H.name]!"))
			playsound(weapon.loc, 'sound/foley/struggle.ogg', 100, FALSE, -1)
