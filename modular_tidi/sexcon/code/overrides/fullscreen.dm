/// Easy drop-in replacement for flash_fullscreen("redflashX") that checks whether the mob has no-redflash on. Returns the same screen obj that flash_fullscreen does.
/mob/proc/fullscreen_redflash(state)
	RETURN_TYPE(/atom/movable/screen/fullscreen/flashholder)
	if(client?.prefs?.no_redflash)
		return
	return flash_fullscreen(state)
