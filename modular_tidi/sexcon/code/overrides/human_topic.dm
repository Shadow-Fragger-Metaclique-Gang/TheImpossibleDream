/mob/living/carbon/human/Topic(href, href_list)
	if(href_list["chastitything"])
		modular_handle_chastitything(usr)
		return
	return ..()
