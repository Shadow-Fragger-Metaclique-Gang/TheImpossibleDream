/datum/component/saintliness/graggar
	sleep_lines = list("Dream of blood and flesh and bone.",
									   "No escape here, butterhead.",
									   "Sweet little bloodrosas, crunch squish...")
	pray_lines = list("Blood for sex!",
									  "Pum dee dum, pillage and rape...",
									  "Raraggghh... rra-rape...",
									  "Guahahahahahaa!",
									  "More. Kill more.",
									  "First the strong, then the tender ones..")
	login_lines = list("Hah... fresh meat.")
	death_lines = list("Mediocre.",
									   "Worthless...",
									   "Meat, mwuahahahaa!",
									   "Stupid...",
									   "Useless!!")
	conversion_lines = list("Join the bloodspill!",
											"Come to play!")
	apostasy_lines = list("Die!",
										  "Fat bitch.",
										  "Don't need you.")
	on_surrender = list("WORTHLESS!!",
										"Pathetic!",
										"Little sheep bitch.",
										"Baaaa!",
										"Bitch. Bitch. Bitch.",
										"Fat pussy lips.")
	on_butchery = list("Meatmeatmeatmeatmeat...",
									   "Sweet and tender flesh.",
									   "Savour sweet blood!",
									   "CONSUME! FEAST! DEVOUR!!",
									   "TO THE BONE!")

/datum/component/saintliness/graggar/Initialize(...)
	. = ..()

	// NO SURRENDER
	RegisterSignal(parent, COMSIG_MOB_SURRENDER, PROC_REF(on_surrender))
	// Cannibal Corpse
	RegisterSignal(parent, COMSIG_MOB_BUTCHER_LIMB, PROC_REF(on_butchery))

/datum/component/saintliness/graggar/proc/on_surrender(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(parent, span_faith(pick(surrender_lines)))
	adjust_saintliness(SIN_FEAST)

/datum/component/saintliness/graggar/proc/on_butchery(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(parent, span_faith(pick(butcher_lines)))
	adjust_saintliness(SAINTLINESS_MORSEL)

// Hewks

/obj/item/bodypart/MiddleClick(mob/living/user, params)
	. = ..()

	SEND_SIGNAL(user, COMSIG_MOB_BUTCHER_LIMB)
