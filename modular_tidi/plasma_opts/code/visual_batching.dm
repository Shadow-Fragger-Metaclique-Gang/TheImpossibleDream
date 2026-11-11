/mob
	var/mutable_appearance/overlay_slate
	var/overlay_slate_dirty = FALSE
	var/immediate_visuals = FALSE

/mob/dead/observer
	immediate_visuals = TRUE

/mob/proc/get_overlay_slate()
	if(!overlay_slate)
		overlay_slate = new
		if(length(overlays))
			overlay_slate.overlays = overlays
	return overlay_slate

/mob/proc/stage_overlay_slate()
	. = get_overlay_slate()
	if(overlay_slate_dirty)
		return
	overlay_slate_dirty = TRUE
	SSiconupdates.dirty_slates += src

/mob/proc/commit_overlay_slate()
	if(!overlay_slate_dirty)
		return
	overlay_slate_dirty = FALSE
	overlays = overlay_slate.overlays
	POST_OVERLAY_CHANGE(src)
	update_vision_cone()

/mob/proc/flush_visuals()
	commit_overlay_slate()

/mob/living/carbon/flush_visuals()
	process_pending_icon_updates()
	..()

/mob/add_overlay(list/add_overlays)
	if(!add_overlays)
		return
	if(!VISUALS_BATCHED(src))
		var/mutable_appearance/mirror = get_overlay_slate()
		. = ..()
		mirror.overlays += build_appearance_list(add_overlays)
		return
	var/mutable_appearance/slate = stage_overlay_slate()
	slate.overlays += build_appearance_list(add_overlays)

/mob/cut_overlay(list/remove_overlays)
	if(!remove_overlays)
		return
	if(!VISUALS_BATCHED(src))
		var/mutable_appearance/mirror = get_overlay_slate()
		. = ..()
		mirror.overlays -= build_appearance_list(remove_overlays)
		return
	var/mutable_appearance/slate = stage_overlay_slate()
	slate.overlays -= build_appearance_list(remove_overlays)

/mob/cut_overlays()
	if(!VISUALS_BATCHED(src))
		var/mutable_appearance/mirror = get_overlay_slate()
		. = ..()
		mirror.overlays = null
		return
	var/mutable_appearance/slate = stage_overlay_slate()
	slate.overlays = null

/mob/copy_overlays(atom/other, cut_old)
	if(!other)
		if(cut_old)
			cut_overlays()
		return
	var/list/cached_other = LIVE_OVERLAYS(other)
	if(!VISUALS_BATCHED(src))
		var/mutable_appearance/mirror = get_overlay_slate()
		. = ..()
		if(cut_old)
			mirror.overlays = cached_other
		else if(length(cached_other))
			mirror.overlays += cached_other
		return
	if(!cut_old && !length(cached_other))
		return
	var/mutable_appearance/slate = stage_overlay_slate()
	if(cut_old)
		slate.overlays = cached_other
	else
		slate.overlays += cached_other

/mob/living/carbon
	var/pending_icon_updates = NONE
	var/icon_updates_ran = NONE
	var/flushing_icon_updates = FALSE
	var/pending_head_hide = FALSE
	var/pending_belt_hide = FALSE
	var/pending_back_hide = FALSE
	var/pending_hands_hide = FALSE

/mob/living/carbon/proc/queue_icon_update(bit)
	if(flushing_icon_updates)
		icon_updates_ran |= bit
		return FALSE
	if(!VISUALS_BATCHED(src) || QDELETED(src))
		return FALSE
	if(!pending_icon_updates)
		SSiconupdates.queued_mobs += src
	pending_icon_updates |= bit
	return TRUE

