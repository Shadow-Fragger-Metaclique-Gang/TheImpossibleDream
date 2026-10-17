/datum/objective/heretic/zizo/grave
	name = "The Restless Dead"
	heretic_tier = 1

/datum/objective/heretic/zizo/grave/update_explanation_text()
	explanation_text = "Desecrate and rob a grave."

/datum/objective/heretic/zizo/grave/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HERETIC_GRAVE_ROBBED, PROC_REF(on_grave_robbed))
	update_explanation_text()

/datum/objective/heretic/zizo/grave/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HERETIC_GRAVE_ROBBED)
	return ..()

/datum/objective/heretic/zizo/grave/proc/on_grave_robbed(datum/source, obj/structure/closet/dirthole/grave)
	SIGNAL_HANDLER
	if(completed)
		return
	complete()
	UnregisterSignal(owner.current, COMSIG_HERETIC_GRAVE_ROBBED)

/obj/structure/closet/dirthole/attackby(obj/item/attacking_item, mob/user, params)
	var/obj/structure/gravemarker/marker = locate() in loc
	. = ..()
	if(marker && QDELETED(marker))
		SEND_SIGNAL(user, COMSIG_HERETIC_GRAVE_ROBBED, src)

/datum/patron/inhumen/zizo // Zizoids need grave robber to do this and I don't want to put it in another file
	mob_traits = list(TRAIT_CABAL, TRAIT_ZIZOSIGHT, TRAIT_GRAVEROBBER)
