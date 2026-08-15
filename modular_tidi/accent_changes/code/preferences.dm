/datum/preferences/ShowChoices(mob/user, tabchoice)
	if(!user || !user.client)
		return
	if(slot_randomized)
		load_character(default_slot) // Reloads the character slot. Prevents random features from overwriting the slot if saved.
		slot_randomized = FALSE
	var/list/dat = list("<center>")
	if(tabchoice)
		current_tab = tabchoice
	if(tabchoice == 4)
		current_tab = 0

	dat += "<a href='?_src_=prefs;preference=tab;tab=0' [current_tab == 0 ? "class='linkOn'" : ""]>Character</a>"
	dat += "<a href='?_src_=prefs;preference=tab;tab=1' [current_tab == 1 ? "class='linkOn'" : ""]>Game Settings</a>"
	dat += "<a href='?_src_=prefs;preference=tab;tab=2' [current_tab == 2 ? "class='linkOn'" : ""]>OOC</a>"
	dat += "<a href='?_src_=prefs;preference=tab;tab=3' [current_tab == 3 ? "class='linkOn'" : ""]>Keybinds</a>"

	dat += "</center>"
	dat += "<br>"

	var/used_title
	switch(current_tab)
		if (0) // Character Settings#
			used_title = "Character Sheet"

			// Top-level menu table
			dat += "<table style='width: 100%; line-height: 20px;'>"
			// NEXT ROW
			dat += "<tr>"
			dat += "<td style='width:33%;text-align:left'>"
			dat += "<a style='white-space:nowrap;' href='?_src_=prefs;preference=changeslot;'>Change Character</a>"
			dat += "</td>"
			dat += "<td style='width:33%;text-align:center'>"
			dat += "<a href='?_src_=prefs;preference=job;task=menu'>Class Selection</a>"
			dat += "</td>"
			dat += "<td style='width:33%;text-align:right'>"
			dat += "</td>"
			dat += "</tr>"

			// ANOTHA ROW
			dat += "<tr style='padding-top: 0px;padding-bottom:0px'>"
			dat += "<td style='width:33%;text-align:left'>"
			dat += "</td>"
			dat += "<td style='width:33%;text-align:center'>"
			dat += "<a href='?_src_=prefs;preference=antag;task=menu'>Villain Selection</a>"
			dat += "</td>"
			dat += "<td style='width:33%;text-align:right'>"
			dat += "<a href='?_src_=prefs;preference=changelog;task=menu'>Changelog</a>"
			dat += "</td>"
			dat += "</tr>"

			dat += "<tr style='padding-top: 0px;padding-bottom:0px'>"
			dat += "<td style='width:33%;text-align:left'>"
			dat += "</td>"
			dat += "<td style='width:33%;text-align:center'>"
			dat += "<a href='?_src_=prefs;preference=lore_primer'>Lore Primer</a>"
			dat += "</td>"
			dat += "<td style='width:33%;text-align:right'>"
			dat += "</td>"
			dat += "</tr>"

			// ANOTHER ROW HOLY SHIT WE FINALLY A GOD DAMN GRID NOW! WHOA!
			dat += "<tr style='padding-top: 0px;padding-bottom:0px'>"
			dat += "<td style='width:33%; text-align:left'>"
			dat += "<a href='?_src_=prefs;preference=playerquality;task=menu'><b>PQ:</b></a> [get_playerquality(user.ckey, text = TRUE)]"
			dat += "</td>"

			dat += "<td style='width:33%;text-align:center'>"
			dat += "<a href='?_src_=prefs;preference=triumphs;task=menu'><b>TRIUMPHS:</b></a> [user.get_triumphs() ? "\Roman [user.get_triumphs()]" : "None"]"
			if(SStriumphs.triumph_buys_enabled)
				dat += "<a style='white-space:nowrap;' href='?_src_=prefs;preference=triumph_buy_menu'>Triumph Buy</a>"
			dat += "</td>"

			var/agevetted = user.check_agevet()
			dat += "<td style='width:33%;text-align:right'>"
			dat += "<a href='?_src_=prefs;preference=agevet'><b>VERIFIED:</b></a> [agevetted ? "<font color='#74cde0'>YAE!</font>" : "<font color='#897472'>NAE?</font>"]"
			dat += "</td>"

			dat += "</table>"

			if(CONFIG_GET(flag/roundstart_traits))
				dat += "<center><h2>Quirk Setup</h2>"
				dat += "<a href='?_src_=prefs;preference=trait;task=menu'>Configure Quirks</a><br></center>"
				dat += "<center><b>Current Quirks:</b> [all_quirks.len ? all_quirks.Join(", ") : "None"]</center>"

			// Encapsulating table
			dat += "<table width = '100%'>"
			// Only one Row
			dat += "<tr>"
			// Leftmost Column, 40% width
			dat += "<td width=40% valign='top'>"

