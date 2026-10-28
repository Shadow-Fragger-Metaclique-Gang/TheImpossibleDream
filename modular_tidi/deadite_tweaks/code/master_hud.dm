/mob/living
	var/datum/weakref/summoned_by
	var/image/master_hud
	var/master_hud_ckey

/mob/living/proc/set_summoned_by(mob/living/master)
	hide_master_hud()
	summoned_by = WEAKREF(master)
	show_master_hud()

/mob/living/proc/clear_summoned_by()
	hide_master_hud()
	summoned_by = null

/mob/living/proc/show_master_hud()
	var/mob/living/master = summoned_by?.resolve()
	if(!client || !master || QDELETED(master) || stat == DEAD)
		return
	hide_master_hud()
	master_hud = image('modular_tidi/deadite_tweaks/icons/hud.dmi', master, "master_hud")
	master_hud.appearance_flags = RESET_COLOR|RESET_TRANSFORM
	master_hud_ckey = ckey
	client.images |= master_hud

/mob/living/proc/hide_master_hud()
	if(master_hud)
		var/client/viewer = client || GLOB.directory[master_hud_ckey]
		viewer?.images -= master_hud
	master_hud = null
	master_hud_ckey = null

/mob/living/Login()
	. = ..()
	show_master_hud()

/mob/living/Logout()
	hide_master_hud()
	return ..()

/mob/living/death(gibbed, nocutscene = FALSE)
	hide_master_hud()
	return ..()

/mob/living/revive(full_heal = FALSE, admin_revive = FALSE)
	. = ..()
	show_master_hud()
