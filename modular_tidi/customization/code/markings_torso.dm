//Shim for installing these markings.
/datum/species/New()
	. = ..()
	body_markings += list(
		/datum/body_marking/gut
	)



/datum/body_marking/gut
	icon = 'modular_tidi/customization/icons/belly.dmi'
	name = "gut"
	icon_state = "gut"
	default_color = DEFAULT_PRIMARY //I can't get this to show up as the right color, the user will need to choose it bc frankly I can't seem to get it.
	affected_bodyparts = CHEST
/datum/body_marking_set/gut
	name = "Gut"
	body_marking_list = list(
		/datum/body_marking/gut
		)
