/client/verb/toggle_ERP_visuals()
	set category = "Preferences.Sensual"
	set name = "Toggle ERP Visual Effects"
	if(prefs)
		prefs.erp_visuals = !prefs.erp_visuals
		prefs.save_preferences()
		if(prefs.erp_visuals)
			to_chat(src, "ERP visual effects enabled.")
		else
			to_chat(src, "ERP visual effects disabled.")
			var/mob/living/carbon/human/H = mob
			if(istype(H) && H.sexcon)
				H.sexcon.update_pink_screen()

/client/verb/toggle_Chastity() // Alters whether the user can see or interact with any content related to chastity devices, including the devices themselves, actions that target them, and messages related to them. This is intended for users who want to avoid accidentally encountering this content, but still want to be able to use the game without missing out on unrelated features.
	set category = "Preferences.Sensual"
	set name = "Toggle Chastity Content"
	if(prefs)
		prefs.chastenable = !prefs.chastenable
		prefs.save_preferences()
		if(prefs.chastenable)
			to_chat(src, "Chastity content enabled.")
		else
			if(hascall(src, "modular_handle_chastity_toggle_disable"))
				call(src, "modular_handle_chastity_toggle_disable")()
			to_chat(src, "Chastity content disabled.")

/client/verb/toggle_Chastity_Hardmode()
	set category = "Preferences.Sensual"
	set name = "Toggle Permanent Binding"
	
	if(!prefs)
		return
	
	// Enabling hard mode requires confirmation
	if(prefs.chastity_hardmode == CHASTITY_HARDMODE_DISABLED)
		var/confirm = alert(src, 
			"PERMANENT CHASTITY BINDING:\n\n\
			• Only the device's unique key can unlock it\n\
			• Keys can be lost, stolen, or destroyed forever\n\
			• Divine intervention will not free you\n\
			• Lockpicks and tools will fail\n\
			• Even the Duke's master key holds no power\n\
			• Physical removal is impossible\n\
			• You will remain bound until the key releases you\n\n\
			Do you accept these terms of permanent binding?",
			"Permanent Chastity Binding",
			"I accept the binding",
			"I refuse")
		
		if(confirm != "I accept the binding")
			to_chat(src, span_notice("You decline the permanent binding."))
			return
		
		prefs.chastity_hardmode = CHASTITY_HARDMODE_ENABLED
		prefs.save_preferences()
		if(ishuman(mob))
			var/mob/living/carbon/human/H = mob
			H.chastity_device?.sync_generated_key_metadata(H, mob)
		to_chat(src, span_boldwarning("You have accepted the terms of PERMANENT BINDING. Only keys shall grant freedom."))
		log_game("[key_name(src)] enabled permanent chastity binding.")
		message_admins("[key_name_admin(src)] enabled permanent chastity binding.")
	else
		// Disabling requires the humiliation prayer
		to_chat(src, span_notice("To disable permanent binding, you must recite the Prayer of Foolish Repentance to Eora."))
		var/sacred_prayer = "Dear Eora, I embraced this binding in foolish haste because I'm a dullard and I'm sorry, so so so sorry for being such a stupid stupid stupid person and I'm begging you please please please free my loins."
		var/encoded_sacred_prayer = html_encode(sacred_prayer)
		var/prayer_prompt = "Recite the Prayer of Foolish Repentance EXACTLY as written:\n\n\"[sacred_prayer]\"\n\n(You must type this yourself - copying is forbidden by divine law)"
		// multiline=TRUE so the wrapping textarea is readable; bigmodal=TRUE for a large window that shows the full prompt.
		// The nopaste variant enforces hand-typing; max_length locks out anything longer than the prayer itself.
		var/prayer_attempt = tgui_input_text_nopaste(src, prayer_prompt, "Prayer of Foolish Repentance", default = "", max_length = length(encoded_sacred_prayer), multiline = TRUE, encode = TRUE, ui_state = GLOB.tgui_always_state, bigmodal = TRUE)

		if(!prayer_attempt)
			to_chat(src, span_warning("Eora does not hear your silence."))
			return

		// tgui_input_text() html-encodes player input, so compare against the prayer normalized the same way.
		if(prayer_attempt != encoded_sacred_prayer)
			to_chat(src, span_warning("Eora rejects your imperfect prayer. You must recite it EXACTLY as written."))
			to_chat(src, span_notice("You wrote: \"[prayer_attempt]\""))
			to_chat(src, span_notice("Required: \"[sacred_prayer]\""))
			log_game("[key_name(src)] failed the humiliation prayer (incorrect text).")
			return

		// They did it! The humiliation is complete
		prefs.chastity_hardmode = CHASTITY_HARDMODE_DISABLED
		prefs.save_preferences()
		if(ishuman(mob))
			var/mob/living/carbon/human/H = mob
			H.chastity_device?.sync_generated_key_metadata(H)
		to_chat(src, span_boldnotice("Eora hears your pathetic plea and takes pity upon you. The permanent binding is lifted."))
		to_chat(src, span_notice("You have revoked the permanent binding. Mortal means may now test the lock once more."))
		log_game("[key_name(src)] disabled permanent chastity binding via humiliation prayer.")
		message_admins("[key_name_admin(src)] disabled permanent chastity binding by reciting the humiliation prayer.")

