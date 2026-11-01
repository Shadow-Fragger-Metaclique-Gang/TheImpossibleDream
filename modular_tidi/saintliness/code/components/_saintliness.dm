/// Keeps track of a given believer's "saintliness" and delivers remarks from the gods to the faith-haver.

/datum/component/saintliness
	// Yes, this is meant to reset once you convert to a different patron/religion. Tactical baptisms...
	// We'll consider 50 the starting baseline for now...
	// You shouldn't be able to lose this without knowing...
	var/saintliness = 50

	// There are a thousand comments saying not to create raw byond globals...
	// But when I look at more recent patches made to this, they seem to be used in the way one would typically expect. Oh well.
	// These are static because I don't want subtypes to all have their own list. Let's save on ram.
	// Yes, every single child of this'll have to override all these lines. Oh well.
	var/static/list/sleep_lines = list()
	var/static/list/pray_lines = list()
	var/static/list/login_lines = list()
	var/static/list/death_lines = list()
	var/static/list/conversion_lines = list()
	var/static/list/apostasy_lines = list()


/datum/component/saintliness/Initialize(...)
	. = ..()

	// Every patron will listen to a generic set of signals as a baseline.
	// More generic virtues/sins will be listened to in their own components.

	RegisterSignal(parent, COMSIG_MOB_SLEEP, PROC_REF(on_sleep))
	RegisterSignal(parent, COMSIG_CARBON_PRAY, PROC_REF(on_pray))
	RegisterSignal(parent, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_login))
	RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(on_death))
	RegisterSignal(parent, COMSIG_MOB_ON_RELIGIOUS_CONVERSION, PROC_REF(on_conversion))
	RegisterSignal(parent, COMSIG_MOB_ON_APOSTASY, PROC_REF(on_apostasy))

//Saintliness should stay between 1-100
/datum/component/saintliness/proc/adjust_saintliness(amount)
	var/sum = clamp(amount + saintliness, 1, 100)
	saintliness = sum


/datum/component/saintliness/proc/on_sleep(mob/living/worshipper)
	SIGNAL_HANDLER

	if(!sleep_lines.len)
		return

	to_chat(worshipper, span_faith(pick(sleep_lines)))

/datum/component/saintliness/proc/on_pray(mob/living/worshipper)
	SIGNAL_HANDLER

	if(!pray_lines.len)
		return

	to_chat(worshipper, span_faith(pick(pray_lines)))
	// Boost saintliness a bit because prayer's cheap and easy to do, but also a devout thing to do.
	// The devotion-boosting prayer clerics get doesn't do this because it's a dumb LRP mechanic.
	saintliness += SAINTLINESS_TOKEN

/datum/component/saintliness/proc/on_login(mob/living/worshipper)
	SIGNAL_HANDLER

	if(!login_lines.len)
		return

	to_chat(worshipper, span_faith(pick(login_lines)))

/datum/component/saintliness/proc/on_death(mob/living/worshipper)
	SIGNAL_HANDLER

	if(!death_lines.len)
		return

	to_chat(worshipper, span_faith(pick(death_lines)))

/datum/component/saintliness/proc/on_conversion(mob/living/worshipper)
	SIGNAL_HANDLER

	if(!conversion_lines.len)
		return

	to_chat(worshipper, span_faith(pick(conversion_lines)))

/datum/component/saintliness/proc/on_apostasy(mob/living/worshipper)
	SIGNAL_HANDLER

	if(!apostasy_lines.len)
		return

	to_chat(worshipper, span_faith(pick(apostasy_lines)))
