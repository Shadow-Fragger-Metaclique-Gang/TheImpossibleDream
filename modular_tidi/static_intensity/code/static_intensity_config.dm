// STATIC_INTENSITY - the ONE file to edit when tuning the static roundstart intensity.
//
// Each value is the number of roundstart slots for that antagonist. 0 = disabled.
//
// Major (hard) antagonists: only ONE of these rolls per round, picked at random among those above 0.
// All of them still need HARD_ANTAG_MIN_POP (40) players to roll.
// Soft antagonists: opened as job slots.
//
// Wretch and Bandit are intentionally 0 for this intensity.
/datum/controller/subsystem/gamemode
	admin_slots = list(
		// Major antagonists
		"Lich" = 1,
		"VL" = 1,
		"Werewolf" = 1,
		"Masquerade" = 1,
		"Rebel" = 1,
		"Bandit" = 0,
		// Soft antagonists
		"Wretch" = 3,
		"Gnoll" = 2,
		"Hag" = 1,
		"Assassin" = 0,
	)

// Roundstart odds between the major antagonists that are enabled above (slots > 0).
// An antagonist's chance is its weight divided by the total weight of the enabled ones, e.g. Lich 20 vs
// Werewolf 10 = 2/3 vs 1/3. A weight of 0 never rolls. Setting a slot above to 0 removes it from the roll entirely.
/datum/round_event_control/antagonist/solo/lich
	weight = 10

/datum/round_event_control/antagonist/solo/vampires
	weight = 9

/datum/round_event_control/antagonist/solo/werewolf
	weight = 7

/datum/round_event_control/antagonist/solo/masquerade
	weight = 8

/datum/round_event_control/antagonist/solo/rebel
	weight = 10

// ---------------------------------------------------------------------------------------------------------
// MIDROUND EVENTS
// These fire later in the round and never change the roundstart slots above.
//
// Every event can have these vars edited (the commented values are the current upstream values):
//   max_occurrences                 how many times it can happen per round. 0 disables the event.
//   weight                          how likely it is to be picked compared to the other events on its track.
//   min_players                     minimum number of alive, non-AFK players needed.
//   earliest_start                  earliest time into the round it can fire (e.g. 25 MINUTES).
//   cost                            multiplier on the track's point threshold it costs to buy the event.
//   reoccurence_penalty_multiplier  how much its weight drops each time it (or its shared type) has happened.
//   track                           which event track it is bought on (EVENT_TRACK_*).
//   shared_occurence_type           events sharing a type count towards each other's repetition penalty.
// The server config may scale min_players and earliest_start (events_min_players_mul / events_min_time_mul).
//
// Slots opened by an event are limited, so the reachable total is the lower of the cap and
// (roundstart slots + slots per occurrence * max_occurrences).
// ---------------------------------------------------------------------------------------------------------

// --- Edited events ---

// Wandering Lich migrant wave (disabled upstream).
/datum/round_event_control/antagonist/migrant_wave/lich
	max_occurrences = 1
	// weight = 6
	// min_players = 0
	// earliest_start = 15 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_CHARACTER_INJECTION
	// shared_occurence_type = null

// Death Cult Rising: each occurrence opens 1 Assassin slot, up to slot_cap. Assassins have no roundstart slots.
/datum/round_event_control/antagonist/migrant_wave/assassins
	max_occurrences = 4
	slot_cap = 4
	// weight = 10
	// min_players = 0
	// earliest_start = 0 SECONDS
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_CHARACTER_INJECTION
	// shared_occurence_type = null

// Gnoll Migration: each occurrence opens 2 Gnoll slots, up to the Gnoll cap below.
/datum/round_event_control/antagonist/migrant_wave/only_gnolls
	max_occurrences = 2
	// weight = 18
	// min_players = 30
	// earliest_start = 30 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_CHARACTER_INJECTION
	// shared_occurence_type = null

/datum/antagonist/gnoll
	storyteller_slot_default_cap = 6