/client/verb/toggle_extreme_ERP()// toggles gore, ryona, and other extreme content in the ERP panel. This is separate from the regular ERP toggle for users who want to avoid just the extreme content but are okay with milder stuff.
	set category = "Preferences.Sensual"
	set name = "Toggle Extreme ERP Content"
	if(prefs)
		prefs.extreme_erp = !prefs.extreme_erp
		prefs.save_preferences()
		if(prefs.extreme_erp)
			to_chat(src, "Extreme ERP content enabled in the ERP panel.")
		else
			if(hascall(src, "modular_handle_extreme_erp_toggle_disable"))
				call(src, "modular_handle_extreme_erp_toggle_disable")()
			to_chat(src, "Extreme ERP content disabled in the ERP panel.")

/client/verb/toggle_facial_brands()
	set category = "Preferences.Sensual"
	set name = "Toggle Facial Branding"
	if(prefs)
		prefs.facial_brands = !prefs.facial_brands
		prefs.save_preferences()
		if(prefs.facial_brands)
			to_chat(src, "Your head area can now be branded by others.")
		else
			to_chat(src, "Your head area can no longer be branded by others.")

/client/verb/toggle_sensitive_brands()
	set category = "Preferences.Sensual"
	set name = "Toggle Sensitive Branding"
	if(prefs)
		prefs.sensitive_brands = !prefs.sensitive_brands
		prefs.save_preferences()
		if(prefs.sensitive_brands)
			to_chat(src, "Your genital and breast organs can now be branded by others.")
		else
			to_chat(src, "Your genital and breast organs can no longer be branded by others.")

/client/verb/toggle_pubes()
	set category = "Preferences.Sensual"
	set name = "Toggle Pubic Hair Descriptors"
	if(prefs)
		prefs.pubes = !prefs.pubes
		prefs.save_preferences()
		if(prefs.pubes)
			to_chat(src, "Pubic hair descriptors are now visible when examining exposed players.")
		else
			to_chat(src, "You will no longer see pubic hair descriptions when examining exposed players.")

/client/verb/toggle_pits()
	set category = "Preferences.Sensual"
	set name = "Toggle Armpit Hair Descriptors"
	if(prefs)
		prefs.pits = !prefs.pits
		prefs.save_preferences()
		if(prefs.pits)
			to_chat(src, "Armpit hair descriptors are now visible when examining exposed players.")
		else
			to_chat(src, "You will no longer see armpit hair descriptors when examining players.")

/client/verb/toggle_descriptor_color()
	set category = "Preferences.Sensual"
	set name = "Toggle Colored Descriptors"
	if(prefs)
		prefs.descriptor_color = !prefs.descriptor_color
		prefs.save_preferences()
		if(prefs.descriptor_color)
			to_chat(src, "Genital and body hair descriptor colors are now visible.")
		else
			to_chat(src, "Genital and body hair descriptor colors are no longer visible.")

/client/verb/toggle_edging() // Toggles edging content in the ERP panel, for psydonites who clearly can't ENDURE.
	set category = "Preferences.Sensual"
	set name = "Toggle Edging Content"
	if(prefs)
		prefs.edging = !prefs.edging
		prefs.save_preferences()
		if(prefs.edging)
			to_chat(src, "You ENDVRE through orgasms.")
		else
			to_chat(src, "You will no longer ENDVRE through orgasms.")

/client/verb/toggle_free_use_default()
	set category = "Preferences.Sensual"
	set name = "Toggle Free Use Default"
	if(prefs)
		prefs.free_use_default = !prefs.free_use_default
		prefs.save_preferences()
		if(prefs.free_use_default)
			to_chat(src, "You will now start with Free Use enabled by default.")
		else
			to_chat(src, "You will no longer start with Free Use enabled by default.")


/client/verb/toggle_cursed_collars() // Toggles cursed collars. Will drop existing collars if toggled off while wearing one
	set category = "Preferences.Sensual"
	set name = "Toggle Cursed Collars"
	if(!prefs)
		return
	prefs.cursed_collarable = !prefs.cursed_collarable
	prefs.save_preferences()
	if(prefs.cursed_collarable)
		to_chat(src, "You can now be collared.")
		return
	to_chat(src, "You are no longer able to be collared")
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/human_user = usr
	var/obj/item/clothing/neck/roguetown/cursed_collar/collar = human_user.wear_neck
	if(!istype(collar))
		return
	collar.dropped(human_user)
