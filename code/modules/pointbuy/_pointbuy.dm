GLOBAL_LIST_EMPTY(pointbuy_stats)

/// Per-session cache of Fated rolls, keyed by "ckey-slot". Locks each character slot's roll
/// for the session - mirroring the legacy Fated statpack's no-reroll guarantee.
GLOBAL_LIST_EMPTY(pointbuy_locks)

/datum/pointbuy_stat
	/// Stat identifier.
	var/stat_key
	/// Display name.
	var/name
	/// Display color for the stat.
	var/color
	/// Lowest value that still earns refund credit. Stats can be dropped below this but stop refunding.
	var/min_value = 7
	/// Hard floor the stat can be set to.
	var/floor_value = 1
	/// Highest value this stat may be bought up to.
	var/max_value = 13
	/// Marginal cost above 10.
	var/level_cost = 1
	/// Points refunded per step bought below 10.
	var/refund_rate = 1
	/// Flat amount subtracted from each level's marginal cost (floored at 0).
	var/cost_discount = 0

/// Species favours decreases the cost per level above 10.
/datum/pointbuy_stat/proc/effective_costs(datum/species/species)
	var/cpl = level_cost
	if(!species)
		return list(cpl, cost_discount)
	var/favor = species.statpoint_favor[stat_key]
	if(!favor)
		return list(cpl, cost_discount)
	cpl = max(0, cpl - favor)
	return list(cpl, cost_discount)

/datum/pointbuy_stat/proc/total_cost(target, datum/species/species)
	var/delta = target - 10
	if(!delta)
		return 0
	if(delta < 0)
		var/refunded_steps = min(-delta, 10 - min_value)
		return -refunded_steps * refund_rate
	var/list/ec = effective_costs(species)
	var/cpl = ec[1]
	var/disc = ec[2]
	var/sum = 0
	for(var/k in 1 to delta)
		sum += max(0, (k * cpl) - disc)
	return sum

/datum/pointbuy_stat/proc/step_cost(current, datum/species/species)
	return total_cost(current + 1, species) - total_cost(current, species)

/proc/pointbuy_maxpoints(datum/species/species)
	return POINTBUY_BASE_POINTS + (species ? species.extra_statpoints : 0)

/proc/pointbuy_spent(list/allocations, datum/species/species)
	if(!length(allocations))
		return 0
	var/total = 0
	for(var/stat in allocations)
		var/datum/pointbuy_stat/PS = GLOB.pointbuy_stats[stat]
		if(!PS)
			continue
		total += PS.total_cost(allocations[stat], species)
	return total

/proc/pointbuy_validate(list/allocations, datum/species/species)
	if(!length(allocations))
		return list()
	for(var/stat in allocations.Copy())
		var/datum/pointbuy_stat/PS = GLOB.pointbuy_stats[stat]
		if(!PS)
			allocations -= stat
			continue
		var/val = clamp(allocations[stat], PS.floor_value, PS.max_value)
		if(val == 10)
			allocations -= stat
		else
			allocations[stat] = val
	if(pointbuy_spent(allocations, species) != pointbuy_maxpoints(species))
		return list()
	return allocations

/datum/species/proc/get_pointbuy_description()
	if(!length(statpoint_favor))
		return ""
	var/list/parts = list()
	for(var/stat in MOBSTATS)
		var/tiers = statpoint_favor[stat]
		if(!tiers)
			continue
		var/datum/pointbuy_stat/PS = GLOB.pointbuy_stats[stat]
		if(!PS)
			continue
		var/tier_color = (tiers > 0) ? "#91cf68" : "#cf2a2a"
		var/sign = (tiers > 0) ? "-" : "+"
		parts += "<font color='[tier_color]'>[sign]\Roman[abs(tiers)] [PS.name]</font>"
	if(!length(parts))
		return ""
	return "<br><span style='text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>[parts.Join(" | ")]</b></span><br>"

/datum/preferences/proc/grants_virtues()
	return pointbuy_virtuous

/proc/pointbuy_apply_favor(mob/living/carbon/human/H, datum/species/species)
	if(!H || !species || !length(species.statpoint_favor))
		return
	for(var/stat in species.statpoint_favor)
		var/tiers = species.statpoint_favor[stat]
		if(!tiers)
			continue
		H.change_stat(stat, tiers)

