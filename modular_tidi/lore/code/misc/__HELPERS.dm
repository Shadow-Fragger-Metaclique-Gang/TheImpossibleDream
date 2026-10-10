/datum/controller/global_vars/Initialize(mapload)
	. = ..()
	time_change_tips = world.file2list("modular_tidi/lore/strings/rt/timechangetips.txt")
	time_change_quotes = world.file2list("modular_tidi/lore/strings/rt/timechangequotes.txt")
	if(!string_cache)
		string_cache = new
	for(var/filename in list("accent_universal.json", "hallucination.json", "laws_of_the_land.json"))
		string_cache[filename] = json_load("modular_tidi/lore/strings/[filename]")
	laws_of_the_land = initialize_laws_of_the_land()
