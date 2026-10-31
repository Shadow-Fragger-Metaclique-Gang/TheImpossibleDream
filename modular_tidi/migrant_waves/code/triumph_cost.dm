#define MIGRANT_WAVE_TRIUMPH_COST_MULTIPLIER 2

/datum/migrant_wave
	/// If set, this is the final triumph threshold and the global cost multiplier is not applied.
	var/fixed_triumph_threshold = null

/datum/migrant_wave/New()
	. = ..()
	if(!isnull(fixed_triumph_threshold))
		triumph_threshold = fixed_triumph_threshold
		return
	triumph_threshold *= MIGRANT_WAVE_TRIUMPH_COST_MULTIPLIER