/proc/pointbuy_fated_key(mob/H, mob/dead/new_player/new_player)
	var/player_ckey = H?.ckey || new_player?.ckey
	var/loaded_slot = H?.client?.prefs?.loaded_slot || new_player?.client?.prefs?.loaded_slot
	return "[player_ckey]-[loaded_slot]"

/proc/pointbuy_roll_fated(mob/living/carbon/human/H, mob/dead/new_player/new_player)
	var/lock_key = pointbuy_fated_key(H, new_player)
	var/list/rolled = GLOB.pointbuy_locks[lock_key]
	if(!rolled)
		var/xylixian = H.patron == GLOB.patronlist[/datum/patron/divine/xylix]
		var/list/ranges = list()
		for(var/stat in MOBSTATS)
			ranges[stat] = list(-2, 2)
		if(xylixian)
			ranges[STAT_FORTUNE] = list(0, 2)
			var/list/non_fortune = MOBSTATS - STAT_FORTUNE
			var/enchanted = rand(0, length(non_fortune))
			for(var/stat in shuffle(non_fortune))
				if(enchanted <= 0)
					break
				ranges[stat] = list(-1, 2)
				enchanted--
		rolled = list()
		for(var/stat in MOBSTATS)
			var/datum/pointbuy_stat/PS = GLOB.pointbuy_stats[stat]
			if(!PS)
				continue
			var/list/r = ranges[stat]
			var/delta = rand(r[1], r[2])
			if(!delta)
				continue
			rolled[stat] = clamp(10 + delta, PS.min_value, PS.max_value)
		GLOB.pointbuy_locks[lock_key] = rolled
	pointbuy_fated_announce(H, new_player, rolled)
	return rolled

/proc/pointbuy_fated_announce(mob/living/carbon/human/H, mob/dead/new_player/new_player, list/rolled)
	var/list/messages = list("Fate has adjusted your statblock as such...")
	if(H.patron == GLOB.patronlist[/datum/patron/divine/xylix])
		messages += span_notice("Xylix smiles upon you, believer!")
	messages += ""
	for(var/stat in MOBSTATS)
		var/datum/pointbuy_stat/PS = GLOB.pointbuy_stats[stat]
		var/delta = rolled[stat] ? (rolled[stat] - 10) : 0
		var/label = PS ? PS.name : capitalize(stat)
		var/message = "[label]: [delta]"
		if(delta > 0)
			messages += span_green(message)
		else if(delta < 0)
			messages += span_red(message)
		else
			messages += span_notice(message)
	if(H.ckey)
		to_chat(H, examine_block(messages.Join("\n")))
	else if(new_player?.ckey)
		to_chat(new_player, examine_block(messages.Join("\n")))


/datum/pointbuy_stat/strength
	stat_key = STAT_STRENGTH
	name = "STR"
	color = "#b18484"
	min_value = 8
	max_value = 12
	level_cost = 2
	refund_rate = 2

/datum/pointbuy_stat/perception
	stat_key = STAT_PERCEPTION
	name = "PER"
	color = "#c0ba8d"

/datum/pointbuy_stat/intelligence
	stat_key = STAT_INTELLIGENCE
	name = "INT"
	color = "#81adc8"
	min_value = 8
	max_value = 12
	level_cost = 2
	refund_rate = 2

/datum/pointbuy_stat/constitution
	stat_key = STAT_CONSTITUTION
	name = "CON"
	color = "#d6858b"

/datum/pointbuy_stat/willpower
	stat_key = STAT_WILLPOWER
	name = "WIL"
	color = "#aa83b9"
	min_value = 8
	max_value = 12
	level_cost = 2
	refund_rate = 2

/datum/pointbuy_stat/speed
	stat_key = STAT_SPEED
	name = "SPD"
	color = "#d6c36b"
	min_value = 8
	max_value = 12
	level_cost = 2
	refund_rate = 2

/datum/pointbuy_stat/fortune
	stat_key = STAT_FORTUNE
	name = "FOR"
	color = "#819e82"
	min_value = 9
	max_value = 11
