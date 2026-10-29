/datum/emote/living/bow/adjacentaction(mob/user, mob/target)
	. = ..()

	SEND_SIGNAL(user, COMSIG_MOB_DEMONSTATED_SERVILITY)
	SEND_SIGNAL(target, COMSIG_MOB_SHOWN_RESPECT)
