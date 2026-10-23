// Quirks are mostly for flavor or provide very little (or focused on roleplay) benefits.
// At best they should be very minor conveniences as a reward for leaning into vices.
// The baseline point_cost is one.

/datum/quirk/acquiredtastes
	name = "Acquired Tastes"
	desc = "Despite my unorthodox tastes, I'm always prepared to handle a guest with the toys I keep stashed."
	mechdesc = "Adds a bag of sexual and bondage instruments to your stash."
	added_stashed_items = list("Bag of Fetish Gear" = /obj/item/storage/roguebag/fetish)

/obj/item/storage/roguebag/fetish
	populate_contents = list(
		/obj/item/clothing/mask/rogue/blindfold,
		/obj/item/chastity/chastity_cage,
		/obj/item/chastity/chastity_belt,
		/obj/item/reagent_containers/glass/bottle/alchemical/emberwine,
		/obj/item/dildo/wood,
		/obj/item/natural/cloth,
		/obj/item/rope/chain,
		/obj/item/rogueweapon/whip,
		/obj/item/rogueweapon/surgery/cautery/branding/crude
	)

/// AP Subtype
/datum/quirk/amphibious
	name = "Amphibious"
	desc = "Through some quirk of my heritage, I can breathe in water just as readily as in air."
	added_traits = list(TRAIT_WATERBREATHING)
	incompatible_virtues = list(/datum/virtue/combat/second_chance)
	allowed_species = list(/datum/species/anthromorph, /datum/species/anthromorphsmall, /datum/species/lizardfolk)

/datum/quirk/annoyingface
	name = "Annoying Face"
	desc = "<span style='font-family: \"Comic Sans MS\", cursive, sans-serif;'>My voice and face are viewed as annoying.</span>"
	point_cost = 0
	added_traits = list(TRAIT_COMICSANS)

/datum/quirk/assassintarget
	name = "Marked for Death"
	desc = "Something in my past has made me a target. I'm always looking over my shoulder."
	warning_text = "<span style='font-size:120%;'>THIS QUIRK ENCOURAGES ASSASSINS TO HUNT YOU DOWN!</span><br>\
	You may be PERMANENTLY KILLED WITHOUT ESCALATION in the process!"
	point_cost = 0
	drawback = TRUE
	added_traits = list(TRAIT_ASSASSIN_TARGET)

/// AP Subtype
/datum/quirk/bioluminescent
	name = "Luminous"
	desc = "Through some quirk of biology, I glow slightly."
	mechdesc = "The light only reaches your own tile, you won't be navigating by this."

/// AP Subtype
/datum/quirk/caustic
	name = "Prickly"
	desc = "Through quills, spines, or a caustic makeup, touching me isn't exactly pleasant."
	mechdesc = "Doesn't affect grabs."
	added_traits = list(TRAIT_CAUSTIC)
	allowed_species = list(/datum/species/ooze, /datum/species/anthromorph, /datum/species/anthromorphsmall, /datum/species/aasimar, /datum/species/dullahan)

/datum/quirk/deadnose
	name = "Dead Nose"
	desc = "My nose is numb to the smell of decay."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that already has a dead nose!"
	added_traits = list(TRAIT_NOSTINK)
	incompatible_traits = list(TRAIT_NOSTINK)

/datum/quirk/disgracednoble
	name = "Disgraced Noble"
	desc = "I was a scion of a noble house... long ago. Now I am a commoner, and my family name is a source of shame."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a noble!"
	added_traits = list(TRAIT_DISGRACED_NOBLE)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/dwarvenchef
	name = "Dwarven Chef"
	desc = "A dwarf once showed me the trick to cutting a proper pretzel from butterdough."
	mechdesc = "Lets you cut pretzels from butterdough."
	added_traits = list(TRAIT_DWARVEN_CHEF)
	restricted_species = list(/datum/species/dwarf/mountain, /datum/species/dwarf/gnome)

