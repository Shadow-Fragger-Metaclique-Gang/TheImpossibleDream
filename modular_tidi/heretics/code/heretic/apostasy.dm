/datum/stressevent/heard_zizo
	timer = 4 MINUTES
	stressadd = 10 // Intentionally more effective against non combat classes, get out of the hyperwar mister acolyte
	stressadd_per_extra_stack = 10
	max_stacks = 20
	desc = span_boldred("That accursed name! Why would anyone speak it?!")

/datum/stressevent/heard_zizo/steelhearted
	timer = 2 MINUTES
	stressadd = 2
	stressadd_per_extra_stack = 2
	desc = span_red("Someone spoke the Demiurge's accursed name. How tiresome.")

/datum/stressevent/zizo_noticed
	timer = 4 MINUTES
	max_stacks = 20
	stressadd = 4 // So people don't shout ZIZO as a Graggoid because it's more effective of a stress dunk
	stressadd_per_extra_stack = 5
	desc = span_boldred("ZIZO's gaze sends chills down my spine...")

// This is an abominable system but I've tried to keep it relatively slim for what it's doing
// Basically, if you say the name of any of the four, they gain storyteller influence
// If it's specifically ZIZO, non four worshippers get stress and signals for the heretic proselytize objective to progress
// Yes, that means heretics get stress for saying but not stress for hearing ZIZO but that's more of a balancing measure than anything else

/atom/movable/say_quote(input, list/spans = list(speech_span), message_mode, plaintext_input)
	var/static/regex/zizo_color = regex(@"\b(zizo)\b(?![^<]*>)", "gi")
	var/static/regex/evil_color = regex(@"\b(graggar|matthios|baotha)\b(?![^<]*>)", "gi")
	if(!input)
		return ..()
	if(!findtext(input, "zizo") && !findtext(input, "graggar") && !findtext(input, "matthios") && !findtext(input, "baotha")) // Least performance annihilating check first
		return ..()
	if(isnull(plaintext_input))
		plaintext_input = input
		input = parsemarkdown_basic(input, limited = TRUE, barebones = TRUE)
	if(!iscarbon(src)) // Mostly directed at SCOMs but any non carbon trying to say the name will be garbled
		input = zizo_color.Replace(input, stars("ZIZO", 50))
		return ..(input, spans, message_mode, plaintext_input)
	input = zizo_color.Replace(input, "<span class='pulsedeath'>$1</span>") // Zizo is throbbing red (hehe throb penis sex) other three are just evil red
	input = evil_color.Replace(input, "<span style=\"color:#cc0000\">$1</span>")
	return ..(input, spans, message_mode, plaintext_input)

GLOBAL_DATUM_INIT(zizo_name, /regex, regex(@"\bzizo\b", "i"))
GLOBAL_DATUM_INIT(graggar_name, /regex, regex(@"\bgraggar\b", "i"))
GLOBAL_DATUM_INIT(matthios_name, /regex, regex(@"\bmatthios\b", "i"))
GLOBAL_DATUM_INIT(baotha_name, /regex, regex(@"\bbaotha\b", "i"))

/mob/living/carbon/human
	var/list/zizo_speakers

/mob/living/carbon/human/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	. = ..()
	var/mob/living/carbon/talker = speaker
	if(!client || !istype(talker) || talker == src)
		return
	if(!findtext(raw_message, "zizo") || !findtext(raw_message, GLOB.zizo_name))
		return
	if(istype(patron, /datum/patron/inhumen) || HAS_TRAIT(src, TRAIT_NOMOOD))
		return
	addtimer(CALLBACK(src, PROC_REF(zizo_reaction), talker), 1 SECONDS) // Wait so the reactions come after the message
	if(!has_stress_event(/datum/stressevent/heard_zizo) && !has_stress_event(/datum/stressevent/heard_zizo/steelhearted))
		zizo_speakers = null
	if(WEAKREF(talker) in zizo_speakers) // One guy spamming ZIZO doesn't stack, now a horde of skeletons on the other hand
		return
	LAZYADD(zizo_speakers, WEAKREF(talker))
	add_stress(HAS_TRAIT(src, TRAIT_STEELHEARTED) ? /datum/stressevent/heard_zizo/steelhearted : /datum/stressevent/heard_zizo)
	SEND_SIGNAL(talker, COMSIG_HERETIC_APOSTASY_HEARD, src)

/mob/living/carbon/human/proc/zizo_reaction(mob/living/talker)
	if(stat != CONSCIOUS || cmode)
		return
	face_atom(talker)
	if(prob(20))
		emote("gasp", forced = TRUE)

/mob/living/carbon/human/treat_segmented_message(message, datum/language/language)
	. = ..()
	message = .
	if(findtext(message, "zizo") && findtext(message, GLOB.zizo_name))
		if(!istype(patron, /datum/patron/inhumen) && !HAS_TRAIT(src, TRAIT_NOMOOD) && get_stress_amount() < STRESS_INSANE) // If you're tweaking you can say ZIZO for fun
			to_chat(src, span_warning("<i>The name catches in my throat.</i>"))
			visible_message(span_warning("[src] suddenly turns pale and begins to tremble!"), ignored_mobs = src)
			add_stress(/datum/stressevent/zizo_noticed)
			return ""
		adjust_storyteller_influence("Zizo", 1)
		if(istype(patron, /datum/patron/inhumen) && !HAS_TRAIT(src, TRAIT_CABAL))
			add_stress(/datum/stressevent/zizo_noticed)
			to_chat(src, span_warning("Uttering ZIZO's name attracts ITS gaze."))
	if(findtext(message, "graggar") && findtext(message, GLOB.graggar_name))
		adjust_storyteller_influence("Graggar", 1)
	if(findtext(message, "matthios") && findtext(message, GLOB.matthios_name))
		adjust_storyteller_influence("Matthios", 1)
	if(findtext(message, "baotha") && findtext(message, GLOB.baotha_name))
		adjust_storyteller_influence("Baotha", 1)
