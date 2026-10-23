/obj/item/ritechalk/attack_self(mob/living/carbon/human/user)
	var/runeselection = surrealis_choose_rune(user)
	if(!runeselection)
		return
	var/turf/step_turf = get_step(get_turf(user), user.dir)
	to_chat(user, span_cultsmall("<i>I begin inscribing the rune of [surrealis_rune_god(runeselection)]...</i>"))
	if(do_after(user, 30, src))
		playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
		var/rune_type = GLOB.surrealis_rune_types[runeselection]
		var/atom/rune = new rune_type(step_turf)
		if(is_heretical_rune(rune))
			user.adjust_blood_corruption(5)