// 			-----------START OF IDENT TABLE-----------
			dat += "<h2>Identity</h2>"
			dat += "<table width='100%'><tr><td width='75%' valign='top'>"
			if(is_banned_from(user.ckey, "Appearance"))
				dat += "<b>Thou are banned from using custom names and appearances. Thou can continue to adjust thy characters, but thee will be randomised once thee joins the game.</b><br>"
//			dat += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_NAME]'>Always Random Name: [(randomise[RANDOM_NAME]) ? "Yes" : "No"]</a>"
//			dat += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_NAME_ANTAG]'>When Antagonist: [(randomise[RANDOM_NAME_ANTAG]) ? "Yes" : "No"]</a>"
			dat += "<b>Name:</b> "
			if(check_nameban(user.ckey))
				dat += "<a href='?_src_=prefs;preference=name;task=input'>NAMEBANNED</a><BR>"
			else
				dat += "<a href='?_src_=prefs;preference=name;task=input'>[real_name]</a> <a href='?_src_=prefs;preference=name;task=random'>\[R\]</a>"
			dat += "<BR>"
			dat += "<b>Nickname:</b> "
			dat += "<a href='?_src_=prefs;preference=nickname;task=input'>[nickname]</a><BR>"
			// LETHALSTONE EDIT BEGIN: add pronoun prefs
			dat += "<b>Pronouns:</b> <a href='?_src_=prefs;preference=pronouns;task=input'>[pronouns]</a> <b>Titles:</b> <a href='?_src_=prefs;preference=titles;task=input'>[titles_pref]</a><BR>"
			dat += "<b>Clothing:</b><a href='?_src_=prefs;preference=clothespref;task=input'>[clothes_pref]</a><BR>"
			// LETHALSTONE EDIT END
			if(!voice_pack)
				voice_pack = "Default"
			// LETHALSTONE EDIT BEGIN: add voice type prefs
			dat += "<b>Voice Identity</b>: <a href='?_src_=prefs;preference=voicetype;task=input'>[voice_type]</a><BR>"
			// LETHALSTONE EDIT END
			dat += "<b>Voice Pack</b>: <a href='?_src_=prefs;preference=voicepack;task=input'>[voice_pack]</a>[(voice_pack != "Default") ? "|<a href='?_src_=prefs;preference=voicepack_preview;task=input'>(Sample)</a>" : ""]<BR>"

			dat += "<BR>"
			dat += "<b>Race:</b> <a href='?_src_=prefs;preference=species;task=input'>[pref_species.base_name]</a>[spec_check(user) ? "" : " (!)"]<BR>"
			dat += "<b>Subrace:</b> <a href='?_src_=prefs;preference=subspecies;task=input'>[pref_species.sub_name]</a>[spec_check(user) ? "" : " (!)"]<BR>"
			if(istype(virtue_origin, /datum/virtue/none))
				virtue_origin = GLOB.virtues[/datum/virtue/origin/unknown]
			dat += "<b>Origin:</b> <a href='?_src_=prefs;preference=origin;task=input'>[virtue_origin]</a> <a href='?_src_=prefs;preference=originhelp;task=input'>❖</a><BR>"
			if(length(pref_species.custom_selection))
				var/race_bonus_display
				if(race_bonus)
					for(var/bonus in pref_species.custom_selection)
						if(bonus == race_bonus)
							race_bonus_display = bonus
							break
				dat += "<b>Race Bonus:</b> <a href='?_src_=prefs;preference=race_bonus_select;task=input'>[race_bonus_display ? "[race_bonus_display]" : "None"]</a><BR>"
			else
				race_bonus = null

			var/datum/language/selected_lang
			var/lang_output = "None"
			if(ispath(extra_language, /datum/language))
				selected_lang = extra_language
				lang_output = initial(selected_lang.name)

			dat += "["<b>Free Language: </b><a href='?_src_=prefs;preference=extra_language;task=input'>[lang_output]</a>"]<BR>"

			// LETHALSTONE EDIT BEGIN: add statpack selection
			dat += "<b>Statpack:</b> <a href='?_src_=prefs;preference=statpack;task=input'>[statpack.name]</a><BR>"
			dat += "<BR>"
//			dat += "<a href='?_src_=prefs;preference=species;task=random'>Random Species</A> "
//			dat += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_SPECIES]'>Always Random Species: [(randomise[RANDOM_SPECIES]) ? "Yes" : "No"]</A><br>"

			if(!(AGENDER in pref_species.species_traits))
				var/dispGender
				if(gender == MALE)
					dispGender = "Masculine" // LETHALSTONE EDIT: repurpose gender as bodytype, display accordingly
				else if(gender == FEMALE)
					dispGender = "Feminine" // LETHALSTONE EDIT: repurpose gender as bodytype, display accordingly
				else
					dispGender = "Other"
				dat += "<b>Body Type:</b> <a href='?_src_=prefs;preference=gender'>[dispGender]</a><BR>"
				if(randomise[RANDOM_BODY] || randomise[RANDOM_BODY_ANTAG]) //doesn't work unless random body
					dat += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_GENDER]'>Always Random Bodytype: [(randomise[RANDOM_GENDER]) ? "Yes" : "No"]</A>"
					dat += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_GENDER_ANTAG]'>When Antagonist: [(randomise[RANDOM_GENDER_ANTAG]) ? "Yes" : "No"]</A>"

			if(LAZYLEN(pref_species.allowed_taur_types))
				var/obj/item/bodypart/taur/T = taur_type
				var/name = ispath(T) ? T::name : "None"
				dat += "<b>Taur Body Type:</b> <a href='?_src_=prefs;preference=taur_type;task=input'>[name]</a><BR>"
				dat += "<b>Taur Color:</b><span style='border: 1px solid #161616; background-color: #[taur_color];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=taur_color;task=input'>Change</a><BR>"

			dat += "<b>Age:</b> <a href='?_src_=prefs;preference=age;task=input'>[age]</a><BR>"

