/datum/component/saintliness/necra
	var/static/list/sleep_lines = list("And yet, even in your dreams I grow nearer.",
									   "One day, you will dream your last.",
									   "I can hear the thunder cracking in your heart.")
	var/static/list/pray_lines = list("Here you rest your weary body, here on the worldmantle. When you die, they will put your body in a box and dispose of it in the cold ground. And in the million ages to come, you will never breathe, or laugh, or twitch again. Fate has spared you this moment.",
									  "I offer you impartiality. I offer you the Law.",
									  "Your youth can not be forgiven, it must be accused.",
									  "Fate is a series of deaths linked by coincidence and the idiot dream of hope.",
									  "This world already has a place in our grand obituary.",
									  "One day, you will disappear in every way.",
									  "...",
									  "Do not allow the Law to be used corruptly. The scales must be calibrated and clean.",
									  "Revere your elders, they know me better.",
									  "Mourning is our celebration of a life lived. Not a life well lived.",
									  "Roll the bones.")
	var/static/list/login_lines = list("And yet you live...")
	var/static/list/death_lines = list("Linear causality finally comes to an end.",
									   "Death is but one moment.",
									   "Turbulent are the waters. The river lies before you. Take care not to fall overboard.",
									   "You have run out of tomorrows.",
									   "Oh, lie away, lie away dying, lie away safe in my arms...",
									   "Judgement awaits. Won't you embrace eternity?",
									   "And in a moment you've lost much: The warmth of a beating heart, the scent of petrichor, the gay chirp of a morning songbird. Never to be experienced again.")
	var/static/list/conversion_lines = list("Consider this the first day of the rest of your existence.")
	var/static/list/apostasy_lines = list("Verdict: Guilty. Your soul will be tortured for eternity.")
	var/static/list/graverobbing_lines = list("That taken from hallowed ground will one day return to it.",
											  "Refrain from disturbing the restful dead.",
											  "Your mortal gains will be a fraction of your suffering in eternity.",
											  "Your soul is forfeit.",
											  "Your ancestors will frown upon you for eternity.")
	var/static/list/looting_lines = list("Let the restful dead lie.",
										 "Pilfering the bones, are we?",
										 "What an imprudent act.")
	var/static/list/joy_lines = list("Remember death, there will be time enough to smile in your grave.",
									 "Laughter invites discord to the hymns of the world-funeral.",
									 "Sully graven lands not with your babbles of idiocy.")
	var/static/list/mourn_lines = list("Bear witness and prepare.",
									   "Life fades, and lamentation takes its place.",
									   "Cherish the memory, but care not to tarnish it.")

/datum/component/saintliness/necra/Initialize(...)
	. = ..()

	// The evillest thing a Necran can do.
	RegisterSignal(parent, COMSIG_MOB_GRAVEROBBER, PROC_REF(on_graverobber))
	// No looting the dead!!!
	RegisterSignal(parent, COMSIG_MOB_STRIPPER, PROC_REF(on_loot))
	// Necrans don't laugh, or something like that. They're not a jolly set of fellows. They're very emo.
	RegisterSignal(parent, COMSIG_MOB_JOY, PROC_REF(on_joy))
	RegisterSignal(parent, COMSIG_MOB_MOURN, PROC_REF(on_mourn))


/datum/component/saintliness/necra/proc/on_graverobber(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(graverobbing_lines)))
	adjust_saintliness(SIN_DREADFUL)

/datum/component/saintliness/necra/proc/on_loot(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(looting_lines)))
	adjust_saintliness(SIN_FEAST)

/datum/component/saintliness/necra/proc/on_joy(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(joy_lines)))
	adjust_saintliness(SIN_TOKEN)

/datum/component/saintliness/necra/proc/on_mourn(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(mourn_lines)))
	adjust_saintliness(SAINTLINESS_TOKEN)

// Emote Hooks

/datum/emote/living/laugh(mob/living/user, params, type_override, intentional)
	. = ..()
	SEND_SIGNAL(user, COMSIG_MOB_JOY)

/datum/emote/living/smile(mob/living/user, params, type_override, intentional)
	. = ..()
	SEND_SIGNAL(user, COMSIG_MOB_JOY)

/datum/emote/living/sigh(mob/living/user, params, type_override, intentional)
	. = ..()
	SEND_SIGNAL(user, COMSIG_MOB_MOURN)

/datum/emote/living/carbon/human/cry/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	SEND_SIGNAL(user, COMSIG_MOB_MOURN)

/datum/emote/living/whimper/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	SEND_SIGNAL(user, COMSIG_MOB_MOURN)
