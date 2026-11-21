///The alpha mask used on mobs submerged in liquid turfs or standing on high ground
#define MOB_MOVING_EFFECT_MASK "mob_moving_effect_mask"
///mob_overlay_effect component. adds and removes
/datum/element/mob_overlay_effect
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH
	id_arg_index = 2

	var/y_offset = 0
	var/mask_y_offset = 0
	var/effect_alpha = 0
	var/alternate_behavior
	var/obj/mask_atom/mask
	var/image/newmask
	var/lastlying
/datum/element/mob_overlay_effect/Attach(datum/target, _y_offset = 0, _mask_y_offset = 0, _effect_alpha = 0, _alternate_behavior)
	. = ..()

	y_offset = _y_offset
	mask_y_offset = _mask_y_offset
	effect_alpha = _effect_alpha
	mask = new
	mask.render_target ="*[ref(mask)]"
	RegisterSignal(get_turf(target), COMSIG_TURF_EXITED, PROC_REF(on_remove), override = TRUE)
	RegisterSignal(get_turf(target), COMSIG_TURF_ENTERED, PROC_REF(on_add), override = TRUE)
	RegisterSignal(target, COMSIG_MOB_OVERLAY_FORCE_REMOVE, PROC_REF(on_remove), override = TRUE)
	RegisterSignal(target, COMSIG_MOB_OVERLAY_FORCE_UPDATE, PROC_REF(on_add), override = TRUE)
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(remove_all), override = TRUE)

/datum/element/mob_overlay_effect/Detach(datum/source)
	. = ..()
	if(isliving(source))
		UnregisterSignal(source, COMSIG_LIVING_LYING_UPDATE)
	UnregisterSignal(get_turf(source), list(
		COMSIG_TURF_EXITED,
		COMSIG_TURF_ENTERED))
	UnregisterSignal(source, list(
		COMSIG_MOB_OVERLAY_FORCE_REMOVE,
		COMSIG_MOB_OVERLAY_FORCE_UPDATE,
		COMSIG_PARENT_QDELETING
	))

/datum/element/mob_overlay_effect/proc/on_remove(datum/source, datum/target)
	SIGNAL_HANDLER
	var/mob/mob = target
	if(ismovable(target))
		var/atom/movable/AM = target
		AM.remove_filter(MOB_MOVING_EFFECT_MASK)
	if(ismob(mob))
		mob.update_vision_cone()
	UnregisterSignal(target, COMSIG_ITEM_PICKUP)
	mob.vis_contents -= mask


/datum/element/mob_overlay_effect/proc/remove_all(datum/source)
	SIGNAL_HANDLER
	for(var/atom/movable/AM in get_turf(source))
		on_remove(src, AM)

/datum/element/mob_overlay_effect/proc/on_add(datum/source, datum/target)
	SIGNAL_HANDLER
	var/mob/mob = target
	var/turf/target_turf = get_turf(target)
	if(target_turf.platform_atom_count > 0)
		return

	if(isobj(target))
		var/obj/obj = target
		if(obj.obj_flags & IGNORE_SINK)
			return

	if(istype(target, /obj/structure/hotspring))
		return

	var/offset = 0
	if(istype(target, /obj/structure/flora/tree))
		offset -= 24
	if(isitem(target))
		offset += 7
	var/atom/movable/arrived = target
	if(effect_alpha)

		arrived.vis_contents += mask
		arrived.add_filter(MOB_MOVING_EFFECT_MASK, 1, alpha_mask_filter(0,  mask_y_offset+offset, null, mask.render_target, MASK_INVERSE))
		if(isliving(target))
			var/mob/living/L = target
			RegisterSignal(L, COMSIG_LIVING_LYING_UPDATE, PROC_REF(on_lying_update), override = TRUE)
	if(ismob(mob))
		mob.update_vision_cone()
	RegisterSignal(arrived, COMSIG_ITEM_PICKUP, TYPE_PROC_REF(/datum/element/mob_overlay_effect, on_remove_proxy), override = TRUE)

/datum/element/mob_overlay_effect/proc/on_remove_proxy(atom/source)
	SIGNAL_HANDLER
	on_remove(src, source)

/obj/mask_atom
	icon = 'icons/effects/icon_cutter.dmi'
	icon_state = "icon_cutter"
	mouse_opacity = FALSE
	vis_flags = VIS_UNDERLAY
	appearance_flags = RESET_TRANSFORM
/datum/element/mob_overlay_effect/proc/on_lying_update(mob/living/source, lying)
	SIGNAL_HANDLER
	if(source.lying == lastlying)
		return
	var/matrix/newmatrix =  new
	var/i_failed_calc= 0
	switch(source.lying)
		if(0)
			i_failed_calc = 0
		if(90)
			i_failed_calc = -90
		if(270)
			i_failed_calc = 90
	mask.transform = newmatrix.Turn(i_failed_calc)
	lastlying = source.lying