//			dat += "<br><b>Age:</b> <a href='?_src_=prefs;preference=age;task=input'>[age]</a>"
//			if(randomise[RANDOM_BODY] || randomise[RANDOM_BODY_ANTAG]) //doesn't work unless random body
//				dat += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_AGE]'>Always Random Age: [(randomise[RANDOM_AGE]) ? "Yes" : "No"]</A>"
//				dat += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_AGE_ANTAG]'>When Antagonist: [(randomise[RANDOM_AGE_ANTAG]) ? "Yes" : "No"]</A>"

//			dat += "<b><a href='?_src_=prefs;preference=name;task=random'>Random Name</A></b><BR>"
			if(!virtue)
				virtue = GLOB.virtues[/datum/virtue/none]
			if(!virtuetwo)
				virtuetwo = GLOB.virtues[/datum/virtue/none]
			var/virtue_html
			if(length(pref_species.restricted_virtues))
				if(virtue.type in pref_species.restricted_virtues)
					virtue = GLOB.virtues[/datum/virtue/none]
				if(virtuetwo.type in pref_species.restricted_virtues)
					virtuetwo = GLOB.virtues[/datum/virtue/none]
			if(istype(virtue, virtuetwo) && !virtue.stackable)
				virtuetwo = GLOB.virtues[/datum/virtue/none]
			if(virtue.virtuous_only && !statpack.virtuous)
				virtue = GLOB.virtues[/datum/virtue/none]
			var/tricost_virt = 0
			if(length(virtue.extra_choices) && length(virtue.picked_choices))
				for(var/i in 1 to length(virtue.picked_choices))
					tricost_virt += virtue.choice_costs[i]
			virtue_html += "<b>Virtue[tricost_virt ? " <font color = '#d1c8bb'>([tricost_virt] TRI)</font>" : ""]:</b> <a href='?_src_=prefs;preference=virtue;task=input'><b><font color = '#cfa971'>[virtue]</font></b></a><BR>"
			if(length(virtue.picked_choices))
				for(var/i = 1 to virtue.picked_choices.len)
					var/choice = virtue.picked_choices[i]
					var/tooltip
					var/choice_string = choice
					var/dat_html = "   <a href='?_src_=prefs;preference=subvirtue;task=remove;index=[i]'><i>[choice_string]</i></a>"
					if(LAZYACCESS(virtue.choice_tooltips, choice))
						tooltip = TRUE
					var/tooltip_html = tooltip ? "<a href='?_src_=prefs;preference=subvirtue;task=tooltip;tooltip=[choice]'>(?)</a><br>" : "<br>"
					virtue_html += "[dat_html][tooltip_html]"
			if(length(virtue.picked_choices) < virtue.max_choices)
				virtue_html += "   <a href='?_src_=prefs;preference=subvirtue;task=input'>[(virtue.choice_costs[(virtue.picked_choices.len + 1)] <= 0) ? "<font color = '#a08357'>" : ""]Pick Bonus[(virtue.choice_costs[(virtue.picked_choices.len + 1)] <= 0) ? "</font>" : ""] [(virtue.choice_costs[(virtue.picked_choices.len + 1)] > 0) ? "([virtue.choice_costs[(virtue.picked_choices.len + 1)]] TRI)" : ""] </a><br>"
			if(statpack.virtuous)
				tricost_virt = 0
				if(length(virtuetwo.extra_choices) && length(virtuetwo.picked_choices))
					for(var/i in 1 to length(virtuetwo.picked_choices))
						tricost_virt += virtuetwo.choice_costs[i]
				virtue_html += "<b>Second Virtue[tricost_virt ? " <font color = '#d1c8bb'>([tricost_virt] TRI)</font>" : ""]:</b> <a href='?_src_=prefs;preference=virtuetwo;task=input'><b><font color = '#cfa971'>[virtuetwo]</font></b></a><BR>"
				if(length(virtuetwo.extra_choices) && length(virtuetwo.picked_choices))
					for(var/i in 1 to length(virtuetwo.picked_choices))
						var/choice = virtuetwo.picked_choices[i]
						var/tooltip
						var/choice_string = choice
						var/dat_html = "   <a href='?_src_=prefs;preference=subvirtue_two;task=remove;index=[i]'><i>[choice_string]</i></a>"
						if(LAZYACCESS(virtuetwo.choice_tooltips, choice))
							tooltip = TRUE
						var/tooltip_html = tooltip ? "<a href='?_src_=prefs;preference=subvirtue_two;task=tooltip;tooltip=[choice]'>(?)</a><br>" : "<br>"
						virtue_html += "[dat_html][tooltip_html]"
				if(length(virtuetwo.picked_choices) < virtuetwo.max_choices)
					virtue_html += "   <a href='?_src_=prefs;preference=subvirtue_two;task=input'>[(virtuetwo.choice_costs[(virtuetwo.picked_choices.len + 1)] <= 0) ? "<font color = '#a08357'>" : ""]Pick Bonus[(virtuetwo.choice_costs[(virtuetwo.picked_choices.len + 1)] <= 0) ? "</font>" : ""] [(virtuetwo.choice_costs[(virtuetwo.picked_choices.len + 1)] > 0) ? "([virtuetwo.choice_costs[(virtuetwo.picked_choices.len + 1)]] TRI)" : ""] </a><br>"
			else
				virtuetwo = GLOB.virtues[/datum/virtue/none]
			var/virtue_fieldset
			if(statpack.virtuous)
				virtue_fieldset += "<fieldset style='border: 1px solid ["#a08357"]; display: inline'>"
				virtue_fieldset += "<legend align='center' style='font-weight: bold; color: ["#a08357"]'>Virtues</legend>"
			dat += virtue_fieldset ? virtue_fieldset : ""
			dat += virtue_html
			dat += virtue_fieldset ? "</fieldset>" : ""
			dat += "<br>"
			dat += "<b>Vices:</b>"
			if(charflaws.len)
				var/has_extra_vice = FALSE
				for(var/i = 1 to charflaws.len)
					var/datum/charflaw/cf = charflaws[i]
					if(!cf)
						continue
					if(!cf.needs_extra_vice)
						has_extra_vice = TRUE
				for(var/i = 1 to charflaws.len)
					var/datum/charflaw/cf = charflaws[i]
					if(!cf)
						continue
					var/warning = ""
					if(cf.needs_extra_vice && !has_extra_vice)
						warning = "<font color = '#910505'>"
					dat += "[warning] <a href='?_src_=prefs;preference=charflaw;task=remove;index=[i]'>[cf]</a>[warning ? " (Requires Extra Vice!)</font>" : ""]"
					if(i < charflaws.len)
						dat += " |"
				dat += "<BR>"
			if(charflaws.len < MAX_VICES)
				dat += "<a href='?_src_=prefs;preference=charflaw;task=input'>Add Vice</a><BR>"

			// Check if any averse vice is selected
			var/has_averse = FALSE
			for(var/datum/charflaw/cf in charflaws)
				if(istype(cf, /datum/charflaw/averse))
					has_averse = TRUE
					break

			if(has_averse)
				if(!averse_chosen_faction)
					averse_chosen_faction = "Inquisition"
				dat += "<b>Loathed Group:</b> <a href='?_src_=prefs;preference=charflaw_averse_choice;task=input'>[averse_chosen_faction]</a><BR>"
			var/datum/faith/selected_faith = GLOB.faithlist[selected_patron?.associated_faith]
			dat += "<b>Faith:</b> <a href='?_src_=prefs;preference=faith;task=input'>[selected_faith?.name || "FUCK!"]</a><BR>"
			dat += "<b>Patron:</b> <a href='?_src_=prefs;preference=patron;task=input'>[selected_patron?.name || "FUCK!"]</a><BR>"
			dat += "<b>Dominance:</b> <a href='?_src_=prefs;preference=domhand'>[domhand == 1 ? "Left-handed" : "Right-handed"]</a><BR>"
			dat += "<b>Food Preferences:</b> <a href='?_src_=prefs;preference=culinary;task=menu'>Change</a><BR>"

			var/musicname = (combat_music.shortname ? combat_music.shortname : combat_music.name)
			dat += "<b>Combat Music:</b> <a href='?_src_=prefs;preference=combat_music;task=input'>[musicname || "FUCK!"]</a><BR>"

			dat += "<b>Unrevivable:</b> <a href='?_src_=prefs;preference=dnr;task=input'>[dnr_pref ? "Yes" : "No"]</a><BR>"
			dat += "<b>Be a Familiar:</b><a href='?_src_=prefs;preference=familiar_prefs;task=input'>Familiar Preferences</a>"
			dat += "<br><b>Nickname Color: </b> </b><a href='?_src_=prefs;preference=highlight_color;task=input'>Change</a>"
			dat += "<br><b>Voice Color: </b><a href='?_src_=prefs;preference=voice;task=input'>Change</a>"
			dat += "<br><b>Voice Pitch: </b><a href='?_src_=prefs;preference=voice_pitch;task=input'>[voice_pitch]</a>"

