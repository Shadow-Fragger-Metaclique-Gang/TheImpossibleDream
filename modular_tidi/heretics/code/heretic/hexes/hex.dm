// HEXES
// CURSES CAST UPON OTHERS BY HERETICAL RITUALISTS
// THE CURSE IS DISPELLED IN ONE OF THREE WAYS
// THE CASTER DIES. THE CASTER REVOKES THE CURSE. THE FOCUS IS DESTROYED.
// MOVING THE FOCUS FROM THE RITUAL SPOT SUSPENDS THE CURSE UNTIL IT IS RETURNED.
// THE ABSOLVER CAN DECIDE TO SHARE IN THE CURSE - TAKING ON THE AFFLICTION WITHOUT REMOVING IT FROM THE TARGET
// BY TAPPING INTO THIS PAIN, THEY CAN TRACK THE FOCUS
// WHICH WILL LET THEM SUSPEND THE CURSE, AND EVEN DESTROY IT

/mob/living/carbon/human/
	var/list/cast_hexes // The hexes we've casted
	var/list/active_hexes // The hexes we've been targetted by
	var/list/shared_hexes // hexes shared via PURIFY
	var/last_examined // The last person we've examined. This is for the DOLLMAKER ritual.


/datum/hex/
	var/name = "Generic Hex"
	var/mob/living/carbon/human/caster
	var/mob/living/carbon/human/victim // the ORIGINAL victim
	var/mob/living/carbon/human/absolver // The Absolver, if they decide to share in the hex
	var/obj/item/focus // What item powers this curse?
	var/suspended = FALSE // Is this curse active or suspended?
	var/turf/ritual_turf // Where was this focus when the ritual was completed?
	var/mutable_appearance/focus_rune // A visual representation of where the focus should be to keep the curse active

/datum/hex/proc/apply(mob/living/carbon/human/hex_caster, mob/living/carbon/human/hex_victim, obj/item/new_focus)
	if(!hex_caster || !hex_victim || !new_focus)
		qdel(src)
		return FALSE
	if(caster || victim || focus) // If something goes horribly wrong and somehow the same hex datum is cast twice
		return FALSE

	caster = hex_caster
	victim = hex_victim
	focus = new_focus
	focus.add_filter("hex_focus_filter", 2, list("type" = "outline", "color" = "#AD456D", "alpha" = 180, "size" = 3)) // same colour as when you utter DEMIURGE or ANATHEMA
	ritual_turf = get_turf(focus)
	focus_rune = mutable_appearance('icons/roguetown/misc/rune_wards.dmi', "rune_alarm")
	focus_rune.alpha = 255
	focus_rune.color = "#A01818"
	ritual_turf.add_overlay(focus_rune)
	RegisterSignal(caster, COMSIG_MOB_DEATH, PROC_REF(hex_broken))
	RegisterSignal(caster, COMSIG_PARENT_QDELETING, PROC_REF(hex_broken))
	RegisterSignal(focus, COMSIG_PARENT_QDELETING, PROC_REF(hex_broken))
	if(victim != caster) // What kind of fool would hex themselves? Kept throwing runtime warnings when testing by casting it on myself so I may aswell add this.
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

/datum/hex/proc/focus_rune_update() // makes it obvious at a glance wether the hex is active or not.
	if(!ritual_turf || !focus_rune)
		return
	ritual_turf.cut_overlay(focus_rune)
	focus_rune.alpha = suspended ? 80 : 255
	focus_rune.color = suspended ? "#FFFFFF" : "#A01818"
	ritual_turf.add_overlay(focus_rune)

/datum/hex/proc/focus_moved()
	SIGNAL_HANDLER
	if(focus.loc == ritual_turf)
		if(suspended)
			suspended = FALSE
			focus_rune_update()
			on_apply()
			if(absolver)
				on_apply(absolver)
	else
		if(!suspended)
			suspended = TRUE
			focus_rune_update()
			on_remove()
			if(absolver)
				on_remove(absolver)

/datum/hex/proc/hex_broken(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/hex/proc/share_with_absolver(mob/living/carbon/human/new_absolver)
	if(!new_absolver || absolver) // early return if null or if there is somehow multiple absolvers in one round
		return FALSE
	absolver = new_absolver
	if(!absolver.shared_hexes)
		absolver.shared_hexes = list()
	absolver.shared_hexes += src
	RegisterSignal(absolver, COMSIG_PARENT_QDELETING, PROC_REF(absolver_deleted))
	if(!absolver.shared_hexes)
		absolver.shared_hexes = list()
	if(!suspended)
		on_apply(absolver)
	return TRUE

/datum/hex/proc/absolver_deleted(datum/source)
	SIGNAL_HANDLER
	absolver = null // note that unlike the victim, the hex is not dispelled by the absolver being deleted

/datum/hex/Destroy()
	if(victim)
		UnregisterSignal(victim, COMSIG_PARENT_QDELETING)
		if(!suspended)
			on_remove()
		victim.active_hexes -= src
	if(caster)
		UnregisterSignal(caster, COMSIG_MOB_DEATH)
		UnregisterSignal(caster, COMSIG_PARENT_QDELETING)
		caster.cast_hexes -= src
	if(focus)
		UnregisterSignal(focus, COMSIG_PARENT_QDELETING)
		UnregisterSignal(focus, COMSIG_MOVABLE_MOVED)
		focus.remove_filter("hex_focus_filter")
	if(absolver)
		UnregisterSignal(absolver, COMSIG_PARENT_QDELETING)
		absolver.shared_hexes -= src
		if(!suspended)
			on_remove(absolver)
	if(ritual_turf && focus_rune)
		ritual_turf.cut_overlay(focus_rune)
	caster = null
	victim = null
	focus = null
	absolver = null
	return ..()

/datum/hex/proc/on_apply(mob/living/carbon/human/sufferer = victim)
	return

/datum/hex/proc/on_remove(mob/living/carbon/human/sufferer = victim)
	return

