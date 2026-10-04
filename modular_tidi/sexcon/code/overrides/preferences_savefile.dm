/datum/preferences/load_preferences()
	. = ..()
	if(!.)
		return
	var/savefile/S = new /savefile(path)
	if(!S)
		return
	S.cd = "/"
	S["erp_visuals"]		>> erp_visuals
	S["chastenable"]		>> chastenable
	S["chastity_hardmode"]	>> chastity_hardmode
	S["extreme_erp"]		>> extreme_erp
	S["edging"]				>> edging
	S["free_use_default"]	>> free_use_default
	S["sensitive_brands"] 	>> sensitive_brands
	S["facial_brands"] 		>> facial_brands
	S["pubes"]				>> pubes
	S["pits"]				>> pits
	S["descriptor_color"]	>> descriptor_color
	S["cursed_collarable"] 	>> cursed_collarable
	chastity_hardmode = sanitize_integer(chastity_hardmode, CHASTITY_HARDMODE_DISABLED, CHASTITY_HARDMODE_ENABLED, initial(chastity_hardmode))

/datum/preferences/save_preferences()
	. = ..()
	if(!.)
		return
	var/savefile/S = new /savefile(path)
	if(!S)
		return
	S.cd = "/"
	WRITE_FILE(S["erp_visuals"], erp_visuals)
	WRITE_FILE(S["chastenable"], chastenable)
	WRITE_FILE(S["chastity_hardmode"], chastity_hardmode)
	WRITE_FILE(S["extreme_erp"], extreme_erp)
	WRITE_FILE(S["edging"], edging)
	WRITE_FILE(S["free_use_default"], free_use_default)
	WRITE_FILE(S["sensitive_brands"], sensitive_brands)
	WRITE_FILE(S["facial_brands"], facial_brands)
	WRITE_FILE(S["pubes"], pubes)
	WRITE_FILE(S["pits"], pits)
	WRITE_FILE(S["descriptor_color"], descriptor_color)
	WRITE_FILE(S["cursed_collarable"], cursed_collarable)
