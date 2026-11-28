/proc/get_stat_roll(stat_value, skill_value, return_mod = FALSE)
	if(return_mod)
		return STAT_MOD(stat_value) + skill_value
	return rand(1, 20) + STAT_MOD(stat_value) + skill_value

/proc/get_stamina_cost(obj/item/I, mob/living/user)
	if(!I || !user)
		return 0
	var/rmb_stam_penalty = 0
	if(istype(user.rmb_intent, /datum/rmb_intent/strong))
		rmb_stam_penalty = round(EXTRA_STAMDRAIN_SWIFSTRONG * (1 - (user.STASTR / 100)), 1)
	if(istype(user.rmb_intent, /datum/rmb_intent/swift))
		if(user.used_intent.clickcd > CLICK_CD_INTENTCAP)
			rmb_stam_penalty = round(EXTRA_STAMDRAIN_SWIFSTRONG * (1 - (user.STASPD / 100)), 1)
	var/stamina_drain = 0
	if(user.used_intent)
		stamina_drain = user.used_intent.releasedrain + rmb_stam_penalty
	else
		stamina_drain = 1 + rmb_stam_penalty
	stamina_drain += max(I.wbalance + I.wlength, 0)
	if(I.minstr)
		var/used_str = user.STASTR
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.domhand)
				used_str = C.get_str_arms(C.used_hand)
		var/effective_minstr = I.minstr
		if(I.wielded)
			effective_minstr = max(I.minstr / 2, 1)
		if(used_str < effective_minstr)
			stamina_drain += (effective_minstr - used_str) * 2
	return stamina_drain
