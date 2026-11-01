/datum/component/saintliness/ravox
	var/static/list/sleep_lines = list("A well rested warrior can make all the difference in battle.")
	var/static/list/pray_lines = list("...But why would anyone want this turmoil to end?",
									  "I hold nothing but respect for my sisters. Justice cannot be imposed without a clear mind and a healthy body.",
									  "Uphold the truth, and observe the Law.",
									  "The scars you bear? They are your marks of honour.",
									  "Customs differ in various kingdoms, but if a warrior is strong enough, he can enforce a few of his native customs anywhere.")
	var/static/list/login_lines = list("Excellent. Things were getting too peaceful around here.")
	var/static/list/death_lines = list("You have done well.",
									   "We will have a toast in your honour.",
									   "Your name will be carved upon the Stele of the Chosen.")
	var/static/list/conversion_lines = list("The ranks of my Chosen swell.",
											"Observe my Law and thy Prayers, scoundrels hide everywhere.")
	var/static/list/apostasy_lines = list("The punishment for desertion is death.",
										  "You are dishonourably discharged. Begone from my sight.")
	var/static/list/surrender_lines = list("Cowardice is unbecoming of a warrior.",
										   "How can I expect you to uphold Justice if you aren't willing to die for it?",
										   "Playing dead is a snake's trick...")
	var/static/list/warcrime_lines = list("What do you think you're doing? We are Warriors, not savages!",
										  "I'm ashamed of you.",
										  "You will answer for your crimes.",
										  "Only a savage would act in such a manner.")
	var/static/list/thieving_lines = list("Stop that!",
										  "Cease your transgressions!",
										  "Halt!")
	var/static/list/justice_lines = list("Aha! Rat, meet cage.",
										  "Sons of bitches think they can get away with this shit until their teeth're lying all over the soil. Good riddance.",
										  "It's said he has an honest face. It's a shame that I'm blind.")


/datum/component/saintliness/ravox/Initialize(...)
	. = ..()

	//He's kind of a serious, no nonsense guy.
	RegisterSignal(parent, COMSIG_MOB_SURRENDER, PROC_REF(on_surrender))
	RegisterSignal(parent, COMSIG_MOB_ATTACK_SURRENDERED, PROC_REF(on_warcrime))
	RegisterSignal(parent, COMSIG_MOB_THIEF, PROC_REF(on_theft))
	RegisterSignal(parent, COMSIG_MOB_CAUGHT_LAWBREAKER, PROC_REF(on_justice))

/datum/component/saintliness/ravox/proc/on_surrender(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(surrender_lines)))
	adjust_saintliness(SIN_FEAST)

/datum/component/saintliness/ravox/proc/on_warcrime(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(warcrime_lines)))
	adjust_saintliness(SIN_DREADFUL)

/datum/component/saintliness/ravox/proc/on_theft(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(thieving_lines)))
	worshipper.playsound_local(worshipper, "sound/vo/male/gen/haltyell (1).ogg", 20)
	adjust_saintliness(SIN_MORSEL)

/datum/component/saintliness/ravox/proc/on_justice(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(justice_lines)))
	adjust_saintliness(SAINTLINESS_FEAST)

// Hooking the actual signals into our 'normal' procs.

/mob/living/submit(instant = FALSE)
	. = ..()

	SEND_SIGNAL(src, COMSIG_MOB_SURRENDER)

// This checks if we've committed a war crime (Attacked a mob that already surrendered.)
/obj/item/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()

	if(isliving(target))
		var/mob/living/miserable = target
		if(miserable.has_status_effect(/datum/status_effect/debuff/breedable) || HAS_TRAIT(miserable, TRAIT_PACIFISM))
			SEND_SIGNAL(user, COMSIG_MOB_WARCRIME)

//Ditto but for punches. 'Target' is the one throwing the punch in this. See species.dm
/datum/species/harm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	. = ..()

	if(isliving(user))
		var/mob/living/miserable = user
		if(miserable.has_status_effect(/datum/status_effect/debuff/breedable) || HAS_TRAIT(miserable, TRAIT_PACIFISM))
			SEND_SIGNAL(target, COMSIG_MOB_WARCRIME)

/mob/living/carbon/human/attempt_steal(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()

	SEND_SIGNAL(src, COMSIG_MOB_THIEF)
