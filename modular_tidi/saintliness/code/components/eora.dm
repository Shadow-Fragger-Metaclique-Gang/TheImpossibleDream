/datum/component/saintliness/eora
	var/static/list/sleep_lines = list("Lie away, lie away sleeping, lie away safe in my arms.",
									   "Oops! Now you'll have something to explain when you wake up.",
									   "THAT's the one you dream of? Huh!")
	var/static/list/pray_lines = list("My heart's throbbing, it's about to burst!",
									  "The City? Which one?!",
									  "Stop, that's sweeter than a lemon tart!",
									  "Those who find beautiful meanings in beautiful things are the cultivated. For such there is hope. They are my annointed to whom beautiful things mean only beauty.",
									  "Art can express anything!",
									  "Vice and virtue? Simply the viscous materials necessary for art, my love!",
									  "The only excuse for creating a useless thing is whether you admire it intensely.",
									  "All art is quite useless.",
									  "You want to know more about me? Do dig in at your own peril~~~ ♥")
	var/static/list/login_lines = list("Mwah!")
	var/static/list/death_lines = list("Oh, that definitely tickled something!")
	var/static/list/conversion_lines = list("Oh, hello there!",
											"Welcome to the flock!",
											"May serenity envelop you!")
	var/static/list/apostasy_lines = list("I'll still love you, even if you cut my heart out...")
	var/static/list/affection_lines = list("Nothing like it. Cherry-sweet love...",
										   "Cl-closer! Yes! YES!",
										   "So sweet... so good!")
	var/static/list/marriage_lines = list("Oh, what a Charming couple...",
										  "That's so romantic...",
										  "Oh my! How delightful! Mwah!")


/datum/component/saintliness/eora/Initialize(...)
	. = ..()
	// We love and care for everyone!
	RegisterSignal(parent, COMSIG_MOB_AFFECTION, PROC_REF(on_affection))
	RegisterSignal(parent, COMSIG_MOB_MARRIED, PROC_REF(on_marriage))

	// Uh oh... that's mean...
	RegisterSignal(parent, COMSIG_MOB_COMBAT_ACTIVATE, PROC_REF(on_combat_active))


// Emote Hooks

/datum/emote/living/kiss/adjacentaction(mob/user, mob/target)
	. = ..()

	SEND_SIGNAL(user, COMSIG_MOB_AFFECTION)
	SEND_SIGNAL(target, COMSIG_MOB_AFFECTION)
