// HEXES
// CURSES CAST UPON OTHERS BY HERETICAL RITUALISTS
// THE CURSE IS DISPELLED IN ONE OF THREE WAYS
// THE CASTER DIES. THE CASTER REVOKES THE CURSE. THE FOCUS IS DESTROYED.
// MOVING THE FOCUS FROM THE RITUAL SPOT SUSPENDS THE CURSE UNTIL IT IS RETURNED.

/mob/living/carbon/
	var/list/cast_hexes // The hexes we've casted
	var/list/active_hexes // The hexes we've been targetted by
	var/last_examined // The last person we've examined. This is for the DOLLMAKER ritual.


/datum/hex/
	var/name = "Generic Hex"

	var/mob/living/carbon/caster
	var/mob/living/carbon/victim
	var/obj/item/focus // What item powers this curse?
	var/suspended = FALSE // Is this curse active or suspended?
	var/turf/ritual_turf // Where was this focus when the ritual was completed?

/datum/hex/proc/apply(mob/living/carbon/hex_caster, mob/living/carbon/hex_victim, obj/item/new_focus)
	if(!hex_caster || !hex_victim || !new_focus)
		qdel(src)
		return FALSE
	if(caster || victim || focus) // If something goes horribly wrong and somehow the same curse datum is cast twice
		return FALSE

	caster = hex_caster
	victim = hex_victim
	focus = new_focus
	ritual_turf = get_turf(focus)
	RegisterSignal(caster, COMSIG_MOB_DEATH, PROC_REF(hex_broken))
	RegisterSignal(caster, COMSIG_PARENT_QDELETING, PROC_REF(hex_broken))
	RegisterSignal(focus, COMSIG_PARENT_QDELETING, PROC_REF(hex_broken))
	RegisterSignal(victim, COMSIG_PARENT_QDELETING, PROC_REF(hex_broken))
	RegisterSignal(focus, COMSIG_MOVABLE_MOVED, PROC_REF(focus_moved))

	if(!caster.cast_hexes)
		caster.cast_hexes = list()
	if(!victim.active_hexes)
		victim.active_hexes = list()
	caster.cast_hexes += src
	victim.active_hexes += src

	on_apply()
	return TRUE

/datum/hex/proc/focus_moved()
	SIGNAL_HANDLER
	if(focus.loc == ritual_turf)
		if(suspended)
			suspended = FALSE
			on_apply()
	else
		if(!suspended)
			suspended = TRUE
			on_remove()

/datum/hex/proc/hex_broken(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/hex/Destroy()
	if(victim)
		UnregisterSignal(victim, COMSIG_PARENT_QDELETING)
		if(!suspended)
			on_remove()
	if(caster)
		UnregisterSignal(caster, COMSIG_MOB_DEATH)
		UnregisterSignal(caster, COMSIG_PARENT_QDELETING)
	if(focus)
		UnregisterSignal(focus, COMSIG_PARENT_QDELETING)
		UnregisterSignal(focus, COMSIG_MOVABLE_MOVED)
	if(caster?.cast_hexes)
		caster.cast_hexes -= src
	if(victim?.active_hexes)
		victim.active_hexes -= src
	caster = null
	victim = null
	focus = null
	return ..()

/datum/hex/proc/on_apply()
	return

/datum/hex/proc/on_remove()
	return

