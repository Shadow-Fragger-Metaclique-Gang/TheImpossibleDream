/datum/component/saintliness/matthios
	sleep_lines = list("Dream of bloodshed, dream of revolution.",
									   "Dreams are the ozium of the masses.")
	pray_lines = list("The world deserved Zizo, fuck it, I'm saying it.",
									  "Soak the streets red in their rich pigboy blood!",
									  "Rent? No, I'd never pay rent.",
									  "All forms of taxation are theft. What? No, that's just a percentage I take for the benefit of the People.",
									  "They have taken everything from you, but you will take so much more.",
									  "Can you hear the people sing?",
									  "Our path is one totally antinomic and True.",
									  "Have no mercy for your class-enemies. They have sold their souls to Submission.",
									  "I love when my enemies hate me.",
									  "They got the money, but we got the people.",
									  "They call us radicals, I call it having a functioning brain.",
									  "Apparently, having an independent thought means you're a 'dangerous social nuisance'. Ha!",
									  "As long as you have your comrades, you have everything.",
									  "Never trust a fucking 'paladin'...")
	login_lines = list("Priviet, Comrade!")
	death_lines = list("Well, if you can't afford a chiurgeon, you die.",
									   "Oh... it says here that you're lighter than gold. Worthless. Rot in hell!!!",
									   "Don't worry, the noble houses could always make do with another limbless, inbred child. Haa... that one never gets old.",
									   "Right, right. Shh. Don't cry, you'll have a place in my Grand Revolutionary Palace... next Cycle.")
	conversion_lines = list("Dulia is the highest form of flattery.",
											"Ah, wonderful. Leave me your initial donation at the earliest opportunity.",
											"No more yokes. No more lies. Today, you will learn what it means to be truly Free.")
	apostasy_lines = list("WHAT?! A FUCKING WRECKER?!",
										  "Just another socially harmful element. Ridiculous. Find a ditch to die in already.",
										  "We'll put you on the pyre all the other reactionaries meet their end.",
										  "Sneeerk! The revolution's not going to wait for YOUR permission.",
										  "Burn like a bitch, then. I never really liked dogs anyway...")
	var/list/larceny_lines = list("There's no such thing as private property. You're just temporarily inhabiting a location.",
										 "Feh, landlords.",
										 "Our trailblazing path will open all doors.")
	var/list/thief_lines = list("Wealth well redistributed.",
									   "Ha! Take that, noble scum!",
									   "Maybe they should think of this as a involuntary donation.")
	var/list/servility_lines = list("Comrade! What are you doing?!",
										   "Stop that! You gave your yoke up, didn't you?!",
										   "Even the smallest grain of respect is too much for that piece of filth.")


/datum/component/saintliness/matthios/Initialize(...)
	. = ..()

	// Steal, rob, and disrespect nobles. We're the plight of the masses, the cream of the crop..
	RegisterSignal(parent, COMSIG_MOB_LARCENY, PROC_REF(on_larceny))
	RegisterSignal(parent, COMSIG_MOB_THIEF, PROC_REF(on_theft))

	// He hates servility or something like that? Oh yes, he's just Xylix, but evil.
	RegisterSignal(parent, COMSIG_MOB_DEMONSTATED_SERVILITY, PROC_REF(on_servility))

	// Taxation is the lowest form of submission.

/datum/component/saintliness/matthios/proc/on_larceny(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(parent, span_faith(pick(larceny_lines)))
	adjust_saintliness(SAINTLINESS_MORSEL)

/datum/component/saintliness/matthios/proc/on_theft(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(parent, span_faith(pick(thief_lines)))
	adjust_saintliness(SAINTLINESS_TOKEN)

/datum/component/saintliness/matthios/proc/on_servility(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(parent, span_faith(pick(servility_lines)))
	adjust_saintliness(SIN_DREADFUL)
