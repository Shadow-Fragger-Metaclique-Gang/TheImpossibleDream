/obj/structure/ritualcircle
	var/blood_carver_name

/obj/structure/ritualcircle/proc/success_invoke()
	playsound(src, 'sound/magic/holyshield.ogg', 50, FALSE, -1)
	var/oldcolor = color
	color = rgb(255, 255, 255)
	animate(src, color = oldcolor, time = 5)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 0.5 SECONDS)

/obj/item/rogueweapon/huntingknife/examine(mob/user)
	. = ..()
	var/mob/living/L = user
	if(istype(L) && can_carve_patron_rune(L))
		. += span_cult("I can use this to draw the ritual circles using my blood.")

/obj/item/rogueweapon/huntingknife/proc/can_carve_patron_rune(mob/living/user)
	if(!ishuman(user) || !istype(user.patron, /datum/patron/inhumen) || !GLOB.surrealis_rune_types[surrealis_patron_rune(user.patron.type)])
		return FALSE
	return user.mind?.heretic_path || user.get_skill_level(/datum/skill/magic/ritualist)

/obj/item/rogueweapon/huntingknife/attack_self(mob/living/carbon/human/user)
	if(!can_carve_patron_rune(user))
		return ..()
	. = TRUE
	if(user.gloves)
		to_chat(user, span_warning("<i>My hand must be bare to open it.</i>"))
		return
	var/rune_type = GLOB.surrealis_rune_types[surrealis_patron_rune(user.patron.type)]
	var/turf/step_turf = get_step(get_turf(user), user.dir)
	if(!isopenturf(step_turf) || (locate(/obj/structure/ritualcircle) in step_turf) || (locate(/obj/effect/decal/cleanable/roguerune) in step_turf))
		to_chat(user, span_warning("<i>I can't carve a rune there.</i>"))
		return
	if(alert(user, "Open my palm and carve the rune of [get_god_name(user.patron)]?", "Carve", "Carve", "Not now") != "Carve")
		return
	to_chat(user, span_cultsmall("<i>I quietly draw the blade across my palm, and begin tracing the rune of [get_god_name(user.patron)] in my own blood...</i>"))
	playsound(user, get_sfx("genslash"), 30, TRUE, -4)
	var/obj/item/bodypart/palm = user.get_bodypart(user.active_hand_index % 2 ? BODY_ZONE_R_ARM : BODY_ZONE_L_ARM)
	if(palm)
		user.apply_damage(5, BRUTE, palm)
		palm.add_wound(/datum/wound/slash/small)
	if(do_after(user, 5 SECONDS, target = step_turf))
		var/atom/rune = new rune_type(step_turf)
		rune.add_atom_colour("#a01818", FIXED_COLOUR_PRIORITY)
		if(istype(rune, /obj/structure/ritualcircle))
			var/obj/structure/ritualcircle/circle = rune
			circle.blood_carver_name = user.real_name
			circle.blood_carver = WEAKREF(user)
		user.adjust_blood_corruption(5)
		to_chat(user, span_cultsmall("<i>The rune is finished, still wet.</i>"))
