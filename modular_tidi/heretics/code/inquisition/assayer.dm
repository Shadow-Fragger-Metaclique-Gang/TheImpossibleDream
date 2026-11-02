// Evil and fucked up inquisition blood testing machine
// It and a box of indexers and blood vials for said indexers comes at thirty minutes into the round
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
	var/list/tests = list()
	var/list/tracked_test

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

/obj/item/inqarticles/assayer/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen", "wielded")
				return list("shrink" = 0.7,"sx" = 0,"sy" = -2,"nx" = 0,"ny" = -2,"wx" = -4,"wy" = -2,"ex" = 4,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)

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
		. += span_info("Use a full vial in hand to mark a name on it first, and the HEMATIC ASSAYER will call by that name instead of a generic one.")
		. += span_info("Once the test is done it spits the vial back out, empty and ready to use again.")
		. += span_info("The HEMATIC ASSAYER remembers every test until ten minutes pass and the blood rots. Right-click it with no vial inside to fix it on one, and then use it in hand to follow the blood to its owner.")
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
	if(testing)
		return
	if(vial)
		if(!user.put_in_hands(vial))
			vial.forceMove(get_turf(src))
		vial = null
		update_icon()
		return
	for(var/list/test as anything in tests)
		if(world.time > test["time"] + 10 MINUTES)
			tests -= list(test)
	if(!length(tests))
		to_chat(user, span_warning("[src] doesn't know anyone's scents yet."))
		return
	var/list/choices = list()
	for(var/list/test as anything in tests)
		var/choice = "[test["label"] || "UNMARKED"] - [round((world.time - test["time"]) / (1 MINUTES))] minutes ago"
		while(choices[choice])
			choice += "."
		choices[choice] = test
	var/picked = input(user, "WHOSE BLOOD SHALL IT FOLLOW?", "HEMATIC ASSAYER") as null|anything in choices
	if(!picked || !user.Adjacent(src))
		return
	tracked_test = choices[picked]
	to_chat(user, span_notice("[src] fixes upon the blood of [tracked_test["label"] || "the unmarked vial"]."))

/obj/item/inqarticles/assayer/attack_self(mob/user)
	if(!tracked_test)
		to_chat(user, span_warning("[src] follows no blood."))
		return
	if(world.time > tracked_test["time"] + 10 MINUTES)
		say("THE SCENT HAS EXPIRED.")
		tracked_test = null
		return
	var/datum/weakref/subject_ref = tracked_test["subject"]
	var/mob/living/subject = subject_ref?.resolve()
	if(!subject || subject.stat == DEAD || !subject.z)
		say("THE BLOOD CANNOT BE FOUND.")
		return
	var/z_text = ""
	if(subject.z > user.z)
		z_text = ", SOMEWHERE ABOVE"
	else if(subject.z < user.z)
		z_text = ", SOMEWHERE BELOW"
	var/pull_dir = get_dir(user, subject)
	if(!pull_dir)
		if(z_text)
			say("THE BLOOD LIES [subject.z > user.z ? "ABOVE" : "BELOW"].")
		else
			say("THE BLOOD IS HERE.")
		return
	if(get_dist(user, subject) <= 10)
		say("THE BLOOD LIES TO THE [uppertext(dir2text(pull_dir))][z_text].")
	else
		say("THE BLOOD LIES TO THE [uppertext(dir2text(pull_dir))]. IT IS [get_dist(user, subject) <= 15 ? "NEARBY" : "FAR AWAY"][z_text].")

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
		var/blood_of = vial.label ? "THE BLOOD OF [uppertext(vial.label)]" : "THE BLOOD"
		if(rand(0, 99) < vial.subject_corruption)
			playsound(src, 'modular_tidi/heretics/sound/assayer_bad.ogg', 80, FALSE)
			say("[blood_of] FESTERS.")
		else
			playsound(src, 'modular_tidi/heretics/sound/assayer_good.ogg', 80, FALSE)
			say("[blood_of] RUNS CLEAN.")
		tests += list(list("label" = vial.label, "subject" = vial.subject, "time" = world.time))
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
