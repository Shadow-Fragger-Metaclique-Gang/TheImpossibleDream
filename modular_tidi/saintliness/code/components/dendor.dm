/datum/component/saintliness/dendor
	var/static/list/sleep_lines = list("Hrrrrk! Grroaark!",
									   "An uneasy presence enters your dreams. A procession of beasts stampedes across barren, stone-laden lands. In their ranks are the canines and cows and other beasts of burden. Blood drips from their maws. Teeth grind against teeth, yearning for warm flesh to devour. They soon fade into the horizon, and you are left with nothing but wind pushing dust about a barren landscape that extends as far as your eyes can see.",
									   "Churning (Feasting) Crunching.")
	var/static/list/pray_lines = list("Eating sleeping eating feasting hunting (ruining) tasting maiming...",
									  "Itching and burning itching and burning.",
									  "Scream, scream!!!",
									  "Jackals screaming in the night!",
									  "Dead machines! CRUSH THEM CRUSH THEM CRUSH THEM!",
									  "Claw and fangs and blood and bone!",
									  "Kill masters. Live unchained."
									  "Destroytheyokedestroytheyokedestroytheyoke")
	var/static/list/login_lines = list("Something squirms behind your eyes.")
	var/static/list/death_lines = list("Blood for soil. Soil for blood.")
	var/static/list/conversion_lines = list("AAAUUUUUU!!!",
											"Be free, be untamed. Be WYLD!")
	var/static/list/apostasy_lines = list("Breakbreakbreakbreakyou!")
	var/static/list/tech_lines = list("The defiler's tools!",
									  "LET GO OF THAT! NOOOOOW!!"
									  "Grrraaaaaaaaaao!!")
	var/static/list/electrocution_lines = list("Hrrrrrrrr!",
											   "Hark hark hark!",
											   "Zzziiiing!")


/datum/component/saintliness/dendor/Initialize(...)
	. = ..()
	// Dendor definitely needs more 'stuff' to listen to.
	// But there isn't enough nature content other than farming/hunting.
	// This should probably be looked at if any 'nature' content for laymen gets added.

	// He hates technology.
	RegisterSignal(parent, COMSIG_MOB_USE_TECHNOLOGY, PROC_REF(on_tech_use))
	// Nature's force, Jack!
	RegisterSignal(parent, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocuted))

/datum/component/saintliness/dendor/proc/on_tech_use(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(tech_lines)))
	adjust_saintliness(SIN_MORSEL)

/datum/component/saintliness/dendor/proc/on_electrocuted(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(electrocution_lines)))
	adjust_saintliness(SAINTLINESS_FEAST)

// Hooks

/obj/structure/roguemachine/attack_hand(mob/user)
	. = ..()

	SEND_SIGNAL(user, COMSIG_MOB_USE_TECHNOLOGY)
