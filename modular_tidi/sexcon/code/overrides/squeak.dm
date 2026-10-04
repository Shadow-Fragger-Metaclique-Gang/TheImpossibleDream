/datum/component/squeak
	// Guards against duplicate step signals fired in a single tick.
	var/last_step_tick = -1

/datum/component/squeak/step_squeak()
	if(last_step_tick == world.time)
		return
	last_step_tick = world.time
	return ..()

/datum/component/squeak/play_squeak_crossed(datum/source, atom/movable/AM)
	if(ismob(AM))
		var/mob/M = AM
		if(M.m_intent == MOVE_INTENT_SNEAK && prob(90))
			return
	return ..()
