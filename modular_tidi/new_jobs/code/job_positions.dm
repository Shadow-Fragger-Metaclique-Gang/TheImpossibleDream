/datum/controller/subsystem/job/Initialize(timeofday)
	. = ..()
	GLOB.church_positions -= list("Druid", "Painter")
	GLOB.garrison_positions -= "Warden"
	GLOB.wanderer_positions -= "Lamplighter"
	GLOB.atc_positions += "Merchant Mercenary"
	GLOB.inquisition_positions += "Penitent One"
