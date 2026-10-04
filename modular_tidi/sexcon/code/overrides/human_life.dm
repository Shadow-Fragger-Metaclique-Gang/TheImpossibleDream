/mob/living/carbon/human/Life()
	. = ..()
	if(QDELETED(src) || notransform)
		return
	if(sexcon && client?.prefs?.sexable)
		sexcon.process_sexcon(1 SECONDS)
