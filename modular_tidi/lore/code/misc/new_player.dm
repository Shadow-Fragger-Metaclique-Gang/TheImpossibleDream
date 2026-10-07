/datum/controller/global_vars/Initialize(mapload)
	. = ..()
	roleplay_readme = world.file2list("modular_tidi/lore/strings/rt/rp_prompt.txt")
