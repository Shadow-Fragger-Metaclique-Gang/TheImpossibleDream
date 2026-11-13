GLOBAL_LIST_INIT(bunker_bypasses, load_bypasses_from_file())

/client/proc/bunker_bypass_check()
	if (ckey in GLOB.bunker_bypasses)
		GLOB.bunker_bypasses -= ckey
		save_bypasses_to_file()
		return TRUE
	return FALSE

/client/proc/bunker_bypass()
	set category = "Server"
	set name = "Add Bunker Bypass"

	// [SURREALIS-EDIT] - PLASMA_OPTS
	// SURREALIS-EDIT - ORIGINAL
	/*
	var/selection = input(usr, "Who would you like to let in?", "CKEY", "") as text|null
	if(selection)
		add_bunker_bypass(selection, ckey)
	*/
	if(!check_rights())
		return

	var/selection = input(usr, "Who would you like to let in?", "CKEY", "") as text|null
	if(selection)
		if(ckey(selection) in GLOB.bunker_bypasses)
			to_chat(src, span_warning("Player with ckey [selection] is already on the list."))
			return
		if(alert("Confirm: allow ckey [selection] to connect?", "", "Yes!", "No") == "Yes!")
			add_bunker_bypass(selection, ckey)
	// [/SURREALIS-EDIT]

/proc/add_bunker_bypass(target_ckey, admin_ckey = "SYSTEM")
	if(!target_ckey)
		return

	// [SURREALIS-ADD] - PLASMA_OPTS
	if(IsAdminAdvancedProcCall())
		return

	// [/SURREALIS-ADD]
	target_ckey = ckey(target_ckey)
	GLOB.bunker_bypasses |= target_ckey
	message_admins("BUNKER BYPASS: Added [target_ckey] to the bypass list[admin_ckey? " by [admin_ckey]":""]")
	log_admin("BUNKER BYPASS: Added [target_ckey] to the bypass list[admin_ckey? " by [admin_ckey]":""]")
	save_bypasses_to_file()

/proc/load_bypasses_from_file()
	var/json_file = file("data/whitelist.json")
	if(fexists(json_file))
		var/list/json = json_decode(file2text(json_file))
		return json["data"]
	else
		return list()


/proc/save_bypasses_to_file()
	var/json_file = file("data/whitelist.json")
	var/list/file_data = list()
	file_data["data"] = GLOB.bunker_bypasses
	fdel(json_file)
	WRITE_FILE(json_file,json_encode(file_data))

