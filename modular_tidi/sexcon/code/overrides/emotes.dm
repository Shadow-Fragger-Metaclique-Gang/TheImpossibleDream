/datum/emote/living/carbon/human/bjiggle
	key = "bjiggle"
	key_third_person = "jiggles"
	message = "shakes their chest and bounces on the spot!"
	emote_type = EMOTE_VISIBLE
	show_runechat = TRUE

/proc/jiggle_duration_label(duration)
	if(duration > BREAST_JIGGLE_FREE_DURATION)
		return "[duration / 10] seconds (tiring)"
	return "[duration / 10] seconds"

/proc/jiggle_duration_choices()
	var/static/list/choices
	if(choices)
		return choices
	choices = list()
	for(var/duration = BREAST_JIGGLE_MIN_DURATION; duration < BREAST_JIGGLE_MAX_DURATION; duration += BREAST_JIGGLE_PROMPT_STEP)
		choices[jiggle_duration_label(duration)] = duration
	choices[jiggle_duration_label(BREAST_JIGGLE_MAX_DURATION)] = BREAST_JIGGLE_MAX_DURATION
	choices["Until I stop myself (very tiring)"] = BREAST_JIGGLE_ENDLESS
	return choices

/datum/emote/living/carbon/human/bjiggle/run_emote(mob/user, params, type_override, intentional)
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.dna || !H.dna.species || !H.dna.species.can_jiggle_breasts(H))
		return
	var/duration = BREAST_JIGGLE_MIN_DURATION
	var/endless = FALSE
	if(intentional && H.client)
		var/list/choices = jiggle_duration_choices()
		var/picked = tgui_input_list(H, "How long should I keep it up?", "Jiggle", choices)
		if(isnull(picked))
			return
		if(QDELETED(H) || !H.dna || !H.dna.species || !H.dna.species.can_jiggle_breasts(H))
			return
		var/chosen = choices[picked]
		if(chosen == BREAST_JIGGLE_ENDLESS)
			endless = TRUE
		else
			duration = chosen
	. = ..()
	if(!.)
		return
	var/obj/item/organ/breasts/B = H.getorganslot(ORGAN_SLOT_BREASTS)
	if(!B)
		return
	var/costs_stamina = endless || (duration > BREAST_JIGGLE_FREE_DURATION)
	if(costs_stamina && !H.jiggle_stamina_is_free() && H.stamina >= H.max_stamina)
		to_chat(H, span_warning("I am far too weary to keep this up."))
		duration = BREAST_JIGGLE_MIN_DURATION
		endless = FALSE
		costs_stamina = FALSE
	B.start_jiggle(duration, endless, costs_stamina)

/datum/emote/living/carbon/human/bjiggle/can_run_emote(mob/user, status_check = TRUE , intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	return H.dna && H.dna.species && H.dna.species.can_jiggle_breasts(H)

/mob/living/carbon/human/proc/do_jiggle_hop()
	animate(src, pixel_z = BREAST_JIGGLE_HOP_HEIGHT, time = BREAST_JIGGLE_CYCLE * 0.25, easing = SINE_EASING|EASE_OUT, flags = ANIMATION_RELATIVE|ANIMATION_PARALLEL)
	animate(pixel_z = -BREAST_JIGGLE_HOP_HEIGHT, time = BREAST_JIGGLE_CYCLE * 0.25, easing = SINE_EASING|EASE_IN, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)
	animate(pixel_z = BREAST_JIGGLE_HOP_HEIGHT, time = BREAST_JIGGLE_CYCLE * 0.25, easing = SINE_EASING|EASE_OUT, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)
	animate(pixel_z = -BREAST_JIGGLE_HOP_HEIGHT, time = BREAST_JIGGLE_CYCLE * 0.25, easing = SINE_EASING|EASE_IN, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)

/mob/living/carbon/human/proc/jiggle_stamina_is_free()
	if(!HAS_TRAIT(src, TRAIT_BATHHOUSE_DANCER))
		return FALSE
	return istype(get_area(src), /area/rogue/indoors/town/bath)

/mob/living/carbon/human/verb/emote_bjiggle()
	set name = "Jiggle"
	set category = "Emotes"

	var/obj/item/organ/breasts/B = getorganslot(ORGAN_SLOT_BREASTS)
	if(B?.is_jiggling)
		B.stop_jiggle()
		return
	emote("bjiggle", intentional = TRUE)
