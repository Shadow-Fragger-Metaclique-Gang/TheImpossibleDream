/datum/status_effect/buff/cum_consumed
	id = "cum_consumed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/cum_consumed
	duration = 10 MINUTES

/datum/status_effect/buff/cum_consumed/on_apply()
	. = ..()
	if(owner.has_flaw(/datum/charflaw/addiction/lovefiend))
		owner.add_stress(/datum/stressevent/cumconsumed)

/datum/status_effect/buff/cum_consumed/on_remove()
	if(owner.has_flaw(/datum/charflaw/addiction/lovefiend))
		owner.remove_stress(/datum/stressevent/cumconsumed)
	. = ..()

/atom/movable/screen/alert/status_effect/buff/cum_consumed
	name = "Cumdrunk"
	desc = "I've swallowed someone's load..."
	icon_state = "drunk"
