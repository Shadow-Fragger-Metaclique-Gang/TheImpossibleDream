/obj/structure/ritualcircle/baotha
	baotharites = list("Rite of Armaments", "Joybringer", "Unholy Boon of Fertility")

/obj/structure/ritualcircle/baotha/proc/fertility_boon_rite(mob/living/user)
	var/list/valids_on_rune = list()
	for(var/mob/living/carbon/human/peep in range(0, loc))
		valids_on_rune += peep
	if(!valids_on_rune.len)
		to_chat(user, "No valid targets on the rune!")
		return
	var/mob/living/carbon/human/target = input(user, "Choose a host") as null|anything in valids_on_rune
	if(!target || QDELETED(target) || target.loc != loc)
		return
	if(do_after(user, 50))
		user.say("Purple flame, awaken desire!")
		if(do_after(user, 50))
			user.say("Claim this body, shape it to your will!")
			if(do_after(user, 50))
				user.say("Let them burn for thee alone!")
				if(do_after(user, 50))
					icon_state = "baotha_active"
					baothablessing(target)
					addtimer(VARSET_CALLBACK(src, icon_state, "baotha_chalky"), 120)

/obj/structure/ritualcircle/baotha/proc/baothablessing(mob/living/carbon/human/target)
	if(!target || QDELETED(target) || target.loc != loc)
		to_chat(usr, "Selected target is not on the rune! [target.p_they(TRUE)] must be directly on top of the rune to receive Baotha's blessing.")
		return
	if(HAS_TRAIT(target, TRAIT_BAOTHA_FERTILITY_BOON))
		loc.visible_message(span_cult("They have already been blessed!"))
		return
	var/prompt = alert(target, "The Goddess of corrupted affection is about to give you the boon of fertility; to bear children!",, "Let it happen...", "Resist!")
	if(prompt == "Let it happen...")
		to_chat(target, span_warning("A strange feeling of warmth spreads inside your abdomen, growing hotter and hotter untill it almost feels like you are on fire, but pain actually never comes..."))
		target.Stun(60)
		target.Knockdown(60)
		target.sexcon.set_arousal(100)
		loc.visible_message(span_cult("[target] moans and shivers on top of the rune. Lashes of purple flame dance across their lower abdomen as a new marking appears against their form."))
		addtimer(CALLBACK(src, PROC_REF(baothablessing_stage2), target), 20)
	if(prompt == "Resist!")
		to_chat(target, span_warning("I sincerely proposed you my greatest blessing, and you rejected me? How foolish!"))
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
		target.emote("Agony")
		target.apply_damage(100, BRUTE, BODY_ZONE_CHEST)
		loc.visible_message(span_cult("[target] is violently thrashing atop the rune, writhing, as they dare to defy Baotha."))


/obj/structure/ritualcircle/baotha/proc/baothablessing_stage2(mob/living/carbon/human/target)
	var/mutable_appearance/marking_overlay = mutable_appearance('modular_tidi/sexcon/icons/baotha_marking.dmi', "marking_[target.gender == "male" ? "m" : "f"]", -BODY_LAYER)
	if(isdwarf(target) || isgoblinp(target) || iskobold(target) || iscritter(target))
		if(target.gender == MALE)
			marking_overlay.pixel_y -= 6
		else
			marking_overlay.pixel_y -= 4
	target.add_overlay(marking_overlay)
	target.update_body_parts()
	playsound(target, 'sound/health/fastbeat.ogg', 60)
	addtimer(CALLBACK(src, PROC_REF(baothablessing_stage3), target), 40)

/obj/structure/ritualcircle/baotha/proc/baothablessing_stage3(mob/living/carbon/human/target)
	to_chat(target, span_purple("Enjoy the new you!"))
	ADD_TRAIT(target, TRAIT_BAOTHA_FERTILITY_BOON, TRAIT_GENERIC)
	var/obj/item/organ/vagina/vagina = target.getorganslot(ORGAN_SLOT_VAGINA)
	if(vagina && !vagina.fertility)
		vagina.fertility = TRUE
