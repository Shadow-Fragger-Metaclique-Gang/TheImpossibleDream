#define LISTENER_PLACE_DELAY 1 SECONDS
#define LISTENER_ARM_DELAY 30 SECONDS

/obj/item/listeningdevice
	// TRUE while the listener is laid down and hidden on the floor.
	var/deployed = FALSE
	var/arm_timer

/// Called from attack_self. Quietly drops the listener in front of the user, hidden and idle.
/obj/item/listeningdevice/proc/place_down(mob/living/user)
	if(deployed || !isturf(get_turf(user)))
		return
	var/turf/front = get_step(user, user.dir)
	if(!front || front.density)
		front = get_turf(user)
	if(!do_after(user, LISTENER_PLACE_DELAY, target = src, progress = FALSE))
		return
	if(!user.transferItemToLoc(src, front, TRUE))
		return
	deployed = TRUE
	set_hidden(TRUE)
	start_arming()

/// Called from attack_right. Sets or clears the listener's label.
/obj/item/listeningdevice/proc/bend_ear(mob/living/user)
	var/input = input(user, "SIX LETTERS", "BEND AN EAR")
	if(!input)
		label = null
		inqdesc = "An ever-attentive ear... [span_notice("This ear hasn't been bent. It's unlabelled.")]"
		desc = inqdesc
		return TRUE
	label = uppertext(trim(input, 7))
	inqdesc = "An ever-attentive ear... [span_notice("This ear's been bent. It's labelled as [label].")]"
	desc = inqdesc
	return TRUE

/obj/item/listeningdevice/proc/set_hidden(new_hidden)
	hidden = new_hidden
	if(hidden)
		alpha = 15
		name = "thing"
		desc = "What is that thing?.."
	else
		alpha = initial(alpha)
		name = initial(name)
		desc = initial(desc)

/obj/item/listeningdevice/proc/start_arming()
	stop_arming()
	arm_timer = addtimer(CALLBACK(src, PROC_REF(arm)), LISTENER_ARM_DELAY, TIMER_STOPPABLE)

/obj/item/listeningdevice/proc/stop_arming()
	if(arm_timer)
		deltimer(arm_timer)
		arm_timer = null

/obj/item/listeningdevice/proc/arm()
	arm_timer = null
	if(!deployed || QDELETED(src))
		return
	active = TRUE
	icon_state = "[initial(icon_state)]_active"
	update_icon()

/// Turns the listener off and returns it to its normal, visible, carried state.
/obj/item/listeningdevice/proc/retrieve()
	stop_arming()
	deployed = FALSE
	active = FALSE
	icon_state = initial(icon_state)
	set_hidden(FALSE)
	update_icon()

/obj/item/listeningdevice/pickup(mob/user)
	. = ..()
	if(deployed)
		retrieve()

/obj/item/listeningdevice/Moved(atom/OldLoc, Dir, Forced = FALSE)
	. = ..()
	if(!deployed)
		return
	if(isturf(loc))
		// Nudged along the floor: it has to sit still again before it listens.
		active = FALSE
		icon_state = initial(icon_state)
		start_arming()
	else
		retrieve()

#undef LISTENER_PLACE_DELAY
#undef LISTENER_ARM_DELAY
