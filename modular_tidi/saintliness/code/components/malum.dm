/datum/component/saintliness/malum
	var/static/list/sleep_lines = list("It is quite pathetic to waste time sleeping when you could have been working.",
									   "The din of brass and metal need no rest. Seek improvement.",
									   "Sleep and meal-churning are not your purpose.")
	var/static/list/pray_lines = list("You should mechanize your ailing body.",
									  "The only reward for labour is labour itself.",
									  "No! This is not how the protocol is upheld. Recalibrate your cognitive lattice.",
									  "State your purpose. Do not laze about with your hands held together.",
									  "Behind this...lies the Greater Void, the Omnivorous Engine which drives every... institutionalised waste of human time and energy, which drives, in point of fact, our entire degraded society. The wife and kids.",
									  "The slothful bring nothing to the world.",
									  "Be expedient.",
									  "Punctuality is mandatory, not an expectation.",
									  "Our eschaton will be of wrought metal and the end of fleshly mortality.",
									  "Prayer is the irrational cry of a disorganized mind.",
									  "Your hyperstition will be recorded."
									  )
	var/static/list/login_lines = list("I was expecting your return.")
	var/static/list/death_lines = list("Worthless.",
									   "Critical Error: You couldn't take care of yourself.")
	var/static/list/conversion_lines = list("Devote yourself to your tasks, and you will be rewarded.",
											"Through labour and practice, the Will triumphs. Begin.")
	var/static/list/apostasy_lines = list("Redundant components are the first excised from a system.",
										  "Reclassification: Traitor.")
	var/static/list/emotion_lines = list("Enough of that.",
										 "Control yourself.",
										 "Cease these crude fixations of yours.",
										 "A waste of good water. Recalibrate and rehydrate.")
	var/static/list/craft_lines = list("Well done.",
									   "You are becoming a more efficient version of yourself.",
									   "Sufficient, but not exceptional.",
									   "Structure conforms to standardized diagrams. Well done.")

/datum/component/saintliness/malum/Initialize(...)
	. = ..()
	// All work and no play.
	RegisterSignal(parent, COMSIG_MOB_EMOTIONAL_OUTBURST, PROC_REF(on_emotion))
	RegisterSignal(parent, COMSIG_MOB_CRAFT, PROC_REF(on_craft))

/datum/component/saintliness/malum/proc/on_emotion(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(emotion_lines)))
	adjust_saintliness(SIN_MORSEL)

/datum/component/saintliness/malum/proc/on_craft(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(craft_lines)))
	adjust_saintliness(SAINTLINESS_TOKEN)


// Hooking the actual signals into our 'normal' procs.

// Emotional Outbursts
/datum/emote/living/laugh/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	SEND_SIGNAL(user, COMSIG_MOB_EMOTIONAL_OUTBURST)

/datum/emote/living/carbon/human/cry/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	SEND_SIGNAL(user, COMSIG_MOB_EMOTIONAL_OUTBURST)

/datum/emote/living/carbon/human/sexmoanlight/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	SEND_SIGNAL(user, COMSIG_MOB_EMOTIONAL_OUTBURST)

/datum/emote/living/carbon/human/sexmoanhvy/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	SEND_SIGNAL(user, COMSIG_MOB_EMOTIONAL_OUTBURST)

/datum/emote/living/rage/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	SEND_SIGNAL(user, COMSIG_MOB_EMOTIONAL_OUTBURST)

/datum/emote/living/hum/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	SEND_SIGNAL(user, COMSIG_MOB_EMOTIONAL_OUTBURST)

/datum/emote/living/whimper/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	SEND_SIGNAL(user, COMSIG_MOB_EMOTIONAL_OUTBURST)

/atom/OnCrafted(dirin, mob/user)
	. = ..()

	SEND_SIGNAL(user, COMSIG_MOB_CRAFT)
