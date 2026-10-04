/// refreshes vision of everyone visible 2 update icon_state changes ! Usually not needed
/proc/refresh_viewers(atom/source)
	for(var/mob/M in viewers(7, source))
		if(M.client)
			M.update_vision_cone()
