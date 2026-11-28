#define FATIGUE_BAR_HEIGHT 47
#define FATIGUE_BAR_LOW_RATIO 0.25

/atom/movable/screen/fatigue_bar
	layer = FLOAT_LAYER
	plane = FLOAT_PLANE
	var/prefix
	var/low = FALSE
	var/atom/movable/screen/parent_screen
	var/icon/mask_icon
	var/atom/movable/screen/bloodpool_maskpart/fill
	var/atom/movable/screen/bloodpool_maskpart/overlay
	var/fill_drop = -1
	var/overlay_drop = -1

/atom/movable/screen/fatigue_bar/Initialize(mapload, prefix, parent_screen, overlay_state)
	. = ..()
	src.prefix = prefix
	src.parent_screen = parent_screen
	var/bar_icon = 'icons/mob/rogueheat.dmi'
	mask_icon = icon(bar_icon, "[prefix]_mask")
	fill = new(null, bar_icon, parent_screen)
	fill.icon_state = "[prefix]_fill"
	vis_contents += fill
	if(overlay_state)
		overlay = new(null, bar_icon, parent_screen)
		overlay.icon_state = overlay_state
		overlay.layer = FLOAT_LAYER + 0.01
		vis_contents += overlay
	set_values(1, 0)

/atom/movable/screen/fatigue_bar/Destroy()
	QDEL_NULL(fill)
	QDEL_NULL(overlay)
	mask_icon = null
	parent_screen = null
	return ..()

/atom/movable/screen/fatigue_bar/examine_ui(mob/user)
	return parent_screen?.examine_ui(user)

/atom/movable/screen/fatigue_bar/proc/drop_part(atom/movable/screen/part, drop)
	part.pixel_z = -drop
	part.filters = filter(type = "alpha", icon = mask_icon, y = drop)

/atom/movable/screen/fatigue_bar/proc/set_values(ratio, overlay_ratio = 0)
	var/new_fill_drop = round(FATIGUE_BAR_HEIGHT * (1 - clamp(ratio, 0, 1)))
	if(new_fill_drop != fill_drop)
		fill_drop = new_fill_drop
		drop_part(fill, fill_drop)
	if(overlay)
		var/new_overlay_drop = round(FATIGUE_BAR_HEIGHT * (1 - clamp(overlay_ratio, 0, 1)))
		if(new_overlay_drop != overlay_drop)
			overlay_drop = new_overlay_drop
			drop_part(overlay, overlay_drop)
	var/now_low = ratio <= FATIGUE_BAR_LOW_RATIO
	if(now_low == low)
		return
	low = now_low
	if(low)
		animate(fill, icon_state = "[prefix]_fill_low", time = 5, loop = -1)
		animate(icon_state = "[prefix]_fill", time = 5)
	else
		animate(fill)
		fill.icon_state = "[prefix]_fill"

/atom/movable/screen/stamina
	icon_state = null
	var/atom/movable/screen/fatigue_bar/bar

/atom/movable/screen/stamina/Initialize(mapload, ...)
	. = ..()
	bar = new(null, "stambar_tall", src, "stambar_tall_battered")
	vis_contents += bar

/atom/movable/screen/stamina/Destroy()
	QDEL_NULL(bar)
	return ..()

/atom/movable/screen/stamina/examine_ui(mob/user)
	. = ..()
	if(isliving(user))
		var/mob/living/living_user = user
		var/battered = living_user.get_battered()
		if(battered > 0)
			to_chat(user, span_info("<b>Battered:</b> [round(battered, 0.1)] of my stamina will not come back until I catch my breath."))

/atom/movable/screen/energy
	icon_state = null
	var/atom/movable/screen/fatigue_bar/bar

/atom/movable/screen/energy/Initialize(mapload, ...)
	. = ..()
	bar = new(null, "energybar_tall", src)
	vis_contents += bar

/atom/movable/screen/energy/Destroy()
	QDEL_NULL(bar)
	return ..()

/mob/living/proc/update_fatigue_bars()
	if(hud_used?.stamina)
		var/atom/movable/screen/stamina/stamina_screen = hud_used.stamina
		stamina_screen.bar?.set_values((max_stamina_base - stamina) / max(max_stamina_base, 1), get_battered() / max(max_stamina_base, 1))
	if(hud_used?.energy)
		var/atom/movable/screen/energy/energy_screen = hud_used.energy
		energy_screen.bar?.set_values(energy / max(max_energy, 1))

#undef FATIGUE_BAR_HEIGHT
#undef FATIGUE_BAR_LOW_RATIO
