/datum/runeritual/god/ascension
	abstract_type = /datum/runeritual/god/ascension
	name = "Rite of Ascension"
	desc = "Provide concord of your success to your patron's demands, progressing your path further and granting rewards."
	flavor = "The path of proving one's loyalty to the ANATHEMA is paved with sacrifice. Not your own, of course. What sort of foolish deity would ask that their followers spill their own blood? Such is an antiquated practice reserved only for those of Pantheonic worship."
	awakened_heretic_only = TRUE

/datum/runeritual/god/ascension/get_layout(mob/living/user)
	var/datum/objective/heretic/objective = user?.mind?.heretic_path?.current_objective
	if(objective?.rite_offering)
		return list("C" = objective.rite_offering)

/datum/runeritual/god/ascension/lock_reason(mob/living/user, obj/structure/ritualcircle/circle)
	. = ..()
	if(.)
		return
	var/datum/objective/heretic/objective = user.mind?.heretic_path?.current_objective
	if(!objective)
		return "My patron has nothing to ask of me."
	if(!objective.completed && !objective.rite_offering)
		return "My patron is not yet satisfied."

/datum/runeritual/god/ascension/check_layout(mob/living/user, obj/structure/ritualcircle/circle)
	. = ..()
	if(!.)
		return
	var/list/selected_atoms = .
	var/datum/objective/heretic/objective = user.mind.heretic_path.current_objective
	var/refusal = objective.check_offering(user, selected_atoms["C"])
	if(refusal)
		deny(user, circle, refusal)
		return FALSE

// Set `rite_chant_lines = list()` on an objective variable to adjust its chant lines when completing the rite of ascension for it
/*
/datum/objective/heretic/zizo/wagabababobo
	name = "Waga Baba Bobo"
	heretic_tier = 4
	heretic_branch = HERETIC_PATH_AMBITION
	rite_offering = /obj/item/organ/heart
	rite_chant_lines = list(
		"WAGA!",
		"BABA!",
		"BOBO!",
	)
*/
/datum/runeritual/god/ascension/chant(mob/living/user, obj/structure/ritualcircle/circle)
	var/datum/objective/heretic/objective = user.mind.heretic_path.current_objective
	if(!objective.rite_chant_lines)
		return ..()
	for(var/line in objective.rite_chant_lines)
		if(!do_after(user, chant_delay, target = circle))
			return FALSE
		user.say(line)
	return TRUE

/datum/runeritual/god/ascension/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/datum/objective/heretic/objective = user.mind.heretic_path.current_objective
	if(objective.rite_offering)
		objective.take_offering(user, selected_atoms["C"], loc)
		objective.completed = TRUE
	return user.mind.heretic_path.try_advance(user, locate(/obj/structure/ritualcircle) in loc)

/datum/runeritual/god/ascension/zizo
	chant_lines = list(
		"#ZIZO...",
		"#Gaze upon what I have wrought...",
		"#... and show me more.",
	)

/datum/runeritual/god/ascension/graggar
	chant_lines = list(
		"#GRAGGAR...",
		"#Smell the blood upon my hands...",
		"#... and give me more to spill.",
	)

/datum/runeritual/god/ascension/matthios
	chant_lines = list(
		"#Matthios...",
		"#I have paid what was owed...",
		"#... and name your price again.",
	)

/datum/runeritual/god/ascension/baotha
	chant_lines = list(
		"#Baotha...",
		"#Taste the sweetness I have spread...",
		"#... and pour me another.",
	)
