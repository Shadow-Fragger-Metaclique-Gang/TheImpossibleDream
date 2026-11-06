/datum/component/saintliness/zizo
	sleep_lines = list("Oh, you. Only the living need sleep.",
									   "Had any nightmares recently?",
									   "Drift away.")
	pray_lines = list("The Consortium of Bones will soon bring ruin upon the Pentacle and all their ilk.",
									  "Haha! Let them cry for mercy! Let them get on their knees. It might just save them.",
									  "Haven't you read the writing on the wall?",
									  "Prayers are merely words, and words are but wind.",
									  "Scribe your words into graven bones. For the dead remember.",
									  "No heavenly, pure realm awaits you. Only a shadowed path, and I shall be your light.",
									  "Out with it! Tell me what you truly fear and desire.")
	login_lines = list("Oh, you're not dead! Make them all quiver with fear!")
	death_lines = list("Get up.",
									   "Look at me. Not at the sky.",
									   "Did I allow you to die? No? I'll be making a note of this.",
									   "Who did this? Point if you still can. Do it.")
	conversion_lines = list("You dare stand before me?!",
											"Kuhuhu... so the divinations were true, after all...",
											"Hmph, I thought you'd be taller.")
	apostasy_lines = list("Ah. So that's how it is.",
										  "Kuhuhu.... of course you'd choose Them.",
										  "...One thing. Did you ever believe in it? Truly?")
	graverobber_lines = list("Good, good, good!",
											 "Oh, new servants for the cause!",
											 "Polish them, clean them. Wrap them in bandages. I'll let you decide what you do with that tangle of bones.",
											 "Oh, were they a stranger to you? Or someone you loved...?",
											 "Have no fear, these bones have committed many great sins in their day.",
											 "You did it wrong. Dug too deep and broke a bone. Typical...")
	compassion_lines = list("Stomp them, beat them.",
											"Grind their bones into flour.",
											"Mercy is just another obstacle in the path of the Inevitable Future.")

/datum/component/saintliness/zizo/Initialize(...)
	. = ..()
	// Graverobbing is an important aspect of necromancy.
	RegisterSignal(parent, COMSIG_MOB_GRAVEROBBER, PROC_REF(on_graverobber))
	// NO LOVE. NO KISSES. NO COMPASSION.
	RegisterSignal(parent, COMSIG_MOB_COMPASSION, PROC_REF(on_compassion))
	// NERD
	RegisterSignal(parent, COMSIG_MOB_TOMESCRIBE, PROC_REF(on_tomescribe))

/datum/component/saintliness/zizo/proc/on_graverobber(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(graverobber_lines)))
	adjust_saintliness(SAINTLINESS_FEAST)

/datum/component/saintliness/zizo/proc/on_compassion(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(compassion_lines)))
	adjust_saintliness(SIN_FEAST)

/datum/component/saintliness/zizo/proc/on_tomescribe(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(tomescribe_lines)))
	adjust_saintliness(SAINTLINESS_FEAST)

// Emoate Hooks

/datum/emote/living/spit/adjacentaction(mob/user, mob/target)
	. = ..()

	SEND_SIGNAL(user, COMSIG_MOB_COMPASSION)
