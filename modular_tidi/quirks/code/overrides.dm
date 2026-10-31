/datum/preferences/cannot_take_flaw(datum/charflaw/cf)
	if(istype(cf, /datum/charflaw/hunted) || istype(cf, /datum/charflaw/targeted))
		return PREFERENCE_CHARFLAW_DENIAL_HIDE
	. = ..()
	if(.)
		return
	if(check_vice_pick_conflict(cf.type))
		return PREFERENCE_CHARFLAW_DENIAL_QUIRK

/datum/preferences/flaw_denial_to_string(denial)
	if(denial == PREFERENCE_CHARFLAW_DENIAL_QUIRK)
		return "Incompatible with one of my quirks."
	return ..()

/datum/preferences/_load_flaw(S)
	. = ..()
	charflaws -= list(/datum/charflaw/hunted, /datum/charflaw/targeted)
	if(!LAZYLEN(charflaws))
		charflaws = list(/datum/charflaw/noflaw)

/datum/job/roguetown/assassin
	quirk_restrictions = list(/datum/quirk/hunted, /datum/quirk/assassintarget)

/datum/job/roguetown/gnoll
	quirk_restrictions = list(/datum/quirk/noble, /datum/quirk/hunted, /datum/quirk/assassintarget)

/datum/job/roguetown/hag
	quirk_restrictions = list(/datum/quirk/noble, /datum/quirk/feytouched, /datum/quirk/hunted, /datum/quirk/assassintarget)

/datum/job/roguetown/lamplighter
	quirk_restrictions = list(/datum/quirk/hunted, /datum/quirk/assassintarget)

/datum/job/roguetown/greater_skeleton
	quirk_restrictions = list(/datum/quirk/hunted, /datum/quirk/assassintarget)

/datum/statpack/wildcard/fated
	desc = "The first or the last - let destiny's fickle loom decree what your fate shall be. Xylixians get better odds!\n(Allows access to a second virtue.)"

/datum/statpack/wildcard/virtuous
	desc = "The breadth of my being is one of many, distinguished talents.\n(Allows access to a second virtue.)"