/*
			dat += "<br><br><b>Special Names:</b><BR>"
			var/old_group
			for(var/custom_name_id in GLOB.preferences_custom_names)
				var/namedata = GLOB.preferences_custom_names[custom_name_id]
				if(!old_group)
					old_group = namedata["group"]
				else if(old_group != namedata["group"])
					old_group = namedata["group"]
					dat += "<br>"
				dat += "<a href ='?_src_=prefs;preference=[custom_name_id];task=input'><b>[namedata["pref_name"]]:</b> [custom_names[custom_name_id]]</a> "
			dat += "<br><br>"

			dat += "<b>Custom Job Preferences:</b><BR>"
			dat += "<a href='?_src_=prefs;preference=ai_core_icon;task=input'><b>Preferred AI Core Display:</b> [preferred_ai_core_display]</a><br>"
			dat += "<a href='?_src_=prefs;preference=sec_dept;task=input'><b>Preferred Security Department:</b> [prefered_security_department]</a><BR></td>"
*/
			var/datum/bark/B = GLOB.bark_list[bark_id]
			dat += "<br>"
			dat += "<b>Vocal Bark Sound:</b><br>"
			dat += "<a href='?_src_=prefs;preference=barksound;task=input'>[B ? initial(B.name) : "INVALID"]</a><br>"
			dat += "<b>Vocal Bark Speed:</b> <a href='?_src_=prefs;preference=barkspeed;task=input'>[bark_speed]</a><br>"
			dat += "<b>Vocal Bark Pitch:</b> <a href='?_src_=prefs;preference=barkpitch;task=input'>[bark_pitch]</a><br>"
			dat += "<b>Vocal Bark Variance:</b> <a href='?_src_=prefs;preference=barkvary;task=input'>[bark_variance]</a><br>"
			dat += "<b><a href='?_src_=prefs;preference=barkpreview;task=input'>Preview Bark</a></b><br>"
			dat += "</td>"
			dat += "</tr></table>"
