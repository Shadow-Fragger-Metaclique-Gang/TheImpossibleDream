/// Not votable and not in any vote pool; it is selected by default and the roundstart gamemode vote is disabled.
/// Hard/soft antags are not blocked by flags, so the slots in static_intensity_config.dm decide what can appear.
/datum/storyteller/gamemode/static_intensity
	name = "SCARRED"
	vote_desc = "The threads of fate are set. We are SCARRED. We are surviving."
	desc = "Fixed roundstart intensity."
	welcome_text = "A heavy calm hangs over the Scar.."
	color_theme = "#7a6a99"
	preset_pool = null
	always_votable = FALSE
	block_hard = FALSE
	block_soft = FALSE
	guaranteed_hard = FALSE
	guarantees_roundstart_roleset = FALSE
	roundstart_prob = 0
	allow_dreamwalker = TRUE
	hag_slots = 1
	preferred_gnoll_mode = GNOLL_SCALING_DYNAMIC
	wretch_slot_cap = 0
	// No free roundstart injection points: the configured major antagonist is forced by its slot, and the
	// injection track only gains points over time so the Dreamwalker can roll midround.
	starting_point_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

/// Disables the roundstart intensity vote: the lobby ticker announces this preset instead of opening the vote.
/datum/controller/subsystem/gamemode
	allow_vote = FALSE
	selected_storyteller = /datum/storyteller/gamemode/static_intensity

// The upstream Assassin migrant wave hardcodes a maximum of 2 slots, so it uses a subtype that reads the cap
// from the control (set in static_intensity_config.dm).
/datum/round_event_control/antagonist/migrant_wave/assassins
	typepath = /datum/round_event/migrant_wave/assassins/static_intensity
	/// Maximum Assassin slots this event can raise the job to.
	var/slot_cap = 2

/datum/round_event/migrant_wave/assassins/static_intensity/start()
	var/datum/round_event_control/antagonist/migrant_wave/assassins/cast_control = control
	var/datum/job/assassin_job = SSjob.GetJob("Assassin")
	if(!assassin_job)
		return
	assassin_job.total_positions = min(assassin_job.total_positions + 1, cast_control.slot_cap)
	assassin_job.spawn_positions = min(assassin_job.spawn_positions + 1, cast_control.slot_cap)
	if(assassin_job.total_positions < cast_control.slot_cap)
		SSrole_class_handler.assassins_in_round = TRUE
		for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
			if(!player.client)
				continue
			to_chat(player, span_danger("Blood is demanded. Debts must be paid. Death comes cloaked, ready to carve new wounds before the Scar. An assassin slot has been opened."))

// The Gnoll migration already raises slots up to story_antag_slot_cap(gnoll), which is set in the config. Gnoll
// slots are reset to SSgamemode.admin_slots["Gnoll"] whenever the latejoin menu opens, so the raised amount is
// written back there to make it stick.
/datum/round_event_control/antagonist/migrant_wave/only_gnolls
	typepath = /datum/round_event/migrant_wave/only_gnolls/static_intensity

/datum/round_event/migrant_wave/only_gnolls/static_intensity/start()
	. = ..()
	var/datum/job/gnoll_job = SSjob.GetJob("Gnoll")
	if(gnoll_job && !SSgamemode.allow_vote && !isnull(SSgamemode.admin_slots["Gnoll"]))
		SSgamemode.admin_slots["Gnoll"] = max(SSgamemode.admin_slots["Gnoll"], gnoll_job.total_positions)
