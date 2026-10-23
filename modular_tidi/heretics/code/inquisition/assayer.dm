// Evil and fucked up inquisition blood testing machine
// It and a box of indexers and blood vials for said indexers comes at thirty minutes into the round

// TODO: Make the hematic assayer not call out people by name and instead point to a vague direction
// TODO: Make it so you can edit a label on the blood vials, maybe with a nice overlay sprite
/obj/item/inqarticles/assayer
	name = "HEMATIC ASSAYER"
	desc = "A blessed silver apparatus that boils a sample of blood and reads what festers in it."
	icon = 'modular_tidi/heretics/icons/assayer.dmi'
	icon_state = "assayer"
	w_class = WEIGHT_CLASS_HUGE
	grid_width = 32
	grid_height = 32
	twohands_required = TRUE
	possible_item_intents = list(/datum/intent/use)
	gripped_intents = list(/datum/intent/use)
	sellprice = 0
	verb_say = "blares"
	var/obj/item/inqarticles/blood_vial/vial
	var/testing = FALSE

/// If you wanna carry this thing around for on the go blood tests, have the absolver slave away with it
/// Don't let them lose it though! It's wholly unique and irreplaceable
/datum/component/storage/can_be_inserted(obj/item/storing, stop_messages, mob/user, worn_check = FALSE, params, storage_click = FALSE)
	if(istype(storing, /obj/item/inqarticles/assayer))
		if(user && !stop_messages)
			to_chat(user, span_warning("[storing] is far too unwieldy to stow away."))
		return FALSE
	return ..()

/obj/item/inqarticles/assayer/Destroy()
	QDEL_NULL(vial)
	return ..()

/obj/item/inqarticles/assayer/update_icon_state()
	if(testing)
		icon_state = "assayer_working"
	else
		icon_state = vial ? "assayer_full" : "assayer"
	return ..()

/obj/item/inqarticles/assayer/get_mechanics_examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		. += span_info("Insert a filled blood vial and middle-click the HEMATIC ASSAYER to test the blood.")
		. += span_info("Once the test is done it spits the vial back out, empty and ready to use again.")
		. += span_info("A sample that festers is likely corrupted, but not certainly. Neither result is proof on its own.")
		. += span_info("Vials containing cursed blood cannot be tested and should be put to use elsewhere.")

/obj/item/inqarticles/assayer/attackby(obj/item/I, mob/living/user, params)
	var/obj/item/inqarticles/blood_vial/new_vial = I
	if(!istype(new_vial))
		return ..()
	if(vial)
		to_chat(user, span_warning("[src] already holds a vial."))
		return TRUE
	if(new_vial.cursed)
		to_chat(user, span_warning("[src] refuses the cursed blood. There's nothing to test."))
		return TRUE
	if(!new_vial.subject_name)
		to_chat(user, span_warning("[new_vial] is empty."))
		return TRUE
	if(!user.transferItemToLoc(new_vial, src))
		return TRUE
	vial = new_vial
	update_icon()
	return TRUE

/obj/item/inqarticles/assayer/attack_right(mob/user)
	if(!vial || testing)
		return
	if(!user.put_in_hands(vial))
		vial.forceMove(get_turf(src))
	vial = null
	update_icon()

/obj/item/inqarticles/assayer/MiddleClick(mob/user, params)
	if(!isturf(loc) || !user.Adjacent(src))
		return ..()
	if(testing)
		to_chat(user, span_warning("[src] is already at work."))
		return
	if(!vial?.subject_name)
		to_chat(user, span_warning("[src] has no blood to test."))
		return
	INVOKE_ASYNC(src, PROC_REF(run_test), user)

/obj/item/inqarticles/assayer/proc/run_test(mob/user)
	testing = TRUE
	update_icon()
	playsound(src, 'modular_tidi/heretics/sound/assayer_working.ogg', 80, FALSE)
	visible_message(span_notice("[src] begins to boil the blood."))
	var/datum/progressbar/progbar = new(user, 5 SECONDS, src)
	var/endtime = world.time + 5 SECONDS
	var/starttime = world.time
	while(world.time < endtime)
		stoplag(1)
		if(QDELETED(src))
			break
		progbar.update(world.time - starttime)
	qdel(progbar)
	if(QDELETED(src))
		return
	if(vial?.subject_name)
		if(rand(0, 99) < vial.subject_corruption)
			playsound(src, 'modular_tidi/heretics/sound/assayer_bad.ogg', 80, FALSE)
			say("THE BLOOD OF [uppertext(vial.subject_name)] FESTERS.")
		else
			playsound(src, 'modular_tidi/heretics/sound/assayer_good.ogg', 80, FALSE)
			say("THE BLOOD OF [uppertext(vial.subject_name)] RUNS CLEAN.")
		vial.empty()
	sleep(2 SECONDS)
	if(QDELETED(src))
		return
	testing = FALSE
	playsound(src, 'modular_tidi/heretics/sound/assayer_finished.ogg', 80, FALSE)
	if(vial)
		vial.forceMove(get_turf(src))
		visible_message(span_notice("[src] spits out [vial]."))
		vial = null
	update_icon()
