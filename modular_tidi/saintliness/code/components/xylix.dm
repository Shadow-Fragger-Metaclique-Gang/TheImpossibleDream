/datum/component/saintliness/xylix
	var/static/list/sleep_lines = list("Oh, don't worry. There's no one watching you sleep. Or is there?",
									   "Beautiful Soup, so rich and green, Waiting in a hot tureen! Who for such dainties would not stoop?",
									   "Tell me if you see any pink elephants... fuckers stole my digital tassles again.")
	var/static/list/pray_lines = list("What? A number between six and seven? Khi-hi-hi! No such, heh, thing, my beloved.",
									  "But when do the gronnwhals pork?",
									  "May the odds ever be in your favour.",
									  "IGNORED! Swampleaf time, honey!",
									  "Heh, that's just a fucking fairy tale for adults.",
									  "Cool story...",
									  "Ahaaha, ha...",
									  "I'm not a fucking... warrior. I'm not a pissing lover, either. But when it comes to the little silver fishies of fate... they hop to my tune.",
									  "Dance for me, fishie!",
									  "Don't talk about pointless and sad shit like that. Who do you take me for? That dipshit Necra?")
	var/static/list/login_lines = list("SURPRISE!")
	var/static/list/death_lines = list("Nothin' personal, kid...")
	var/static/list/conversion_lines = list("Charmed to have you with me.",
											"M'believer...",
											"Today you will be Euphoric.")
	var/static/list/apostasy_lines = list("No, you! Fucker!",
										  "Fucking shitweasel!",
										  "Don't go breaking any mirrors, asscob!")
	var/static/list/roll_lines = list("Roll six six six, and I'll- maybe not... forget it.",
									  "Oh.. you want me to rig the roll in your favour? HAHAHAAHAHAA!",
									  "I'm feeling RAMBUNCTIOUS!",
									  "I hope you bet your entire livelihood on this.",
									  "Dance, dance for me!",
									  "Roll the bones.")
	var/static/list/gamble_lines = list("They always quit before they hit it big. Don't worry. I've, heh, got your back.",
										"This is it... can't you taste it in the air? You're about to be rich.",
										"The higher you stack them up, the sweeter it'll be.",
										"What? You call that a wager?!",
										"Don't worry, I won't tell anyone if you're an absolute LOOOSER!")
	var/static/list/joy_lines = list("Aha, isn't this FUN?!",
									 "Savour it! It's not gonna last!",
									 "Call me Lil' Giggles, my debonaire friend.",
									 "Haw, haw, haaaaa!",
									 "Jackpot!",
									 "Auspicious!",
									 "Fortune smiles upon you!")
	var/static/list/sad_lines = list("Womp womp. Move on.",
									 "Boo!",
									 "Loser!",
									 "That was so funny I forgot to laugh.",
									 "Ever heard of GETTING OVER IT?",
									 "What a fucking poseur.")
	var/static/list/servility_lines = list("What the fuck're you doing?",
										   "Ya wanna know who deserves that kinda respect? ME!",
										   "I don't like sycophants.",
										   "Careful, chin's gonna turn brown...",
										   "Why don't you lay yourself on the ground like a doormat while you're at it?")

/datum/component/saintliness/xylix/proc/Initialize(...)
	. = ..()

	RegisterSignal(parent, COMSIG_MOB_DICE_ROLL, PROC_REF(on_roll))
	RegisterSignal(parent, COMSIG_MOB_GAMBLE, PROC_REF(on_gamble))

	// He's a bit of a jester, isn't he? It's all good.
	RegisterSignal(parent, COMSIG_MOB_JOY, PROC_REF(on_joy))
	RegisterSignal(parent, COMSIG_MOB_MOURN, PROC_REF(on_sad))

	// He hates servility or something like that?
	RegisterSignal(parent, COMSIG_MOB_DEMONSTATED_SERVILITY, PROC_REF(on_servility))

/datum/component/saintliness/xylix/proc/on_roll(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(parent, span_faith(pick(roll_lines)))
	adjust_saintliness(SAINTLINESS_TOKEN)

/datum/component/saintliness/xylix/proc/on_gamble(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(parent, span_faith(pick(gamble_lines)))
	adjust_saintliness(SAINTLINESS_FEAST)

/datum/component/saintliness/xylix/proc/on_joy(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(parent, span_faith(pick(joy_lines)))

	// A tad tempramental, innit.
	if(prob(80))
		adjust_saintliness(SAINTLINESS_TOKEN)
	else
		adjust_saintliness(SIN_TOKEN)

/datum/component/saintliness/xylix/proc/on_mourn(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(parent, span_faith(pick(mourn_lines)))

	// A tad tempramental, innit.
	if(prob(60))
		adjust_saintliness(SIN_FEAST)
	else
		adjust_saintliness(SAINTLINESS_TOKEN)

/datum/component/saintliness/xylix/proc/on_gamble(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(parent, span_faith(pick(gamble_lines)))
	adjust_saintliness(SIN_FEAST)

/datum/component/saintliness/xylix/proc/on_servility(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(parent, span_faith(pick(servility_lines)))
	adjust_saintliness(SIN_FEAST)

/obj/item/dice/attack_right(mob/user)
	. = ..()

	SEND_SIGNAL(user, COMSIG_MOB_DICE_ROLL)


