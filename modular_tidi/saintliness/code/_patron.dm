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
		var/datum/component/C = pious.GetComponent(worship_component_type)
		C._RemoveFromParent()

// New Components on the 'ol Patrons'

// Divine
/datum/patron/divine/astrata
	worship_component_type = /datum/component/saintliness/astrata

/datum/patron/divine/abyssor
	worship_component_type = /datum/component/saintliness/abyssor

/datum/patron/divine/ravox
	worship_component_type = /datum/component/saintliness/ravox

/datum/patron/divine/dendor
	worship_component_type = /datum/component/saintliness/dendor

/datum/patron/divine/noc
	worship_component_type = /datum/component/saintliness/noc

/datum/patron/divine/necra
	worship_component_type = /datum/component/saintliness/necra

/datum/patron/divine/eora
	worship_component_type = /datum/component/saintliness/eora

/datum/patron/divine/pestra
	worship_component_type = /datum/component/saintliness/pestra

/datum/patron/divine/xylix
	worship_component_type = /datum/component/saintliness/xylix

/datum/patron/divine/malum
	worship_component_type = /datum/component/saintliness/malum

// Inhumen

/datum/patron/inhumen/zizo
	worship_component_type = /datum/component/saintliness/zizo

/datum/patron/inhumen/graggar
	worship_component_type = /datum/component/saintliness/graggar

/datum/patron/inhumen/matthios
	worship_component_type = /datum/component/saintliness/matthios

/datum/patron/inhumen/baotha
	worship_component_type = /datum/component/saintliness/baotha
// Psydon

/datum/patron/old_god
	worship_component_type = /datum/component/saintliness/psydon
