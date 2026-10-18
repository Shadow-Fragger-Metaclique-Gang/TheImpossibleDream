/world/AVerbsAdmin()
	. = ..()
	. += /client/proc/deliver_assayer_shipment

/client/proc/deliver_assayer_shipment()
	set name = "Deliver Assayer Shipment"
	set category = "Debug"

	if(!check_rights(R_ADMIN))
		return
	if(GLOB.inquisition_shipment_delivered)
		to_chat(src, span_warning("The Inquisition shipment was already delivered."))
		return
	if(alert(src, "Deliver the Inquisition's shipment of INDEXERs and blood vials now?", "Inquisition shipment", "Yes", "No") != "Yes")
		return
	if(!deliver_inquisition_shipment(forced = TRUE))
		to_chat(src, span_warning("The Inquisition shipment was already delivered, or there's no imports area on the map."))
		return
	message_admins("[key_name_admin(src)] delivered the Inquisition shipment early.")
	log_admin("[key_name(src)] delivered the Inquisition shipment early.")

/datum/mind/get_common_admin_commands()
	. = ..()
	var/mob/living/carbon/human/H = current
	var/out = "<br><i><b>Heretic:</b></i> "
	if(istype(H))
		out += "Blood corruption: [H.get_blood_corruption()] (base [H.blood_corruption]) <a href='?src=[REF(src)];heretic=set_corruption'>Set</a><br>"
	var/list/header_parts = list()
	if(heretic_path)
		var/datum/patron/patron_type = heretic_path.patron_type
		header_parts += span_bad("[initial(patron_type.name)], tier [heretic_path.tier][heretic_path.chosen_path ? ", [heretic_path.chosen_path]" : ""]")
		header_parts += "<a href='?src=[REF(src)];heretic=remove'>Remove</a>"
	else
		header_parts += span_highlight("None")
		if(heretic_converted)
			header_parts += "Converted, can't awaken"
			header_parts += "<a href='?src=[REF(src)];heretic=clear_converted'>Clear</a>"
		else if(heretic_awaken_timer)
			header_parts += "Awakening in [DisplayTimeText(timeleft(heretic_awaken_timer))]"
		if(istype(H) && can_heretic_awaken())
			header_parts += "<a href='?src=[REF(src)];heretic=awaken'>Awaken now</a>"
		else
			header_parts += "<a class='linkOff'>Awaken now (not eligible)</a>"
		header_parts += "<a href='?src=[REF(src)];heretic=force'>Force awaken</a>"
		var/rolled = GLOB.heretic_awakening_rolls[ckey(key)]
		header_parts += "Roll: [isnull(rolled) ? "not yet ([heretic_awakening_chance()]% chance)" : (rolled ? "passed" : "failed")]"
	out += header_parts.Join(" | ") + "<br>"
	if(!heretic_path)
		return . + out
	var/datum/objective/heretic/objective = heretic_path.current_objective
	if(objective)
		var/progress = replacetext(replacetext(objective.progress_text(), "- INCOMPLETE", "- [span_red("INCOMPLETE")]"), "- COMPLETE", "- [span_green("COMPLETE")]")
		out +="Objective: [objective.name]: [objective.explanation_text] [objective.completed ? span_good("(done)") : span_bad("(not done)")][progress ? " [progress]" : ""]<br>"
	else
		out += "Objective: none<br>"
	var/list/commands = list(
		"<a href='?src=[REF(src)];heretic=complete'>Complete objective</a>",
		"<a href='?src=[REF(src)];heretic=advance'>Advance tier (with rewards)</a>",
		"<a href='?src=[REF(src)];heretic=reroll'>Reroll objective</a>",
		"<a href='?src=[REF(src)];heretic=set_tier'>Set tier (no rewards)</a>",
	)
	out += commands.Join(" | ")
	return . + out