// 			-----------END OF IDENT TABLE-----------


			// Middle dummy Column, 20% width
			dat += "</td>"
			dat += "<td width=20% valign='top'>"
			// Rightmost column, 40% width
			dat += "<td width=40% valign='top'>"
			dat += "<h2>Body</h2>"

//			-----------START OF BODY TABLE-----------
			dat += "<table width='100%'><tr><td width='1%' valign='top'>"
			var/datum/job/highest_pref
			for(var/job in job_preferences)
				if(job_preferences[job] > highest_pref)
					highest_pref = SSjob.GetJob(job)
			dat += "<b>Update feature colors with change:</b> <a href='?_src_=prefs;preference=update_mutant_colors;task=input'>[update_mutant_colors ? "Yes" : "No"]</a><BR>"
			var/use_skintones = pref_species.use_skintones
			if(use_skintones)

				var/skin_tone_wording = pref_species.skin_tone_wording // Both the skintone names and the word swap here is useless fluff

				dat += "<b>[skin_tone_wording]: </b><a href='?_src_=prefs;preference=s_tone;task=input'>Change </a>"
				dat += "<br>"

			if((MUTCOLORS in pref_species.species_traits) || (MUTCOLORS_PARTSONLY in pref_species.species_traits))

				dat += "<b>Mutant Color #1:</b><span style='border: 1px solid #161616; background-color: #[features["mcolor"]];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color;task=input'>Change</a><BR>"
				dat += "<b>Mutant Color #2:</b><span style='border: 1px solid #161616; background-color: #[features["mcolor2"]];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color2;task=input'>Change</a><BR>"
				dat += "<b>Mutant Color #3:</b><span style='border: 1px solid #161616; background-color: #[features["mcolor3"]];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color3;task=input'>Change</a><BR>"

			dat += "<br><b>Accent:</b> <a href='?_src_=prefs;preference=char_accent;task=input'>[char_accent]</a>"
			dat += "<br><b>Features:</b> <a href='?_src_=prefs;preference=customizers;task=menu'>Change</a>"
			dat += "<br><b>Sprite Scale:</b><a href='?_src_=prefs;preference=body_size;task=input'>[(features["body_size"] * 100)]%</a>"
			dat += "<br><b>Markings:</b> <a href='?_src_=prefs;preference=markings;task=menu'>Change</a>"
			dat += "<br><b>Descriptors:</b> <a href='?_src_=prefs;preference=descriptors;task=menu'>Change</a>"

			dat += "<br><b>Headshot:</b> <a href='?_src_=prefs;preference=headshot;task=input'>Change</a>"
			if(headshot_link != null)
				dat += "<br><img src='[headshot_link]' width='100px' height='100px'>"

			var/examine_theme_name = "None (Use Viewer's)"
			if(examine_theme)
				var/list/all_themes = get_tgui_themes()
				examine_theme_name = all_themes[examine_theme] || examine_theme
			dat += "<br><b>Examine Theme:</b> <a href='?_src_=prefs;preference=examine_theme;task=input'>[examine_theme_name]</a>"

			dat += "<br><b>[(length(flavortext) < MINIMUM_FLAVOR_TEXT) ? "<font color = '#802929'>" : ""]Flavortext:[(length(flavortext) < MINIMUM_FLAVOR_TEXT) ? "</font>" : ""]</b><a href='?_src_=prefs;preference=formathelp;task=input'>(?)</a><a href='?_src_=prefs;preference=flavortext;task=input'>Change</a>"
			dat += "<br><b>NSFW Flavortext:</b><a href='?_src_=prefs;preference=formathelp;task=input'>(?)</a><a href='?_src_=prefs;preference=nsfwflavortext;task=input'>Change</a>"
			dat += "<br><b>[(length(ooc_notes) < MINIMUM_OOC_NOTES) ? "<font color = '#802929'>" : ""]OOC Notes:[(length(ooc_notes) < MINIMUM_OOC_NOTES) ? "</font>" : ""]</b><a href='?_src_=prefs;preference=formathelp;task=input'>(?)</a><a href='?_src_=prefs;preference=ooc_notes;task=input'>Change</a>"

			// Rumours / Gossip
			dat += "<br><b>Rumours & Noble Gossip:</b><a href='?_src_=prefs;preference=formathelp;task=input'>(?)</a><br><a href='?_src_=prefs;preference=rumour;task=input'>Set Rumours</a><a href='?_src_=prefs;preference=gossip;task=input'>Set Gossip</a><a href='?_src_=prefs;preference=rumour_preview;task=input'><i>Preview</i></a>"

			dat += "<br><b>ERP Preferences:</b><a href='?_src_=prefs;preference=formathelp;task=input'>(?)</a><a href='?_src_=prefs;preference=erpprefs;task=input'>Change</a>"
			dat += "<br><b>Song:</b> <a href='?_src_=prefs;preference=ooc_extra;task=input'>Change URL</a>"
			dat += "<a href='?_src_=prefs;preference=change_title;task=input'>Change Title</a>"
			dat += "<a href='?_src_=prefs;preference=change_artist;task=input'>Change Artist</a>"
			dat += "<br><B>Image Gallery:</b> <a href='?_src_=prefs;preference=img_gallery;task=input'>Add</a>"
			dat += "<a href='?_src_=prefs;preference=clear_gallery;task=input'>Clear Gallery</a>"
			dat += "<br><B>NSFW Image Gallery:</b> <a href='?_src_=prefs;preference=nsfw_img_gallery;task=input'>Add</a>"
			dat += "<a href='?_src_=prefs;preference=clear_nsfw_gallery;task=input'>Clear Gallery</a>"
			dat += "<br><a href='?_src_=prefs;preference=ooc_preview;task=input'><b>Preview Examine</b></a>"

			dat += "<br><b>Loadout:</b> <a href='?_src_=prefs;preference=open_loadout;task=input'>Open Menu</a>"
			dat += "</td>"

			dat += "</tr></table>"
