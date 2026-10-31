/datum/controller/global_vars/Initialize(mapload)
	. = ..()
	roguetraits[TRAIT_DISGRACED_NOBLE] = span_warning("I was a scion of a noble house... long ago.")
	roguetraits[TRAIT_DWARVEN_CHEF] = span_info("I know the dwarven trick to cutting a proper pretzel.")
	roguetraits[TRAIT_ASSASSIN_TARGET] = span_warning("Something in my past has made me a target. I'm always looking over my shoulder.")
	roguetraits[TRAIT_GNOLL_HUNTED] = span_cultsmall("Graggar's champions hunger for me. I hear their cackles anywhere I go.")
	roguetraits[TRAIT_GOSSIPER] = span_info("I have an ear for gossip, even amongst those with blue blood.")
	roguetraits[TRAIT_MALODOROUS] = span_warning("My body odor is unbearable without regular baths, and others can tell.")
	roguetraits[TRAIT_PRETTY] = span_info("I'm told I'm rather easy on the eyes.")
	roguetraits[TRAIT_SCARRED] = span_info("My face bears terrible scars that make identification difficult.")
	roguetraits[TRAIT_UNDERDARK_CHEF] = span_info("I've learned the culinary secrets of the Underdark, and can prepare its delicacies.")
	roguetraits[TRAIT_UNSETTLING] = span_warning("My appearance is deeply unsettling to most. There's something profoundly wrong about my features.")

/datum/stressevent/pretty
	desc = span_green("Their face is certainly easy on the eyes.")
	timer = 1 MINUTES

/datum/food_recipe/dough/prezzel/user_can_make(mob/user)
	return ..() || HAS_TRAIT(user, TRAIT_DWARVEN_CHEF)

/datum/food_recipe/spider_meatball/user_can_make(mob/user)
	return ..() || HAS_TRAIT(user, TRAIT_UNDERDARK_CHEF)

/datum/food_recipe/spider_surprise/user_can_make(mob/user)
	return ..() || HAS_TRAIT(user, TRAIT_UNDERDARK_CHEF)

/datum/food_recipe/pie/spider/user_can_make(mob/user)
	return ..() || HAS_TRAIT(user, TRAIT_UNDERDARK_CHEF)

/mob/living/carbon/human/on_examine_face(mob/living/carbon/human/user)
	. = ..()
	if(!istype(user) || user == src)
		return
	if(HAS_TRAIT(src, TRAIT_PRETTY) && !HAS_TRAIT(src, TRAIT_BEAUTIFUL)) //Beautiful takes priority if you somehow have both
		user.add_stress(/datum/stressevent/pretty)
		to_chat(user, span_info("[p_they(TRUE)] [p_are()] pretty."))
	if(HAS_TRAIT(src, TRAIT_UNSETTLING))
		user.add_stress(/datum/stressevent/uncanny)

/mob/living/carbon/human/proc/quirk_examine_lines(mob/user, m1, m2)
	var/list/lines = list()
	if(HAS_TRAIT(src, TRAIT_DISGRACED_NOBLE))
		if(HAS_TRAIT(user, TRAIT_NOBLE))
			lines += span_phobia("A disgraced member of the nobility...")
		else
			lines += span_notice("A disgraced noble.")

	if(HAS_TRAIT(src, TRAIT_PRETTY) && !HAS_TRAIT(src, TRAIT_BEAUTIFUL) && !HAS_TRAIT(src, TRAIT_BEAUTIFUL_UNCANNY))
		switch(pronouns)
			if(HE_HIM)
				lines += span_pretty_masc("[m1] pretty handsome.")
			if(SHE_HER)
				lines += span_pretty_fem("[m1] pretty.")
			if(THEY_THEM, IT_ITS)
				lines += span_pretty_nb("[m1] pretty good-looking.")

	if(HAS_TRAIT(src, TRAIT_SCARRED))
		lines += span_redtext("[capitalize(m2)] face is marked with terrible scars.")

	if(HAS_TRAIT(src, TRAIT_UNSETTLING))
		var/unsettling_text
		if(user == src)
			unsettling_text = "I appear deeply uncanny."
		else if(user.has_stress_event(/datum/stressevent/uncanny))
			unsettling_text = "[capitalize(m2)] appearance is deeply unsettling!"
		else
			unsettling_text = "Something about [p_them()] looks off..."
		switch(pronouns)
			if(HE_HIM)
				lines += span_beautiful_masc(unsettling_text)
			if(SHE_HER)
				lines += span_beautiful_fem(unsettling_text)
			if(THEY_THEM, IT_ITS)
				lines += span_beautiful_nb(unsettling_text)
	return lines

// Scarred trait only hides the name, nothing else
/mob/living/carbon/human/proc/scarred_examine_name(used_name, observer_privilege)
	if(!HAS_TRAIT(src, TRAIT_SCARRED) || observer_privilege)
		return used_name
	// Use descriptor system like masked characters
	var/list/d_list = get_mob_descriptors()
	var/trait_desc = "[capitalize(build_coalesce_description_nofluff(d_list, src, list(MOB_DESCRIPTOR_SLOT_TRAIT), "%DESC1%"))]"
	var/stature_desc = "[capitalize(build_coalesce_description_nofluff(d_list, src, list(MOB_DESCRIPTOR_SLOT_STATURE), "%DESC1%"))]"
	var/descriptor_name = "[trait_desc] [stature_desc]"
	if(descriptor_name != " " && descriptor_name != "")
		return descriptor_name
	// Fallback to gender-based unknown name
	return "Unknown [(gender == FEMALE) ? "Woman" : "Man"]"