/datum/quirk/empath
	name = "Empath"
	desc = "I've always been in tune with the needs of others."
	mechdesc = "At a glance, you can tell if someone is hungry, thirsty, in pain, or stressed."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already an empath!"
	added_traits = list(TRAIT_EMPATH)
	incompatible_traits = list(TRAIT_EMPATH)
	incompatible_virtues = list(/datum/virtue/utility/socialite)

/// AP Subtype
/datum/quirk/feytouched
	name = "Feytouched"
	desc = "While I may not be as changed as some, I'm bound by pact or nature to the hag's cause."
	mechdesc = "You and the hag will know each other automatically and can communicate; however, you don't get the mechanical effects of the feybound virtue. You can reach out to the hag by interacting with a heartroot tree and whispering to the roots. You're expected to cooperate with them."
	added_traits = list(TRAIT_FEYTOUCHED)
	incompatible_virtues = list(/datum/virtue/utility/feytouched)

/// AP Subtype
/datum/quirk/goodlover
	name = "Fabled Lover"
	desc = "Making love with me will incur a greater bonus, and I can last longer in bed without running out of steam."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a fabled lover!"
	point_cost = 2
	added_traits = list(TRAIT_GOODLOVER)
	incompatible_traits = list(TRAIT_GOODLOVER)

/datum/quirk/gossiper
	name = "Gossiper"
	desc = "Despite my lowborn blood, I've made a habit out of brushing shoulders with the nobility and learning their secrets."
	mechdesc = "Lets you view noble gossip."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a noble!"
	point_cost = 2
	added_traits = list(TRAIT_GOSSIPER)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/hobbyistmusician
	name = "Hobbyist Musician"
	desc = "I've dabbled in music over the years, and I've stashed away an instrument of my own."
	mechdesc = "Comes with a stashed instrument of your choice. You choose the instrument after spawning in."
	added_skills = list(list(/datum/skill/misc/music, 1, 6))

/datum/quirk/hobbyistmusician/apply_to_human(mob/living/carbon/human/recipient)
	addtimer(CALLBACK(src, PROC_REF(pick_stashed_instrument), recipient), 50)

/datum/quirk/proc/pick_stashed_instrument(mob/living/carbon/human/recipient)
	var/list/instruments = list()
	for(var/instrument_type in subtypesof(/obj/item/rogue/instrument))
		if(instrument_type == /obj/item/rogue/instrument/harp/handcarved)
			continue //Skip the donator personal item harp.
		var/obj/item/rogue/instrument/instr = new instrument_type()
		instruments[instr.name] = instrument_type
		qdel(instr)  // Clean up the temporary instance

	var/chosen_name = input(recipient, "What instrument did I stash?", "STASH") as null|anything in instruments
	if(chosen_name)
		var/instrument_type = instruments[chosen_name]
		recipient.mind?.special_items[chosen_name] = instrument_type

/datum/quirk/hunted
	name = "Marked by Gnolls"
	desc = "For one reason or another, I have been deemed a target worthy of Graggar's champions. I hear their cackles anywhere I go."
	warning_text = "<span style='font-size:120%;'>THIS QUIRK ENCOURAGES GNOLLS TO HUNT YOU DOWN!</span><br>\
	You may potentially be killed in the process!"
	point_cost = 0
	drawback = TRUE
	added_traits = list(TRAIT_GNOLL_HUNTED)
	var/attempts_left = 10

// I genuinely couldn't tell you why this needs to be a thing, but it existed when hunted was a vice.
// Therefore, we're keeping the behavior now that it's a quirk.
/datum/quirk/hunted/apply_to_human(mob/living/carbon/human/recipient)
	log_hunted_pick(recipient)

/datum/quirk/hunted/proc/log_hunted_pick(mob/living/carbon/human/H)
	if(!H.name) // The vice version of hunted used Life() for its timing, so deleted mobs would automatically stop timing.
		if(attempts_left <= 0) // We're not riding off of that anymore, so let's have it give up after ten attemps a la Lawless.
			return
		attempts_left--
		addtimer(CALLBACK(src, PROC_REF(log_hunted_pick), H), 1 SECONDS)
		return
	log_hunted("[H.ckey] playing as [H.name] had the hunted trait by quirk.")