//			-----------END OF BODY TABLE-----------
			dat += "</td>"
			dat += "</tr>"
			dat += "</table>"

		if (1) // Game Settings
			used_title = "Game Settings"
			dat += "<table><tr><td width='340px' valign='top'>"
			dat += "<h2>Display</h2>"
			dat += "<b>TGUI Theme:</b> <a href='?_src_=prefs;preference=tgui_theme'>[get_tgui_theme_display_name()]</a><br>"
			dat += "<b>Parchment Theme:</b> <a href='?_src_=prefs;preference=parchment_skin'>[get_parchment_skin_display_name()]</a><br>"
			dat += "<b>Panel Theme:</b> <a href='?_src_=prefs;preference=statbrowser_theme'>[get_statbrowser_theme_display_name()]</a><br>"
			dat += "<b>UI Mode:</b> <a href='?_src_=prefs;preference=tgui_ui_prefs;task=menu'>[tgui_pref ? "TGUI" : "Legacy"]</a><br>"
			dat += "<b>tgui Monitors:</b> <a href='?_src_=prefs;preference=tgui_lock'>[(tgui_lock) ? "Primary" : "All"]</a><br>"
			dat += "<b>Ambient Occlusion:</b> <a href='?_src_=prefs;preference=ambientocclusion'>[ambientocclusion ? "Enabled" : "Disabled"]</a><br>"
			dat += "<b>Window Flashing:</b> <a href='?_src_=prefs;preference=winflash'>[(windowflashing) ? "Enabled":"Disabled"]</a><br>"
			dat += "<b>FPS:</b> <a href='?_src_=prefs;preference=clientfps;task=input'>[clientfps]</a><br>"
			dat += "<b>Fit Viewport:</b> <a href='?_src_=prefs;preference=auto_fit_viewport'>[auto_fit_viewport ? "Auto" : "Manual"]</a><br>"
			if (CONFIG_GET(string/default_view) != CONFIG_GET(string/default_view_square))
				dat += "<b>Widescreen:</b> <a href='?_src_=prefs;preference=widescreenpref'>[widescreenpref ? "Enabled ([CONFIG_GET(string/default_view)])" : "Disabled ([CONFIG_GET(string/default_view_square)])"]</a><br>"
			dat += "<h2>Other</h2>"
			dat += "<b>Be Voice:</b> <a href='?_src_=prefs;preference=schizo_voice'>[(toggles & SCHIZO_VOICE) ? "Enabled":"Disabled"]</a><br>"
			dat += "</td><td width='400px' valign='top'>"
			dat += "<h2>Special Role Settings</h2>"
			if(is_banned_from(user.ckey, ROLE_SYNDICATE))
				dat += "<font color=red><b>I am banned from antagonist roles.</b></font><br>"
				src.be_special = list()

			for (var/i in GLOB.special_roles_rogue)
				if(is_banned_from(user.ckey, i))
					dat += "<b>[capitalize(i)]:</b> <a href='?_src_=prefs;bancheck=[i]'>BANNED</a><br>"
				else
					var/days_remaining = null
					if(ispath(GLOB.special_roles_rogue[i]) && CONFIG_GET(flag/use_age_restriction_for_jobs)) //If it's a game mode antag, check if the player meets the minimum age
						days_remaining = get_remaining_days(user.client)

					if(days_remaining)
						dat += "<b>[capitalize(i)]:</b> <font color=red> \[IN [days_remaining] DAYS]</font><br>"
					else
						dat += "<b>[capitalize(i)]:</b> <a href='?_src_=prefs;preference=be_special;be_special_type=[i]'>[(i in be_special) ? "Enabled" : "Disabled"]</a><br>"
			dat += "<b>Storyteller:</b> <a href='?_src_=prefs;preference=storyteller'>[no_storyteller_events ? "Disabled" : "Enabled"]</a>"

			dat += "</td></tr></table>"

		if(2) //OOC Preferences
			used_title = "OOC"
			dat += "<table><tr><td width='340px' valign='top'>"
			dat += "<h2>OOC Settings</h2>"

			if(user.client)
				if(unlock_content || check_rights_for(user.client, R_ADMIN))
					dat += "<b>OOC Color:</b> <span style='border: 1px solid #161616; background-color: [ooccolor ? ooccolor : GLOB.normal_ooc_colour];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=ooccolor;task=input'>Change</a><br>"

			dat += "</td>"

			if(user.client.holder)
				dat +="<td width='300px' valign='top'>"

				dat += "<h2>Admin Settings</h2>"

				dat += "<b>Adminhelp Sounds:</b> <a href='?_src_=prefs;preference=hear_adminhelps'>[(toggles & SOUND_ADMINHELP)?"Enabled":"Disabled"]</a><br>"
				dat += "<b>Prayer Sounds:</b> <a href = '?_src_=prefs;preference=hear_prayers'>[(toggles & SOUND_PRAYERS)?"Enabled":"Disabled"]</a><br>"
				dat += "<b>Announce Login:</b> <a href='?_src_=prefs;preference=announce_login'>[(toggles & ANNOUNCE_LOGIN)?"Enabled":"Disabled"]</a><br>"
				dat += "<br>"
				dat += "<b>Combo HUD Lighting:</b> <a href = '?_src_=prefs;preference=combohud_lighting'>[(toggles & COMBOHUD_LIGHTING)?"Full-bright":"No Change"]</a><br>"
				dat += "<br>"
				dat += "<b>Hide Dead Chat:</b> <a href = '?_src_=prefs;preference=toggle_dead_chat'>[(chat_toggles & CHAT_DSAY)?"Shown":"Hidden"]</a><br>"
				dat += "<b>Hide Radio Messages:</b> <a href = '?_src_=prefs;preference=toggle_radio_chatter'>[(chat_toggles & CHAT_RADIO)?"Shown":"Hidden"]</a><br>"
				dat += "<b>Hide Prayers:</b> <a href = '?_src_=prefs;preference=toggle_prayers'>[(chat_toggles & CHAT_PRAYER)?"Shown":"Hidden"]</a><br>"
				if(CONFIG_GET(flag/allow_admin_asaycolor))
					dat += "<br>"
					dat += "<b>ASAY Color:</b> <span style='border: 1px solid #161616; background-color: [asaycolor ? asaycolor : "#FF4500"];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=asaycolor;task=input'>Change</a><br>"

				//deadmin
				dat += "<h2>Deadmin While Playing</h2>"
				if(CONFIG_GET(flag/auto_deadmin_players))
					dat += "<b>Always Deadmin:</b> FORCED</a><br>"
				else
					dat += "<b>Always Deadmin:</b> <a href = '?_src_=prefs;preference=toggle_deadmin_always'>[(toggles & DEADMIN_ALWAYS)?"Enabled":"Disabled"]</a><br>"
					if(!(toggles & DEADMIN_ALWAYS))
						dat += "<br>"
						if(!CONFIG_GET(flag/auto_deadmin_antagonists))
							dat += "<b>As Antag:</b> <a href = '?_src_=prefs;preference=toggle_deadmin_antag'>[(toggles & DEADMIN_ANTAGONIST)?"Deadmin":"Keep Admin"]</a><br>"
						else
							dat += "<b>As Antag:</b> FORCED<br>"

						if(!CONFIG_GET(flag/auto_deadmin_heads))
							dat += "<b>As Command:</b> <a href = '?_src_=prefs;preference=toggle_deadmin_head'>[(toggles & DEADMIN_POSITION_HEAD)?"Deadmin":"Keep Admin"]</a><br>"
						else
							dat += "<b>As Command:</b> FORCED<br>"

				dat += "</td>"
			dat += "</tr></table>"

		if(3) // Custom keybindings
			used_title = "Keybinds"
			// Create an inverted list of keybindings -> key
			var/list/user_binds = list()
			for (var/key in key_bindings)
				for(var/kb_name in key_bindings[key])
					user_binds[kb_name] += list(key)

			var/list/kb_categories = list()
			// Group keybinds by category
			for (var/name in GLOB.keybindings_by_name)
				var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
				kb_categories[kb.category] += list(kb)

			dat += "<style>label { display: inline-block; width: 200px; }</style><body>"

			for (var/category in kb_categories)
				for (var/i in kb_categories[category])
					var/datum/keybinding/kb = i
					if(!length(user_binds[kb.name]))
						dat += "<label>[kb.full_name]</label> <a href ='?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name];old_key=["Unbound"]'>Unbound</a>"
