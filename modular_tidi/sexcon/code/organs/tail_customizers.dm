/datum/customizer_choice/organ/tail
	organ_dna_type = /datum/organ_dna/tail
	customizer_entry_type = /datum/customizer_entry/organ/tail

/datum/customizer_choice/organ/tail/lizard/New()
	sprite_accessories += /datum/sprite_accessory/tail/manticore
	return ..()

/datum/customizer_choice/organ/tail/demihuman/New()
	sprite_accessories += /datum/sprite_accessory/tail/manticore
	return ..()

/datum/customizer_choice/organ/tail/anthro/New()
	sprite_accessories += /datum/sprite_accessory/tail/manticore
	return ..()

/datum/customizer_choice/organ/tail/dullahan/New()
	sprite_accessories += /datum/sprite_accessory/tail/manticore
	return ..()

/datum/customizer_choice/organ/tail/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	if(entry.accessory_type == /datum/sprite_accessory/tail/manticore)
		organ_dna.organ_type = /obj/item/organ/tail/manticore
	var/datum/organ_dna/tail/tail_dna = organ_dna
	var/datum/customizer_entry/organ/tail/tail_entry = entry
	tail_dna.fertility = tail_entry.fertility

/datum/customizer_entry/organ/tail
	var/fertility = TRUE

/datum/customizer_choice/organ/tail/tgui_pref_choices(datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	var/list/data = ..()
	if(entry.accessory_type != /datum/sprite_accessory/tail/manticore)
		return data
	var/datum/customizer_entry/organ/tail/tail_entry = entry
	data["template"] = "FeatureChoiceVagina"
	data["fertility"] = tail_entry.fertility
	return data

/datum/customizer_choice/organ/tail/handle_tgui_act(list/params, datum/tgui/ui, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	. = ..()
	if(.)
		return
	if(entry.accessory_type != /datum/sprite_accessory/tail/manticore || params["customizer_task"] != "fertile")
		return
	var/datum/customizer_entry/organ/tail/tail_entry = entry
	tail_entry.fertility = !tail_entry.fertility
	prefs.verbose_pref_log_change(ui.user, "notice", "\"[name]\" fertility", !tail_entry.fertility ? "Fertile" : "Sterile", tail_entry.fertility ? "Fertile" : "Sterile")
	return TRUE

/datum/customizer/organ/tail/manticore
	name = "Tail Maw"
	customizer_choices = list(/datum/customizer_choice/organ/tail/manticore)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/tail/manticore
	name = "Manticore Tail"
	organ_type = /obj/item/organ/tail/manticore
	sprite_accessories = list(
		/datum/sprite_accessory/tail/manticore,
	)
	allows_accessory_color_customization = TRUE
