/datum/component/saintliness/pestra
	var/static/list/sleep_lines = list("Even now, your entrails writhe and churn. Their visceral song is sweet music to my ears.")
	var/static/list/pray_lines = list("You should learn to crawl on your fourth pair of arms.",
									  "Entrust me your pain.",
									  "Necrotic flesh knows nothing of agony, and makes a fine home for my children.",
									  "Your bones are such beautiful, delicate things...",
									  "Thought must be dissected akin to flesh. Biases and morality stripped from our discerning eyes. Then we can assess the Idea with clear eyes.",
									  "A heart tickled by a sharpened stilletto.. shards of bone strewn about by a diremaul, scars that never heal... must it always be this way?")
	var/static/list/login_lines = list("Your flea told me you might be back.")
	var/static/list/death_lines = list("What a marvellous thing it will be to watch you rot.",
									   "You are so beautiful, my child. Your cadaver, love to me. Your putrid flesh lovingly cared for, for all eternity!")
	var/static/list/conversion_lines = list("Ours is the long road of healing.",
											"We knew you would see the beauty of decay.",
											"They tell you, you are sick, diseased. Rest in my arms, I will heal you.")
	var/static/list/apostasy_lines = list("Decompose, rot, turn to dust!",
										  "You have forfeit your soul, your flesh, blood, and your heart. The rats would like your heart most of all.")
	var/static/list/clean_lines = list("No! Stop that!",
									   "All those spores... lost.",
									   "W-why?! You were about to germinate!")

	var/static/list/rotdrinker_lines = list("Inwards, towards the rotcauldron.",
											"The nematodes are appreciative.",
											"As without, so within.")
	var/static/list/incision_lines = list("Open up, see the scars inside.",
										  "It flowers into a lovely scarlet.",
										  "Sweet blood...",
										  "Capilaries... veins... arteries.")
	var/static/list/vomit_lines = list("As within, so without.",
									   "Inner rot. Worldly rot.",
									   "Decay...")

/datum/component/saintliness/pestra/Initialize(...)
	. = ..()


	// Pestrans are filthy little bastards.
	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_clean))
	// Cultivate Rot
	RegisterSignal(parent, COMSIG_MOB_ROTDRINKER, PROC_REF(on_rotdrink))
	// Slicing into humen meat... red blood.
	RegisterSignal(parent, COMSIG_MOB_INCISE_SUCCESS, PROC_REF(on_incise))
	// Spew Rot
	RegisterSignal(parent, COMSIG_MOB_VOMIT, PROC_REF(on_vomit))

/datum/component/saintliness/pestra/proc/on_clean(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, pick(clean_lines))
	adjust_saintliness(SIN_FEAST)

/datum/component/saintliness/pestra/proc/on_rotdrink(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, pick(rotdrink_lines))
	// They can just drink rot over and over. This shouldn't be that big of a boost.
	adjust_saintliness(SIN_TOKEN)

/datum/component/saintliness/pestra/proc/on_incise(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, pick(incision_lines))
	adjust_saintliness(SAINTLINESS_MORSEL)

/datum/component/saintliness/pestra/proc/on_vomit(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, pick(vomit_lines))
	adjust_saintliness(SAINTLINESS_TOKEN)

