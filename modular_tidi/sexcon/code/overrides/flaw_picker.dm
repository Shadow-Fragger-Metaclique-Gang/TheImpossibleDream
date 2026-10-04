/datum/preferences/cannot_take_flaw(datum/charflaw/cf)
	if(cf.type == /datum/charflaw/addiction/baothamarked)
		return PREFERENCE_CHARFLAW_DENIAL_HIDE
	return ..()