/datum/mind/Topic(href, href_list)
	if(!href_list["heretic"])
		return ..()
	if(!check_rights(R_ADMIN))
		return
	var/mob/living/carbon/human/H = current
	if(!istype(H))
		to_chat(usr, span_warning("[name] has no human body."))
		return
	switch(href_list["heretic"])
		if("awaken") // If someone is already on track to awaken, force them to early
			if(!can_heretic_awaken())
				return
			if(heretic_awaken_timer)
				deltimer(heretic_awaken_timer)
				heretic_awaken_timer = null
			awaken_heretic()
			message_admins("[key_name_admin(usr)] awakened [key_name_admin(H)] as a heretic of [H.patron.name].")
			log_admin("[key_name(usr)] awakened [key_name(H)] as a heretic of [H.patron.name].")
		if("force") // If someone is ineligible to awaken, force them to even if they aren't of inhumen faith
			if(heretic_path)
				return
			if(!istype(H.patron, /datum/patron/inhumen)) // If they aren't of inhumen faith, make them one
				var/list/gods = list("Zizo" = /datum/patron/inhumen/zizo, "Graggar" = /datum/patron/inhumen/graggar, "Matthios" = /datum/patron/inhumen/matthios, "Baotha" = /datum/patron/inhumen/baotha)
				var/choice = input(usr, "[H] doesn't worship an Inhumen patron. Which one should they?", "Force awaken") as null|anything in gods
				if(!choice || heretic_path)
					return
				H.set_patron(gods[choice])
			if(heretic_awaken_timer)
				deltimer(heretic_awaken_timer)
				heretic_awaken_timer = null
			heretic_converted = FALSE
			awaken_heretic()
			message_admins("[key_name_admin(usr)] forced [key_name_admin(H)] to awaken as a heretic of [H.patron.name].")
			log_admin("[key_name(usr)] forced [key_name(H)] to awaken as a heretic of [H.patron.name].")
		if("set_corruption") // Set blood corruption value forcefully, mostly for testing purposes
			var/new_corruption = input(usr, "Set [H]'s base blood corruption (0 to 100).", "Blood corruption", H.blood_corruption) as null|num
			if(isnull(new_corruption))
				return
			H.set_blood_corruption(new_corruption)
			message_admins("[key_name_admin(usr)] set [key_name_admin(H)]'s base blood corruption to [H.blood_corruption].")
			log_admin("[key_name(usr)] set [key_name(H)]'s base blood corruption to [H.blood_corruption].")
		if("remove")
			lose_heretic_awakening()
			message_admins("[key_name_admin(usr)] removed [key_name_admin(H)]'s heretic awakening.")
			log_admin("[key_name(usr)] removed [key_name(H)]'s heretic awakening.")
		if("clear_converted") // Force the variable set by conversion to false, allowing converted heretics to awaken
			heretic_converted = FALSE
			message_admins("[key_name_admin(usr)] cleared [key_name_admin(H)]'s heretic conversion.")
			log_admin("[key_name(usr)] cleared [key_name(H)]'s heretic conversion.")
		if("complete") // Force current objectives to completion
			var/datum/objective/heretic/objective = heretic_path?.current_objective
			if(!objective)
				return
			objective.complete()
			message_admins("[key_name_admin(usr)] completed [key_name_admin(H)]'s heretic objective: [objective.name].")
			log_admin("[key_name(usr)] completed [key_name(H)]'s heretic objective: [objective.name].")
		if("advance") // Advance their tier but place their rewards at their feet, forcing completion is preferable because it means they collect their rewards normally
			if(!heretic_path?.current_objective)
				return
			heretic_path.current_objective.complete()
			heretic_path.try_advance(H)
			message_admins("[key_name_admin(usr)] advanced [key_name_admin(H)]'s heretic tier to [heretic_path.tier].")
			log_admin("[key_name(usr)] advanced [key_name(H)]'s heretic tier to [heretic_path.tier].")
		if("reroll") // If a tier has multiple objective options, reroll them
			if(!heretic_path)
				return
			QDEL_NULL(heretic_path.current_objective)
			heretic_path.give_tier_objective()
			message_admins("[key_name_admin(usr)] rerolled [key_name_admin(H)]'s heretic objective to [heretic_path.current_objective?.name || "nothing"].")
			log_admin("[key_name(usr)] rerolled [key_name(H)]'s heretic objective to [heretic_path.current_objective?.name || "nothing"].")
		if("set_tier") // Set their tier without giving them any rewards or removing any they've might've already claimed
			if(!heretic_path)
				return
			var/new_tier = input(usr, "Set [H]'s tier (0 to 5). No rewards are granted.", "Set tier", heretic_path.tier) as null|num
			if(isnull(new_tier) || !heretic_path)
				return
			QDEL_NULL(heretic_path.current_objective)
			heretic_path.tier = clamp(round(new_tier), 0, 5)
			heretic_path.give_tier_objective()
			message_admins("[key_name_admin(usr)] set [key_name_admin(H)]'s heretic tier to [heretic_path.tier].")
			log_admin("[key_name(usr)] set [key_name(H)]'s heretic tier to [heretic_path.tier].")
	traitor_panel()

