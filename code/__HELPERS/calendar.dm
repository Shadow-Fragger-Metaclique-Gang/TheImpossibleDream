/*
	Helper for the CALENDAR System. This will be where I document the design decisions.
	Azure Peak's canonical calendar system, known as the Azurian Calendar ICly, is a solar calendar. It is based on the "Grenzelhoftian Calendar", a tennite calendar system.
	But actually, because we're in a fictional video game, it is a perfect calendar with no leap years or irregularities.
	It consists of 12 months, each with exactly 28 days dividing into 4 weeks. And it starts from Monday and ends on Sunday with a 7 days week.
	Each week = 1 round IC (regardless of how much time actually passed in game)
	The first month of a year begins in Spring - Gregorian March, like most sane agricultural calendars that begins in February / March.

	SURREALIS NOTE:
	Hey! So! This is a solid calendar, and it's a piece of absolute brilliance. Incredible work, fella! With all credit to the author--
	We'll be making some edits throughout the process. Y'know, for flavor's sake - and readability.
	With more Gods than the Pantheon staged in the world of the Dream, we'll be renaming the months to more secular terms.
	Once I have the chance, I'll likely push for returning to a more traditional Julian/Gregorian start of the Year,
	The only holdover being in the listed month of holidays. May also be renaming the AP metric to... hmn. Something Zybantine, perhaps.
	The Calendar will measure from the formation of the original Temple of the Pentacle, after all.
*/


/* Returns the IC date as a string in the format
 * [Weekday], [Day] [Month] [Year], [HH:MM] ([Time Of Day]), ([Cycle Number])
*/
/proc/get_current_ic_date_as_string()
	return get_ic_date_as_string(GLOB.dayspassed)

/// Returns list(day_of_month, month_number, year_number) for a given GLOB.dayspassed-style day.
/proc/resolve_ic_date_parts(day_number)
	if(!day_number)
		day_number = GLOB.dayspassed
	var/round_id = text2num(GLOB.round_id) || 0
	var/days_since_epoch = (round_id) * CALENDAR_DAYS_IN_WEEK + (day_number - 1)
	if(GLOB.date_override_enabled)
		days_since_epoch += GLOB.date_override_offset
	var/day_of_year = MODULUS(days_since_epoch, CALENDAR_DAYS_IN_YEAR) + 1
	var/month_number = FLOOR((day_of_year - 1) / CALENDAR_DAYS_IN_MONTH, 1) + 1
	var/day_of_month = MODULUS((day_of_year - 1), CALENDAR_DAYS_IN_MONTH) + 1
	return list(day_of_month, month_number, CALENDAR_EPOCH_YEAR)

/// Full IC date string (with cycle / season annotations). Used by admin verbs + admin-style UIs.
/proc/get_ic_date_as_string(day_number)
	if(!day_number)
		day_number = GLOB.dayspassed
	var/list/parts = resolve_ic_date_parts(day_number)
	var/day_of_month = parts[1]
	var/month_number = parts[2]
	var/year_number = parts[3]
	var/round_id = text2num(GLOB.round_id) || 0
	var/current_cycle = FLOOR(round_id / (YEAR_PER_CYCLE * CALENDAR_WEEKS_IN_YEAR), 1) + 1
	var/month_name = get_month_number_to_text(month_number)
	var/season = get_season_from_month(month_number)
	var/season_phase = get_season_phase(month_number)
	return "[day_of_month] [month_name] [year_number] BR (Month [month_number] [season_phase] [season]), Cycle [current_cycle]"

/// Compact IC date - what players say in-character. e.g. "3 Eora 1513 AP".
/proc/get_ic_date_short_as_string(day_number)
	var/list/parts = resolve_ic_date_parts(day_number)
	return "[parts[1]] [get_month_number_to_text(parts[2])] [parts[3]] BR"

// Returns the current IC time as a string in the format [DAYS] ᛉ HH:MM ([Time Of Day])
/proc/get_current_ic_time_as_string()
	// Credit to Zydras for Syon's Dae for Saturday
	// These are the day names that can be referred to sensically ICly
	// By using secular names rather than IRL deity like Thule, Saturn, Tiw (Tyr), it avoids us having to explain a non-existent
	// Norse deity while remaining phonetically close to the original English name
	var/weekday = get_current_day_of_week_name()
	return	"[weekday] ᛉ [capitalize(GLOB.tod)] ᛉ [station_time_timestamp("hh:mm")]"

