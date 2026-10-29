/datum/component/saintliness/astrata
	var/static/list/sleep_lines = list("D-do you want me to wish you pleasant d-dreams? I-I'll never do that, never!",
										"J-just go to sleep already!"
										)
	var/static/list/pray_lines = list("W-what?! Eww!",
									  "W-what's the matter with you?!",
									  "Can't believe I have to shepherd you and my idiot siblings...",
									  "I-I am Astrata, the Sun Tyrant...",
									  "Is that really something you expect me to help you with?",
									  "D-did I do something wrong?!")
	var/static/list/login_lines = list("Ugh.. I thought you might be gone for good.")
	var/static/list/death_lines = list("Wait! N-no! Come back!",
									   "S-stop it, stop it, stop it! It wasn't meant to go this way!")
	var/static/list/conversion_lines = list("I-I really wasn't counting on you to worship me! R-really!",
											"Fine! I-I'll be your morning light!")
	var/static/list/apostasy_lines = list("Hmph!",
										  "A-as if I'll miss you!",
										  )
	var/static/list/fornication_lines = list("S-stop that!",
											 "N-no! Lewd!",
											 "Wait for marriage first, you idiot!")
	var/static/list/marriage_lines = list("N-no, I-I'm not jealous or anything... c-congratulations.")
	var/static/list/larceny_lines = list("Respect the privacy of others!!")
	var/static/list/respect_lines = list("D-don't let it get to your head! I-I'm still the one in charge here!",
										 "W-what?! They actually like you? Good!")
	var/static/list/peasant_servility_lines = list("Duty is as heavy as your future is bright.",
												   "Take my yoke and learn from me!")
	var/static/list/noble_servility_lines = list("You're supposed to be a leader, not a follower!",
										   "STOOOP! Wh-what're you fucking doing?!")

/datum/component/saintliness/astrata/Initialize(...)
	. = ..()
	RegisterSignal(parent, COMSIG_MOB_FORNICATION, PROC_REF(on_fornication))
	RegisterSignal(parent, COMSIG_MOB_MARRIAGE, PROC_REF(on_marriage))
	RegisterSignal(parent, COMSIG_CRIME_LARCENY, PROC_REF(on_larceny))
	RegisterSignal(parent, COMSIG_MOB_SHOWN_RESPECT, PROC_REF(on_respect))
	RegisterSignal(parent, COMSIG_MOB_DEMONSTATED_SERVILITY, PROC_REF(on_servility))

/datum/component/saintliness/astrata/proc/on_fornication(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(fornication_lines)))
	// It's sort of her whole thing...
	saintliness -= SAINTLINESS_EIDOLON

/datum/component/saintliness/astrata/proc/on_marriage(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(marriage_lines)))
	saintliness += SAINTLINESS_FEAST

/datum/component/saintliness/astrata/proc/on_respect(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(marriage_lines)))
	saintliness += SAINTLINESS_TOKEN

/datum/component/saintliness/astrata/proc/on_servility(mob/living/worshipper)
	SIGNAL_HANDLER

	// Nobles need to be haughty and confer respect, not confer it unto others...
	if(HAS_TRAIT(worshipper,TRAIT_NOBLE))
		to_chat(worshipper, span_faith(pick(noble_servility_lines)))
		saintliness -= SAINTLINESS_MORSEL
	else
		to_chat(worshipper, span_faith(pick(peasant_servility_lines)))
		saintliness += SAINTLINESS_MORSEL