/datum/admins/build_antag_listing()
	. = ..()
	var/list/awakened = list()
	var/list/passed = list()
	var/list/failed = list()
	var/list/not_rolled = list()
	for(var/datum/mind/M in SSticker.minds)
		var/list/parts = list()
		if(M.current)
			parts += "<a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(M.current)]'>[M.current.real_name]</a> ([M.assigned_role])"
		else
			parts += "<a href='?_src_=vars;[HrefToken()];Vars=[REF(M)]'>[M.name]</a> ([M.assigned_role])"
		var/list/commands = list("<a href='?priv_msg=[ckey(M.key)]'>PM</a>")
		commands += M.current ? "<a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(M.current)]'>FLW</a>" : ""
		commands += "<a href='?_src_=holder;[HrefToken()];traitor=[REF(M)]'>TP</a>"
		if(M.heretic_path)
			var/datum/patron/patron_type = M.heretic_path.patron_type
			parts += "[initial(patron_type.name)], tier [M.heretic_path.tier][M.heretic_path.chosen_path ? ", [M.heretic_path.chosen_path]" : ""]"
			if(!M.current)
				parts += "<font color=red>(Body destroyed)</font>"
			else if(M.current.stat == DEAD)
				parts += "<font color=red>(DEAD)</font>"
			else if(!M.current.client)
				parts += "(No client)"
			else
				parts += ""
			awakened += "<tr><td>[(parts + commands).Join("</td><td>")]</td></tr>"
			continue
		if(!M.can_heretic_awaken())
			continue
		var/mob/living/carbon/human/H = M.current
		parts += H.patron.name
		var/rolled = GLOB.heretic_awakening_rolls[ckey(M.key)]
		if(isnull(rolled))
			parts += "Not rolled ([M.heretic_awakening_chance()]%)"
			not_rolled += "<tr><td>[(parts + commands).Join("</td><td>")]</td></tr>"
		else if(rolled)
			parts += "<font color='green'>Passed</font>[M.heretic_awaken_timer ? ", awakens in [DisplayTimeText(timeleft(M.heretic_awaken_timer))]" : ""]"
			passed += "<tr><td>[(parts + commands).Join("</td><td>")]</td></tr>"
		else
			parts += "<font color='red'>Failed</font> ([M.heretic_awakening_chance()]%)"
			failed += "<tr><td>[(parts + commands).Join("</td><td>")]</td></tr>"
	var/list/section = list("<br><b>Heretics</b><br>")
	section += "<font color='#888888'>Awakened: [length(awakened)] | Awaiting: [length(passed)] | Failed roll: [length(failed)] | Not rolled: [length(not_rolled)]</font><br>"
	if(length(awakened))
		section += "<br>Awakened<table cellspacing=5>[awakened.Join()]</table>"
	if(length(passed) || length(failed) || length(not_rolled))
		section += "<br>Eligible<table cellspacing=5>[(passed + failed + not_rolled).Join()]</table>"
	return . + section.Join()
