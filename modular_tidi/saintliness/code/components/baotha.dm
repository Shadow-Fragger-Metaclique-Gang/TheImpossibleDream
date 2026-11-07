/datum/component/saintliness/baotha
	sleep_lines = list("Sorry about the sheets, love!",
									   "Calm down, it's only a slick nightreverie")
	pray_lines = list("The nights were as boring as the days. Well, until he took out the polished cucumber...",
									  "Ugh, people these days are so boring... no one appreciates just how succulent a dangling jawbone can be once you've found the Right one.",
									  "Hoo... I think your wiles might soon be indulged..",
									  "The needles sink into delicate and tender flesh, then we take out the wires...",
									  "One can always be fitter, happier, more attractive.",
									  "Let a shiver down your spine and into your prized lockbox. Feel it quake.",
									  "Abandon the dry and bitter inhibitions of normalcy. The honey is sweet and viscous.",
									  "A cut here, a small adjustment there... you'll be beautiful.",
									  "Again, again, and again!",
									  "Ever gone ass to ass? Oh..?",
									  "I wonder how you'll moan if I tear your heart out.")
	login_lines = list("You're back! Oh, one handed this time...")
	death_lines = list("What a waste of pilgefluid...",
									   "Now you're only good for my Zealots...",
									   "We'll call you my stiffy from now on...")
	conversion_lines = list("Oho~ Happy to have you here, love!",
											"Just make sure to share yourself with the congregation...")
	apostasy_lines = list("Now I don't kiss and tell, but...",
										  "Ever wanted to know what it's like to be neutered?")
	var/list/fornication_lines = list("All part of the Lifestyle.. you should be used to it by now.",
											 "A-ah.. how scandalous.",
											 "That's the way I like it, uhuh, uhuh.",
											 "Don't be gentle.")
	var/list/whipped_lines = list("Don't be a coward. Have some more!",
										 "Sweet, sweet pain!",
										 "Pain, sweet pain!",
										 "What a lovely dose of suffering.",
										 "To the core of your being...")
	var/list/druggalo_lines = list("MORE! MORE! MORE!",
										  "I DID IT ALL FOR NOTHING BUT.... EXCESS!!",
										  "Breathe the smoke in...",
										  "One more trial...",
										  "SCREAM INTO THE VOID!",
										  "This is the last kiss.",
										  "Empty the vial before you die.",
										  "Excess! Excess! Excess!")
	var/list/asceticism_lines = list("No, no, no! You have to INDULGE!",
											"Hungry sows don't let themselves grow hungry.",
											"Don't you want to feast and slake your thirst?",
											"Think of this world as my world, and drink from its rivers of wine.",
											"Teetotallers... ugh.")


/datum/component/saintliness/baotha/Initialize(...)
	. = ..()
	// Chastity and temperance are her only sins... but there's no way to tell if someone's NOT doing something...

	RegisterSignal(parent, COMSIG_MOB_FORNICATION, PROC_REF(on_fornication))
	// Whips and chains excite me.
	RegisterSignal(parent, COMSIG_MOB_WHIPPED, PROC_REF(on_whipped))
	RegisterSignal(parent, COMSIG_MOB_HIGH, PROC_REF(on_druggalo))

	// Asceticism is the act of withholding oneself food and drink... Baotha is quite the hylic.
	RegisterSignal(parent, COMSIG_MOB_ASCETICISM, PROC_REF(on_ascetic))

/datum/component/saintliness/baotha/proc/on_fornication(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(fornication_lines)))
	adjust_saintliness(SAINTLINESS_MORSEL)

/datum/component/saintliness/baotha/proc/on_whipped(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(whipped_lines)))
	adjust_saintliness(SAINTLINESS_TOKEN)

/datum/component/saintliness/baotha/proc/on_druggalo(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(druggalo_lines)))
	adjust_saintliness(SAINTLINESS_FEAST)

/datum/component/saintliness/baotha/proc/on_ascetic(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(asceticism_lines)))
	adjust_saintliness(SAINTLINESS_FEAST)

// Drug Stuff

/datum/status_effect/buff/ozium/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_HIGH)

/datum/status_effect/buff/moondust/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_HIGH)

/datum/status_effect/buff/moondust_purest/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_HIGH)


/datum/status_effect/buff/herozium/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_HIGH)

/datum/status_effect/buff/starsugar/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_HIGH)

/datum/status_effect/buff/weed/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_HIGH)

/datum/status_effect/debuff/emberwine/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_HIGH)

/datum/status_effect/buff/weed/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_HIGH)

/datum/status_effect/buff/drunk/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_HIGH)

// Asceticism and Hunger
/datum/status_effect/debuff/hungryt1/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_ASCETICISM)

/datum/status_effect/debuff/hungryt2/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_ASCETICISM)

/datum/status_effect/debuff/hungryt3/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_ASCETICISM)

/datum/status_effect/debuff/thirstyt1/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_ASCETICISM)

/datum/status_effect/debuff/thirstyt2/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_ASCETICISM)

/datum/status_effect/debuff/thirstyt3/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_MOB_ASCETICISM)

// Hooks to the intents related to whips.. heheh.
/obj/item/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	// This is somehow literally the only way to check if someone was whipped or not.
	// Intents don't know anything about what they're clicking with on_mouse_up
	if(istype(user.used_intent, /datum/intent/whip))
		SEND_SIGNAL(target, COMSIG_MOB_WHIPPED)

