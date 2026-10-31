#define GREENTEXT_BOX_STYLE "background: #1a0a0a; border: 1px solid #5a3a3a; padding: 12px; border-radius: 4px; margin-bottom: 15px;"
#define GREENTEXT_HEADER_STYLE "color: #d4b4b4; font-weight: bold; margin-bottom: 8px;"
#define GREENTEXT_DONE "<span style='color:#5cb85c'>(COMPLETED)</span>"
#define GREENTEXT_FAILED "<span style='color:#d9534f'>(FAILED)</span>"

/proc/get_awakened_heretics()
	. = list()
	for(var/datum/mind/heretic_mind in SSticker.minds)
		if(heretic_mind.heretic_path)
			. += heretic_mind

/// "<ckey> was <name> the <role> and died/survived", the same line the Villains tab uses. Anonymous players get "<name> the <role> died/survived" with no alias.
/proc/greentext_mind_line(datum/mind/villain)
	if(!villain?.current)
		return "<b>Unknown Villain</b>"
	var/jobtext = ""
	if(villain.special_role)
		jobtext = " the <b>[villain.special_role]</b>"
	else if(villain.assigned_role)
		jobtext = " the <b>[villain.assigned_role]</b>"
	var/fate = villain.current.stat == DEAD ? "<span style='color:#d9534f'>died</span>" : "<span style='color:#4ccf4c'>survived</span>"
	var/character = "<span style='color:#e6a962'><b>[villain.name]</b>[jobtext]</span>"
	if(ckey(villain.key) in GLOB.anonymize)
		return "[character] [fate]"
	return "<b>[get_display_ckey(villain.key)]</b> was [character] and [fate]"

/proc/greentext_heretic_objectives(datum/heretic_path/path)
	var/list/data = list()
	path.log_objective(path.current_objective)
	data += "<div style='margin-left: 15px; margin-top: 5px;'>"
	var/obj_count = 1
	for(var/datum/objective/greentext_record/record as anything in path.greentext_records)
		data += "<div style='margin-bottom: 3px;'>"
		data += "<b>Objective #[obj_count] (Tier [record.tier]):</b> [record.base_text] [GREENTEXT_DONE]"
		if(length(record.victims))
			data += "<div style='margin-left: 15px; color: #b09090;'><i>Done to: [english_list(record.victims)]</i></div>"
		data += "</div>"
		obj_count++
	if(path.current_objective && !path.current_objective.greentext_record)
		data += "<div style='margin-bottom: 3px;'>"
		data += "<b>Objective #[obj_count] (Tier [path.tier]):</b> [path.current_objective.explanation_text] [GREENTEXT_FAILED]"
		data += "</div>"
		obj_count++
	if(obj_count == 1)
		data += "<div style='color: #999; font-style: italic;'>Never given an objective.</div>"
	data += "</div>"
	return data.Join()

/// The Awakened Heretics box, or an empty string if nobody awakened.
/proc/greentext_heretic_section()
	var/list/heretics = get_awakened_heretics()
	if(!length(heretics))
		return ""
	var/list/data = list()
	data += "<div style='[GREENTEXT_BOX_STYLE]'>"
	data += "<div style='[GREENTEXT_HEADER_STYLE]'>Awakened Heretics</div>"
	data += "<div style='margin-left: 10px;'>"
	for(var/datum/mind/heretic_mind as anything in heretics)
		var/datum/heretic_path/path = heretic_mind.heretic_path
		var/datum/patron/patron = path.patron_type
		data += "<div style='margin-bottom: 10px;'>"
		data += "[greentext_mind_line(heretic_mind)], a heretic of <b>[initial(patron.name)]</b> who reached tier <b>[path.tier]</b>"
		data += greentext_heretic_objectives(path)
		data += "</div>"
	data += "</div></div>"
	return data.Join()

/// Villains with an antagonist datum, grouped by round-end category.
/proc/greentext_antagonist_sections()
	var/list/villains = list()
	for(var/datum/antagonist/A in GLOB.antagonists)
		if(A.owner && A.type != /datum/antagonist && (A.storyteller_antag_flags & STORYTELLER_ANTAG_VILLAIN))
			villains += A
	sortTim(villains, GLOBAL_PROC_REF(cmp_antag_category))
	var/list/data = list()
	var/current_category
	for(var/datum/antagonist/A as anything in villains)
		if(A.roundend_category != current_category)
			if(current_category)
				data += "</div></div>"
			data += "<div style='[GREENTEXT_BOX_STYLE]'>"
			data += "<div style='[GREENTEXT_HEADER_STYLE]'>[capitalize(A.roundend_category)]</div>"
			data += "<div style='margin-left: 10px;'>"
			current_category = A.roundend_category
		data += "<div style='margin-bottom: 10px;'>[greentext_mind_line(A.owner)]"
		if(length(A.objectives))
			data += "<div style='margin-left: 15px; margin-top: 5px;'>"
			var/obj_count = 1
			for(var/datum/objective/O in A.objectives)
				data += "<div style='margin-bottom: 3px;'><b>Objective #[obj_count]:</b> [O.explanation_text] [O.check_completion() ? GREENTEXT_DONE : GREENTEXT_FAILED]</div>"
				obj_count++
			data += "</div>"
		data += "</div>"
	if(current_category)
		data += "</div></div>"
	return data.Join()

/// Opens the villains window next to the Chronicle at round end. Does nothing if there are no villains.
/client/proc/show_greentext_villains()
	var/list/data = list()
	data += greentext_antagonist_sections()
	data += greentext_heretic_section()
	if(!length(data.Join()))
		return
	var/list/page = list()
	page += "<div style='text-align: center; color: #d4b4b4; font-size: 1.2em; margin-bottom: 15px;'>VILLAINS OF THE REALM</div>"
	page += "<div style='border-top: 1.5px solid #8a6a6a; margin: 0 auto 20px auto; width: 65%;'></div>"
	page += data
	var/datum/browser/popup = new(mob, "greentext_villains", "<center>Villains of the Realm</center>", 750, 800)
	popup.set_content("<div style='margin: 15px;'>[page.Join()]</div>")
	popup.open()

#undef GREENTEXT_BOX_STYLE
#undef GREENTEXT_HEADER_STYLE
#undef GREENTEXT_DONE
#undef GREENTEXT_FAILED