//						var/list/default_keys = hotkeys ? kb.hotkey_keys : kb.classic_keys
//						if(LAZYLEN(default_keys))
//							dat += "| Default: [default_keys.Join(", ")]"
						dat += "<br>"
					else
						var/bound_key = user_binds[kb.name][1]
						dat += "<label>[kb.full_name]</label> <a href ='?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
						for(var/bound_key_index in 2 to length(user_binds[kb.name]))
							bound_key = user_binds[kb.name][bound_key_index]
							dat += " | <a href ='?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
						if(length(user_binds[kb.name]) < MAX_KEYS_PER_KEYBIND)
							dat += "| <a href ='?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name]'>Add Secondary</a>"
						var/list/default_keys = hotkeys ? kb.classic_keys : kb.hotkey_keys
						if(LAZYLEN(default_keys))
							dat += "| Default: [default_keys.Join(", ")]"
						dat += "<br>"

			dat += "<br><br>"
			dat += "<a href ='?_src_=prefs;preference=keybinds;task=keybindings_set'>\[Reset to default\]</a>"
			dat += "</body>"


	if(!IsGuestKey(user.key))
		dat += "<a href='?_src_=prefs;preference=save'>Save</a><br>"
		dat += "<a href='?_src_=prefs;preference=load'>Undo</a><br>"

	dat += "<center>"
	var/mob/dead/new_player/N = user
	if(istype(N))
		if(SSticker.current_state <= GAME_STATE_PREGAME)
			switch(N.ready)
				if(PLAYER_NOT_READY)
					dat += "<b>UNREADY</b> <a href='byond://?src=[REF(N)];ready=[PLAYER_READY_TO_PLAY]'>READY</a>"
				if(PLAYER_READY_TO_PLAY)
					dat += "<a href='byond://?src=[REF(N)];ready=[PLAYER_NOT_READY]'>UNREADY</a> <b>READY</b>"
					log_game("([user || "NO KEY"]) readied as ([real_name])")
		else
			if(!is_active_migrant())
				dat += "<a href='byond://?src=[REF(N)];late_join=1'>JOINLATE</a>"
			else
				dat += "<a class='linkOff' href='byond://?src=[REF(N)];late_join=1'>JOINLATE</a>"
			dat += " - <a href='?_src_=prefs;preference=migrants'>MIGRATION</a>"
			dat += "<br><a href='?_src_=prefs;preference=manifest'>ACTORS</a>"
			dat += " - <a href='?_src_=prefs;preference=observe'>VOYEUR</a>"
	else
		dat += "<a href='?_src_=prefs;preference=finished'>DONE</a>"
	dat += "</center>"
//	dat += "<a href='?_src_=prefs;preference=reset_all'>Reset Setup</a>"


	if(user.client?.is_new_player())
		dat = list("<center>REGISTER!</center>")

	winshow(user, "preferencess_window", TRUE)
	winset(user, "preferencess_window", "size=820x900")
	winset(user, "preferencess_window", "pos=280,80")
	var/datum/browser/noclose/popup = new(user, "preferences_browser", "<div align='center'>[used_title]</div>")
	popup.set_window_options("can_close=0")
	popup.set_content(dat.Join())
	popup.open(FALSE)
	if(current_tab == 0)
		winset(user, "preferencess_window.character_preview_map", "is-visible=true")
		update_preview_icon()
	else
		winset(user, "preferencess_window.character_preview_map", "is-visible=false")
//	onclose(user, "preferencess_window", src)

#undef APPEARANCE_CATEGORY_COLUMN
#undef MAX_MUTANT_ROWS
