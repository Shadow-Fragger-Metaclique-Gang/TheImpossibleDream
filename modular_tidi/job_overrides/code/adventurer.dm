#define JOB_OVERRIDES_ADVENTURER_SLOTS 20

/// Adventurer slots are a flat number. Population and storyteller scaling no longer apply.
/proc/get_adventurer_slot_cap()
	return JOB_OVERRIDES_ADVENTURER_SLOTS


/datum/job/roguetown/lamplighter
	total_positions = 0
	spawn_positions = 0
	hidden_job = TRUE
	always_show_on_latechoices = FALSE

/datum/job/roguetown/adventurer/New()
	. = ..()
	job_subclasses += list(
		/datum/advclass/lampwarden,
		/datum/advclass/lampwicker,
	)

/datum/advclass/lampwarden
	maximum_possible_slots = 2
	category_tags = list(CTAG_ADVENTURER)
	class_select_category = CLASS_CAT_RANGER

/datum/advclass/lampwicker
	maximum_possible_slots = 2
	category_tags = list(CTAG_ADVENTURER)
	class_select_category = CLASS_CAT_CLERIC

// Pentacle only
/datum/advclass/cleric
	allowed_patrons = ALL_DIVINE_PATRONS

/datum/advclass/cleric/paladin
	allowed_patrons = ALL_DIVINE_PATRONS

/datum/advclass/cleric/cantor
	allowed_patrons = list(
		/datum/patron/divine/astrata,
		/datum/patron/divine/noc,
		/datum/patron/divine/ravox,
		/datum/patron/divine/eora,
		/datum/patron/divine/necra,
		/datum/patron/divine/xylix,
	)

/datum/advclass/cleric/missionary
	allowed_patrons = ALL_DIVINE_PATRONS
