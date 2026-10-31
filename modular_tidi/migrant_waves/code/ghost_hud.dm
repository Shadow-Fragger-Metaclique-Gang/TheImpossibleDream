#define ui_ghost_migrants "SOUTH:6,CENTER+4:24"

/atom/movable/screen/ghost/migrants
	name = "Migration Waves"
	icon = 'modular_tidi/migrant_waves/icons/screen_ghost.dmi'
	icon_state = "migrate"
	screen_loc = ui_ghost_migrants

/atom/movable/screen/ghost/migrants/Click()
	var/mob/dead/observer/ghost = usr
	if(!istype(ghost) || !ghost.client)
		return
	if(!is_migrant_eligible_ghost(ghost))
		to_chat(ghost, span_warning("You can't join migrant waves as this kind of spirit."))
		return
	ghost.client.prefs.migrant.show_ui()

/datum/hud/proc/add_migrant_waves_button()
	var/atom/movable/screen/ghost/migrants/button = new(null, src)
	static_inventory += button