/mob/living/carbon/proc/process_pending_icon_updates()
	var/updates = pending_icon_updates
	if(!updates)
		return
	pending_icon_updates = NONE
	icon_updates_ran = NONE
	flushing_icon_updates = TRUE
	if((updates & PENDING_UPDATE_INV_HANDS) && !(icon_updates_ran & PENDING_UPDATE_INV_HANDS))
		update_inv_hands(pending_hands_hide)
	if((updates & PENDING_UPDATE_INV_UNIFORM) && !(icon_updates_ran & PENDING_UPDATE_INV_UNIFORM))
		update_inv_w_uniform()
	if((updates & PENDING_UPDATE_INV_ID) && !(icon_updates_ran & PENDING_UPDATE_INV_ID))
		update_inv_wear_id()
	if((updates & PENDING_UPDATE_INV_GLOVES) && !(icon_updates_ran & PENDING_UPDATE_INV_GLOVES))
		update_inv_gloves()
	if((updates & PENDING_UPDATE_INV_WRISTS) && !(icon_updates_ran & PENDING_UPDATE_INV_WRISTS))
		update_inv_wrists()
	if((updates & PENDING_UPDATE_INV_GLASSES) && !(icon_updates_ran & PENDING_UPDATE_INV_GLASSES))
		update_inv_glasses()
	if((updates & PENDING_UPDATE_INV_EARS) && !(icon_updates_ran & PENDING_UPDATE_INV_EARS))
		update_inv_ears()
	if((updates & PENDING_UPDATE_INV_SHOES) && !(icon_updates_ran & PENDING_UPDATE_INV_SHOES))
		update_inv_shoes()
	if((updates & PENDING_UPDATE_INV_S_STORE) && !(icon_updates_ran & PENDING_UPDATE_INV_S_STORE))
		update_inv_s_store()
	if((updates & PENDING_UPDATE_INV_MASK) && !(icon_updates_ran & PENDING_UPDATE_INV_MASK))
		update_inv_wear_mask()
	if((updates & PENDING_UPDATE_INV_HEAD) && !(icon_updates_ran & PENDING_UPDATE_INV_HEAD))
		update_inv_head(pending_head_hide)
	if((updates & PENDING_UPDATE_INV_BELT) && !(icon_updates_ran & PENDING_UPDATE_INV_BELT))
		update_inv_belt(pending_belt_hide)
	if((updates & PENDING_UPDATE_INV_BACK) && !(icon_updates_ran & PENDING_UPDATE_INV_BACK))
		update_inv_back(pending_back_hide)
	if((updates & PENDING_UPDATE_INV_PANTS) && !(icon_updates_ran & PENDING_UPDATE_INV_PANTS))
		update_inv_pants()
	if((updates & PENDING_UPDATE_INV_SUIT) && !(icon_updates_ran & PENDING_UPDATE_INV_SUIT))
		update_inv_wear_suit()
	if((updates & PENDING_UPDATE_INV_ARMOR) && !(icon_updates_ran & PENDING_UPDATE_INV_ARMOR))
		update_inv_armor()
	if((updates & PENDING_UPDATE_INV_POCKETS) && !(icon_updates_ran & PENDING_UPDATE_INV_POCKETS))
		update_inv_pockets()
	if((updates & PENDING_UPDATE_INV_NECK) && !(icon_updates_ran & PENDING_UPDATE_INV_NECK))
		update_inv_neck()
	if((updates & PENDING_UPDATE_INV_CLOAK) && !(icon_updates_ran & PENDING_UPDATE_INV_CLOAK))
		update_inv_cloak()
	if((updates & PENDING_UPDATE_INV_SHIRT) && !(icon_updates_ran & PENDING_UPDATE_INV_SHIRT))
		update_inv_shirt()
	if((updates & PENDING_UPDATE_INV_MOUTH) && !(icon_updates_ran & PENDING_UPDATE_INV_MOUTH))
		update_inv_mouth()
	if((updates & PENDING_UPDATE_DAMAGE) && !(icon_updates_ran & PENDING_UPDATE_DAMAGE))
		update_damage_overlays()
	if((updates & PENDING_UPDATE_BODY_REDRAW) && !(icon_updates_ran & PENDING_UPDATE_BODY_REDRAW))
		update_body_parts(TRUE)
	else if((updates & PENDING_UPDATE_BODY) && !(icon_updates_ran & (PENDING_UPDATE_BODY|PENDING_UPDATE_BODY_REDRAW)))
		update_body_parts()
	flushing_icon_updates = FALSE
	icon_updates_ran = NONE
	pending_head_hide = FALSE
	pending_belt_hide = FALSE
	pending_back_hide = FALSE
	pending_hands_hide = FALSE

/mob/living/carbon/human
	var/damage_overlay_cache_key
	var/list/cached_damage_standing

GLOBAL_LIST_EMPTY(damage_overlay_cache)

/proc/get_cached_damage_overlay(icon, icon_state, layer, overlay_color, pixel_x = 0, pixel_y = 0)
	var/key = "[icon]|[icon_state]|[layer]|[overlay_color]|[pixel_x]|[pixel_y]"
	var/mutable_appearance/cached = GLOB.damage_overlay_cache[key]
	if(!cached)
		cached = mutable_appearance(icon, icon_state, -layer)
		if(overlay_color)
			cached.color = overlay_color
		cached.pixel_x = pixel_x
		cached.pixel_y = pixel_y
		GLOB.damage_overlay_cache[key] = cached
	return cached
