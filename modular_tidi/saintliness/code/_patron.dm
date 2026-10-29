/datum/patron
	var/worship_component_type = null

/datum/patron/on_gain(mob/living/pious)
	..()
	//Conversion signal doesn't go here because that'd make the conversion line show on roundstart/latejoin
	if(worship_component_type)
		pious.AddComponent(worship_component_type)

/datum/patron/on_loss(mob/living/pious)
	..()
	if(worship_component_type)
		SEND_SIGNAL(pious, COMSIG_MOB_ON_APOSTASY)
		var/datum/component/C = pious.GetComponent(worship_component)
		C._RemoveFromParent()

// New Components on the 'ol Patrons'

// Divine
/datum/patron/divine/astrata
	worship_component_type = /datum/component/saintliness/astrata

// Inhumen

// Psydon