/datum/quirk/largeframe
	name = "Large Frame"
	desc = "I'm simply built bigger than most. My strength and hardiness has nothing to show for my size, though."
	mechdesc = "Increases your sprite size."
	point_cost = 3
	incompatible_virtues = list(/datum/virtue/size/giant)

/datum/quirk/largeframe/apply_to_human(mob/living/carbon/human/recipient)
	recipient.transform = recipient.transform.Scale(1.25, 1.25)
	recipient.transform = recipient.transform.Translate(0, (0.25 * 16))
	recipient.update_transform()

/// AP Subtype
/datum/quirk/linguist
	name = "Linguist"
	desc = "I like to read more than most, and keep my horizons broad."
	mechdesc = "Grants your choice of one additional language. If you have access to miracles, your patron's language - Abyssal for Abyssor, Beastish for Dendor, and the Chant for Zizo - may be selected."

/// AP Subtype
/datum/quirk/nightowl
	name = "Night Owl"
	desc = "For one reason or another, I've a nocturnal sleep cycle."
	mechdesc = "Compared to Nocian nocturnality, you will not gain a mood bonus when awake at night."
	added_traits = list(TRAIT_NIGHT_OWL_LESSER)
	incompatible_traits = list(TRAIT_NIGHT_OWL)

/// AP Subtype
/datum/quirk/nistean
	name = "Nistean"
	desc = "For religious or digestive reasons, I've sworn off meat. Abyssor's gifts, however, are fair game."
	point_cost = 0
	added_traits = list(TRAIT_NISTEAN)

/// AP Subtype
/datum/quirk/noble
	name = "Unlanded Noble"
	desc = "By birth or deeds, I've a high place in Astrata's order. My holdings, however, are too small or too far away to grant much benefit beyond a title."
	mechdesc = "Grants the noble trait, but no other benefits. Your mood will be affected more by performing ignoble actions due to a percieved inferiority to landed nobles."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a noble!"
	point_cost = 2
	added_traits = list(TRAIT_NOBLE, TRAIT_NOBLE_UNLANDED)
	incompatible_traits = list(TRAIT_NOBLE)
	restricted_species = list(/datum/species/construct/metal, /datum/species/dullahan, /datum/species/ooze)

/// AP Subtype
/datum/quirk/outdoorsman
	name = "Outdoorsy"
	desc = "My experience in the wilds allows me to fall asleep on surfaces like treebranches as if they were beds."
	mechdesc = "This does not make branches effective beds or allow you to walk on them, simply that you can sleep on them easily."
	added_traits = list(TRAIT_OUTDOORSMAN)
	incompatible_traits = list(TRAIT_NOBLE)
	incompatible_virtues = list(/datum/virtue/utility/woodwalker)
	allowed_species = list()

/datum/quirk/pretty
	name = "Pretty"
	desc = "I'm no great beauty, but people seem to like looking at my face well enough."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already beautiful!"
	point_cost = 2
	added_traits = list(TRAIT_PRETTY)
	incompatible_traits = list(TRAIT_BEAUTIFUL)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_quirks = list(/datum/quirk/ugly)

/datum/quirk/roughlover
	name = "Rough Lover"
	desc = "With strong intent, I am a violent partner in bed. Breaking pelvis and spirit alike."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a bedbreaker!"
	point_cost = 2
	added_traits = list(TRAIT_DEATHBYSNUSNU)
	incompatible_traits = list(TRAIT_DEATHBYSNUSNU)

/datum/quirk/scarred
	name = "Scarred"
	desc = "My face bears terrible scars that make identification difficult, but not impossible."
	point_cost = 0
	drawback = TRUE
	added_traits = list(TRAIT_SCARRED)

