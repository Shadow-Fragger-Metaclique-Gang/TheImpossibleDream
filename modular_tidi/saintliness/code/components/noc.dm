/datum/component/saintliness/noc
	var/static/list/sleep_lines = list("Don't worry, your dreams simply contain valuable Information I'd like to have a look at.",
									   "Moonlit dreams stoke the mind. And lunacy. But disregard that last bit.")
	var/static/list/pray_lines = list("You clearly haven't read the Doctrines of Lunatic Rationality.",
									  "The High Decouplers will inherit the world.",
									  "What? What are you talking about? Increase the frequency with which you update me about your affairs! Ignored!",
									  "Banish logical uncertainty where it lies.",
									  "Decrease the inferential distance of your pleas. I'm trying to...",
									  "We only say that because it's easier to explain than the truth, close your inferential gaps and then we can talk Eye to Eye.",
									  "What a strange self-sampling assumption to make.",
									  "That isn't supported by any worldly scriptures. Opinion disregarded.",
									  "I prefer intelligent women myself, but that only leaves my sisters...",
									  "It's not enough being nice or smart. We live in a world that hates rationality...",
									  "Go read a book.",
									  "What? Marriage? A ridiculous and obsolete dyadic pairing. I prefer the 'orbital' system.",
									  "Be the solution, not the pollution.",
									  "The only thing that stands between dreams and reality is persistence.",
									  "Existence is a self-regulating system of awareness.",
									  "Wholeness quiets infinite phenomena.",
									  "This existence is nothing short of a refining canopy of spatial curiosity. We self-actualize, we reflect, we are reborn.",
									  "Passion is the driver of rebirth.",
									  "Where there is dogma, inspiration cannot thrive.",
									  "You are ruled by suffering without realizing it.",
									  "The dreamscape is calling to you via moonbeam transmission. Can you hear it?")
	var/static/list/login_lines = list("I don't need you to validate me, but it pleases me greatly that I've conditioned your mindlattice to seek me.")
	var/static/list/death_lines = list("One more anthropic shadow down.",
									   "Play stupid games, win stupid prizes.",
									   "Should have read a better book.")
	var/static/list/conversion_lines = list("Erm.. we'll designate your epistemic status as 'tenative'.",
											"This will be a mutually-beneficial dyadic partnership. What's that? Exclusivity? Ha-ha!")
	var/static/list/apostasy_lines = list("Imagine being offended by facts.",
										  "Frankly, I think your objection is simply a post-hoc rationalization of your childish whims. Be better.")
	var/static/list/bookburner_lines = list("I would sooner have you on a pyre than see a scrap of knowledge lost to the ages.",
											"N-no! Not that one!",
											"Th-that's a rare edition!")

/datum/component/saintliness/noc/Initialize(...)
	. = ..()
	// Just bookburning, really. There's nothing else a layman can really do for Noc. Revise this later.
	RegisterSignal(parent, COMSIG_MOB_BOOKBURNER, PROC_REF(on_bookburn))

/datum/component/saintliness/noc/proc/on_bookburn(mob/living/worshipper)
	SIGNAL_HANDLER

	to_chat(worshipper, span_faith(pick(bookburner_lines)))
	adjust_saintliness(SIN_FEAST)

// Hooks into bookburning
/obj/item/flashlight/flare/torch/afterattack(atom/movable/A, mob/user, proximity)
	. = ..()

	if(istype(A, /obj/item/book/rogue) || istype(A, /obj/structure/bookcase))
		SEND_SIGNAL(user, COMSIG_MOB_BOOKBURNER)