// Given a number between 1 to 12, returns the month name as text
/proc/get_month_number_to_text(month_number)
	switch(month_number)
		if(1)
			return "Psyrise" // March - The first month of a year is dedicated to the original god that created the world
		if(2)
			return "Aprilis" // April
		if(3)
			return "Maius" // May
		if(4)
		// SURREALIS NOTE: Strangely, this month has a lot of old men and women jumping off cliffs.
			return "Midsommar" // June
		if(5)
			return "Jul" // July
		if(6)
			return "Auganstil" // August
		if(7)
			return "Steptembre" // September
		if(8)
			return "Octscape" // October
		if(9)
			// A month dedicated to the goddess of death, before the sun's rebirth and after the goddess of rot
			return "Necrem" // November
		if(10)
			// And on winter solstice and the longest night of the year, we have the month dedicated to the god of night
			return "Lunembar" // December
		if(11)
			return "Ianuarius" // January
		if(12)
			return "Psybreak" // February
		else
			return "Unknown Month ([month_number])"

/* Returns the season based on month number (1-12)
	Months 1 - 3: Spring, 4 - 6: Summer, 7 - 9: Autumn, 10 - 12: Winter
 */
/proc/get_season_from_month(month_number)
	switch(CEILING(month_number, 3) / 3)
		if(1)
			return "Spring"
		if(2)
			return "Summer"
		if(3)
			return "Autumn"
		if(4)
			return "Winter"
	return "Unknown"

/* Returns Early/Mid/Late based on position within the season
	1st month of season: Early, 2nd: Mid, 3rd: Late
*/
/proc/get_season_phase(month_number)
	switch(MODULUS(month_number - 1, 3) + 1)
		if(1)
			return "Early"
		if(2)
			return "Mid"
		if(3)
			return "Late"
	return ""

/proc/get_calendar_events_for_month(month_number)
	var/list/matches = list()
	for(var/datum/calendar_event/event in GLOB.calendar_events)
		if(event.recur_month == month_number)
			matches += event
	return matches

/proc/get_calendar_events_for_day(month_number, day_of_month)
	var/list/matches = list()
	for(var/datum/calendar_event/event in GLOB.calendar_events)
		if(event.covers_day(month_number, day_of_month))
			matches += event
	return matches

/proc/get_active_calendar_event_titles()
	var/list/parts = resolve_ic_date_parts(GLOB.dayspassed)
	var/list/titles = list()
	for(var/datum/calendar_event/event in get_calendar_events_for_day(parts[2], parts[1]))
		titles += event.title
	return titles

GLOBAL_LIST_INIT(event_day_ordinals, list(
	"first", "second", "third", "fourth", "fifth",
	"sixth", "seventh", "eighth", "ninth", "tenth",
))

/proc/get_event_day_ordinal(index)
	if(index >= 1 && index <= length(GLOB.event_day_ordinals))
		return GLOB.event_day_ordinals[index]
	var/suffix = "th"
	var/last_two = MODULUS(index, 100)
	if(last_two < 11 || last_two > 13)
		switch(MODULUS(index, 10))
			if(1)
				suffix = "st"
			if(2)
				suffix = "nd"
			if(3)
				suffix = "rd"
	return "[index][suffix]"

/proc/scom_announce_new_dawn()
	var/list/parts = resolve_ic_date_parts(GLOB.dayspassed)
	for(var/datum/calendar_event/event in get_calendar_events_for_day(parts[2], parts[1]))
		var/ordinal = get_event_day_ordinal(event.day_index(parts[2], parts[1]))
		var/line = "The [ordinal] dae of [event.title]."
		var/reminder_line = event.get_reminder_for_day(parts[2], parts[1])
		if(reminder_line)
			line = "[line] [reminder_line]"
		scom_announce(line)

/proc/get_current_day_of_week()
	return GLOB.dayspassed

/proc/get_current_day_of_week_name()
	var/round_id = text2num(GLOB.round_id) || 0
	var/days_since_epoch = (round_id) * CALENDAR_DAYS_IN_WEEK + (GLOB.dayspassed - 1)

	if(GLOB.date_override_enabled)
		days_since_epoch += GLOB.date_override_offset

	var/day_of_year = MODULUS(days_since_epoch, CALENDAR_DAYS_IN_YEAR) + 1
	var/day_of_month = MODULUS((day_of_year - 1), CALENDAR_DAYS_IN_MONTH) + 1
	var/day_of_week = MODULUS((day_of_month - 1), CALENDAR_DAYS_IN_WEEK) + 1

	switch(day_of_week)
		if(1)
			return "Moon's Dae"
		if(2)
			return "Truce's Dae"
		if(3)
			return "Wedding's Dae"
		if(4)
			return "Thunder's Dae"
		if(5)
			return "Feast's Dae"
		if(6)
			return "Psydon's Dae"
		if(7)
			return "Sun's Dae"
	return "Unknown Dae"
