/obj/structure/roguemachine/bounty/consult_bounties(mob/living/carbon/human/user)
	var/bounty_found = FALSE
	var/consult_menu
	consult_menu += "<center>BOUNTIES<BR>"
	consult_menu += "--------------<BR>"
	for(var/datum/bounty/saved_bounty in GLOB.head_bounties)
		if(!(get_excidium_faction_flags(user) & excidium_employer_to_flag(saved_bounty.employer)))
			continue

		consult_menu += saved_bounty.banner
		bounty_found = TRUE

	if(bounty_found)
		var/datum/browser/popup = new(user, "BOUNTIES", "", 500, 300)
		popup.set_content(consult_menu)
		popup.open()
	else
		say("No bounties are currently active.")