// --- Other antagonist events ---
/datum/round_event_control/antagonist/solo/dreamwalker	// Dreamwalker
	// max_occurrences = 2
	// weight = 10
	// min_players = HARD_ANTAG_MIN_POP
	// earliest_start = 15 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_CHARACTER_INJECTION
	// shared_occurence_type = SHARED_MINOR_THREAT

/datum/round_event_control/antagonist/migrant_wave/evil_knight	// The Unknightly Journey
	// max_occurrences = 1
	// weight = 6
	// min_players = 0
	// earliest_start = 10 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_CHARACTER_INJECTION
	// shared_occurence_type = null

/datum/round_event_control/antagonist/migrant_wave/werewolf	// Exiled Werewolf
	// max_occurrences = 2
	// weight = 4
	// min_players = 0
	// earliest_start = 25 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_CHARACTER_INJECTION
	// shared_occurence_type = null

/datum/round_event_control/antagonist/migrant_wave/vampire	// Exiled Vampire
	// max_occurrences = 2
	// weight = 4
	// min_players = 0
	// earliest_start = 25 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_CHARACTER_INJECTION
	// shared_occurence_type = null

/datum/round_event_control/antagonist/migrant_wave/unbound_death_knight	// Death Knight (Unbound)
	// max_occurrences = 2
	// weight = 6
	// min_players = 0
	// earliest_start = 10 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_CHARACTER_INJECTION
	// shared_occurence_type = null

/datum/round_event_control/antagonist/migrant_wave/unbound_spellblade	// Ancient Spellblade (Unbound)
	// max_occurrences = 2
	// weight = 6
	// min_players = 0
	// earliest_start = 10 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_CHARACTER_INJECTION
	// shared_occurence_type = null

/datum/round_event_control/antagonist/migrant_wave/gnolls	// Gnolls Migration (weight 0 upstream, so it never rolls)
	// max_occurrences = 2
	// weight = 0
	// min_players = 25
	// earliest_start = 30 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_CHARACTER_INJECTION
	// shared_occurence_type = null

// --- God intervention events (also need the ruling god to match) ---
/datum/round_event_control/abyssor_rage	// Abyssor's Rage
	// max_occurrences = 2
	// weight = 8
	// min_players = 20
	// earliest_start = 10 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_INTERVENTION
	// shared_occurence_type = null

/datum/round_event_control/astrata_grandeur	// Astrata's Grandeur

/datum/round_event_control/baotha_revelry	// Baotha's Revelry

/datum/round_event_control/dendor_vines_malus	// Dendor's Vines (Malus)

/datum/round_event_control/dendor_vines_boon	// Dendor's Vines (Boon)

/datum/round_event_control/dendor_fertility	// Dendor's Blessing

/datum/round_event_control/dendor_ire	// Dendor's Ire

/datum/round_event_control/graggar_culling	// Graggar's Culling (replaced by graggar objectives for awakened heretics)

/datum/round_event_control/malum_diligence	// Malum's Diligence

/datum/round_event_control/matthios_fingers	// Matthios' Fingers

/datum/round_event_control/necra_requiem	// Necra's Requiem

/datum/round_event_control/pestra_mercy	// Pestra's Mercy

/datum/round_event_control/ravox_resolve	// Ravox's Resolve

/datum/round_event_control/schism_within_ten	// Schism within the Pantheon


/datum/round_event_control/zizo_defilement	// Zizo's Defilement

// --- Mundane events ---
/datum/round_event_control/crop_growth	// Crop Growth
	// max_occurrences = 8
	// weight = 5
	// min_players = 0
	// earliest_start = 25 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_MUNDANE
	// shared_occurence_type = null

/datum/round_event_control/herb_growth	// Herb Regrowth

/datum/round_event_control/passive_animal_migration	// Passive Animal Migration (disabled upstream)

/datum/round_event_control/price_fluctuation	// Shipping Fluctuations

// --- Moderate events ---
/datum/round_event_control/collapsing_earth	// Collapsing Earth
	// max_occurrences = 8
	// weight = 5
	// min_players = 0
	// earliest_start = 25 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_MODERATE
	// shared_occurence_type = null

