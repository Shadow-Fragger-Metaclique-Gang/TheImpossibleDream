/datum/objective/heretic/baotha/share
	name = "Shared Ecstasy"
	heretic_tier = 1
	baotha_objective_text = "make another person snort drugs"

/datum/objective/heretic/baotha/share/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HERETIC_DRUGS_SHARED, PROC_REF(on_drugs_shared))

/datum/objective/heretic/baotha/share/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HERETIC_DRUGS_SHARED)
	return ..()

/datum/objective/heretic/baotha/share/proc/on_drugs_shared(datum/source, mob/living/sniffer)
	SIGNAL_HANDLER
	if(completed || baotha_objective_done)
		return
	baotha_objective_done = TRUE
	check_progress()

/// Latch onto powder attack and check if we're forcing real drugs onto someone, and then send the completion signal
/obj/item/reagent_containers/powder/attack(mob/M, mob/user, def_zone)
	var/drugged = heretic_is_drugged(reagents)
	. = ..()
	if(. && drugged && user != M)
		SEND_SIGNAL(user, COMSIG_HERETIC_DRUGS_SHARED, M)
