/datum/objective/heretic/baotha/lux
	name = "Lux-ury"
	heretic_tier = 1
	baotha_objective_text = "devour lux of any purity"

/datum/objective/heretic/baotha/lux/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HERETIC_LUX_EATEN, PROC_REF(on_lux_eaten))

/datum/objective/heretic/baotha/lux/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HERETIC_LUX_EATEN)
	return ..()

/datum/objective/heretic/baotha/lux/proc/on_lux_eaten(datum/source)
	SIGNAL_HANDLER
	if(completed || baotha_objective_done)
		return
	baotha_objective_done = TRUE
	check_progress()