/datum/round_event_control/fishing_boon	// Rainy Day Fishing Boost

/datum/round_event_control/fishing_malus	// River Drought

/datum/round_event_control/herb_spread	// Herb Spread

/datum/round_event_control/herb_wither	// Herb Wither

/datum/round_event_control/hostile_animal_migration	// Hostile Animal Migration (disabled upstream)

/datum/round_event_control/town_fire	// Town Fire

/datum/round_event_control/trade_request	// Trade Request (disabled upstream)

/datum/round_event_control/wild_crops	// Wild Crop Sprout

/datum/round_event_control/deadite_animal_migration	// Deadite Animal Migration

/datum/round_event_control/vines	// Vines

/datum/round_event_control/zizo_pet_cementery	// Zizo's Pet Cementery

// --- Omen events ---
/datum/round_event_control/gobinvade	// Goblin Invasion
	// max_occurrences = 2
	// weight = 10
	// min_players = 0
	// earliest_start = 35 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_OMENS
	// shared_occurence_type = null

/datum/round_event_control/haunts	// Haunted Streets

/datum/round_event_control/lightsout	// Lights Out

/datum/round_event_control/skellyinvade	// Skeleton Invasion

/datum/round_event_control/skellysiege	// Skeleton Omen

/datum/round_event_control/spacevine	// Evil Vines

// --- Raid events ---
/datum/round_event_control/worldsiege	// Skeleton Siege
	// max_occurrences = 1
	// weight = 10
	// min_players = 4
	// earliest_start = 35 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_RAIDS
	// shared_occurence_type = null

/datum/round_event_control/worldsiege/goblin	// Goblin Siege
	// max_occurrences = 1
	// weight = 10
	// min_players = 4
	// earliest_start = 35 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_RAIDS
	// shared_occurence_type = null

// --- Personal events (a god asks one player to do something) ---
/datum/round_event_control/baotha_snorting	// Drug Desire
	// max_occurrences = 1
	// weight = 10
	// min_players = 15
	// earliest_start = 5 MINUTES
	// cost = 1
	// reoccurence_penalty_multiplier = 0.75
	// track = EVENT_TRACK_PERSONAL
	// shared_occurence_type = null

/datum/round_event_control/baotha_lux_tasting	// Lux Experience

/datum/round_event_control/graggar_organs	// Feast of Organs

/datum/round_event_control/graggar_punch	// Graggar's Rage

/datum/round_event_control/matthios_hoard	// Golden Demand

/datum/round_event_control/matthios_theft	// Thieving Task

/datum/round_event_control/zizo_shrines	// Profane Construction

/datum/round_event_control/zizo_torture	// Demand of Cruelty

/datum/round_event_control/create_abyssoids	// Create Abyssoids

/datum/round_event_control/abyssor_fish_release	// Fish Release Request

/datum/round_event_control/astrata_nobility	// Nobility Aspiration

/datum/round_event_control/retainer_recruitment	// Retainer Recruitment

/datum/round_event_control/dendor_trees	// Wise Trees Propagation

/datum/round_event_control/dendor_taming	// Taming Challenge

/datum/round_event_control/eora_compassion	// Local Compassion

/datum/round_event_control/malum_crafting	// Crafting Request

/datum/round_event_control/malum_craft_skills	// Hone Craft

/datum/round_event_control/necra_burials	// Burial Demand

/datum/round_event_control/dead_whispers	// Whispers of the Dead

/datum/round_event_control/noc_literacy	// Literacy Desire

/datum/round_event_control/pestra_rotten_feast	// Rotten Feast

/datum/round_event_control/pestra_lux	// Lux Extraction Demand

/datum/round_event_control/ravox_duel	// Honor Duels

/datum/round_event_control/ravox_combat	// Get Stronger Desire

/datum/round_event_control/xylix_mocking	// Mockery (Ruler)

/datum/round_event_control/xylix_mocking_nobles	// Mockery (Nobles)

// --- Other ---
/datum/round_event_control/rogue/skeleton_siege	// skellysiege helper event (disabled upstream)