/datum/quirk/secondvoice
	name = "Second Voice"
	desc = "From performance, deception, or by a need to change yourself in uncanny ways, I've acquired a second, perfect voice. I may switch between them at any point."
	mechdesc = "Grants access to a new 'Memory' tab. It will have the options for setting and changing your voice."
	incompatible_vices = list(/datum/charflaw/mute, /datum/charflaw/unintelligible)

/datum/quirk/secondvoice/apply_to_human(mob/living/carbon/human/recipient)
	recipient.verbs += /mob/living/carbon/human/proc/changevoice
	recipient.verbs += /mob/living/carbon/human/proc/swapvoice

/mob/living/carbon/human
	var/second_voice
	var/original_voice

/mob/living/carbon/human/proc/changevoice()
	set name = "Change Second Voice (Can only use Once!)"
	set category = "IC"

	var/newcolor = input(src, "Choose your character's SECOND voice color:", "VIRTUE","#a0a0a0") as color|null
	if(newcolor)
		second_voice = sanitize_hexcolor(newcolor)
		src.verbs -= /mob/living/carbon/human/proc/changevoice
		return TRUE
	else
		return FALSE

/mob/living/carbon/human/proc/swapvoice()
	set name = "Swap Voice"
	set category = "IC"

	if(!second_voice)
		to_chat(src, span_info("I haven't decided on my second voice yet."))
		return FALSE
	if(voice_color != second_voice)
		original_voice = voice_color
		voice_color = second_voice
		to_chat(src, span_info("I've changed my voice to the second one."))
	else
		voice_color = original_voice
		to_chat(src, span_info("I've returned to my natural voice."))
	return TRUE

/// AP Subtype
/datum/quirk/tainted
	name = "Tainted"
	desc = "My lux bears some manner of curse; it cannot be safely transplanted."
	mechdesc = "You will be unable to donate lux to revive others."
	point_cost = 0
	drawback = TRUE
	added_traits = list(TRAIT_TAINTEDLUX)
	restricted_species = list(/datum/species/tieberian, /datum/species/construct/metal)

/// AP Subtype
/datum/quirk/ugly
	name = "Ugly"
	desc = "My face is ugly and makes everyone who looks at me miserable."
	mechdesc = null
	point_cost = 0
	drawback = TRUE
	added_traits = list(TRAIT_UNSEEMLY)
	incompatible_virtues = list(/datum/virtue/utility/socialite)

/datum/quirk/underdarkchef
	name = "Underdark Chef"
	desc = "I've picked up a few culinary secrets from the Underdark. Spider meat is more versatile than you'd think."
	mechdesc = "Allows you to prepare recipes utilizing spider meat."
	added_traits = list(TRAIT_UNDERDARK_CHEF)
	restricted_species = list(/datum/species/elf/dark)

/datum/quirk/unsettling
	name = "Unsettling"
	desc = "My appearance is deeply unsettling to most."
	mechdesc = "People who examine you may either be unsettled or indifferent to your uncanny appearance."
	drawback = TRUE
	added_traits = list(TRAIT_UNSETTLING)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_quirks = list(/datum/quirk/ugly, /datum/quirk/pretty)

/// AP Subtype
/datum/quirk/vegan
	name = "Végétal"
	desc = "For religious or digestive reasons, I've sworn off meat, dairy, and everything else that comes from animals."
	point_cost = 0
	added_traits = list(TRAIT_VEGAN)

/// AP Subtype
/datum/quirk/wellknown
	name = "Well-known"
	desc = "I may not be a resident of Pharos myself, but I spend enough time in and around the city that my face and name are known."
	mechdesc = "You will be treated as a resident for purposes of knowing, and being known by, those in town. Be warned: this will allow others to message, scry, and otherwise know about you from afar."
	added_traits = list(TRAIT_WELLKNOWN)
	incompatible_virtues = list(/datum/virtue/utility/notable)

/// AP Subtype
/datum/quirk/wyldeater
	name = "Wyld Metabolism"
	desc = "Be it a boon of Dendor or a quirk of anatomy, I can handle consuming things most people would consider poisonous."
	added_traits = list(TRAIT_WILD_EATER)
	point_cost = 2
