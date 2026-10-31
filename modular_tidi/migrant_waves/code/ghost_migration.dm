/// Standard and admin ghosts (including /nodraw, the default) qualify. Scrying eyes and trapped (profane) ghosts are excluded.
/proc/is_migrant_eligible_ghost(mob/dead/observer/ghost)
	if(!istype(ghost))
		return FALSE
	if(istype(ghost, /mob/dead/observer/eye) || ghost.trapped)
		return FALSE
	if(!ghost.client?.prefs?.migrant)
		return FALSE
	if(CONFIG_GET(flag/norespawn))
		return FALSE
	return TRUE

/// Lobby players plus eligible ghosts: everyone who may sit in the migrant queue.
/proc/get_migrant_candidate_mobs()
	var/list/candidates = list()
	for(var/mob/dead/new_player/lobby_player as anything in GLOB.new_player_list)
		if(lobby_player.client)
			candidates += lobby_player
	for(var/mob/dead/observer/ghost in GLOB.player_list)
		if(is_migrant_eligible_ghost(ghost))
			candidates += ghost
	return candidates

/// Returns the new_player mob the migrant spawn code needs, turning a ghost into one first if required.
/proc/get_migrant_new_player(client/migrant_client)
	var/mob/current_mob = migrant_client?.mob
	if(!current_mob)
		return null
	if(istype(current_mob, /mob/dead/new_player))
		return current_mob
	var/mob/dead/observer/ghost = current_mob
	if(!istype(ghost))
		return null
	return ghost.become_migrant_new_player()

/mob/dead/observer/proc/become_migrant_new_player()
	if(!client)
		return null
	var/mob/dead/new_player/lobby_mob = new /mob/dead/new_player()
	client.screen.Cut()
	client.screen += client.void
	SSdroning.kill_rain(client)
	SSdroning.kill_loop(client)
	SSdroning.kill_droning(client)
	remove_client_colour(/datum/client_colour/monochrome)
	remove_verb(client, GLOB.ghost_verbs)
	client.init_verbs()
	lobby_mob.key = key
	qdel(src)
	return lobby_mob
