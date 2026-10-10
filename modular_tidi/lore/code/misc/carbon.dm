/datum/controller/global_vars/Initialize(mapload)
	. = ..()
	stress_messages = world.file2list("modular_tidi/lore/strings/rt/stress_messages.txt")
