/datum/objective/heretic/graggar/culling/assassin_hunt
	name = "MARKED FOR DEATH"
	heretic_tier = 4
	heretic_branch = HERETIC_PATH_ASSASSIN
	var/summoning = FALSE
	var/marked = FALSE
	var/datum/charflaw/targeted/mark

/datum/objective/heretic/graggar/culling/assassin_hunt/update_explanation_text()
	explanation_text = "GRAGGAR has marked me for HIS assassins as a test of my abilities. Hunt one of them down and eat its heart before they steal my soul."

/datum/objective/heretic/graggar/culling/assassin_hunt/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HERETIC_HEART_EATEN, PROC_REF(on_heart_eaten))

/datum/objective/heretic/graggar/culling/assassin_hunt/Destroy()
	end_hunt()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HERETIC_HEART_EATEN)
	return ..()

/datum/objective/heretic/graggar/culling/assassin_hunt/seek_contender()
	seek_timer = null
	if(completed || summoning || QDELETED(owner?.current))
		return
	INVOKE_ASYNC(src, PROC_REF(summon_assassins))

/datum/objective/heretic/graggar/culling/assassin_hunt/proc/summon_assassins()
	var/mob/living/carbon/human/prey = owner?.current
	var/list/assassins = list()
	for(var/mob/living/carbon/human/candidate in GLOB.player_list)
		if(candidate.stat != DEAD && candidate.client && candidate.mind?.has_antag_datum(/datum/antagonist/assassin))
			assassins += candidate
	if(marked && length(assassins))
		seek_timer = addtimer(CALLBACK(src, PROC_REF(seek_contender)), 3 MINUTES, TIMER_STOPPABLE)
		return
	if(!length(assassins))
		summoning = TRUE
		var/list/candidates = pollGhostCandidates("Do you want to play as an assassin of GRAGGAR, sent to hunt [prey.real_name]?", ROLE_ASSASSIN, null, null, 20 SECONDS)
		summoning = FALSE
		if(QDELETED(src) || completed || QDELETED(prey))
			return
		if(LAZYLEN(candidates))
			var/mob/living/carbon/human/assassin = spawn_hunter(pick(candidates), "Assassin", CTAG_ASSASSIN)
			if(assassin)
				assassins += assassin
	seek_timer = addtimer(CALLBACK(src, PROC_REF(seek_contender)), 3 MINUTES, TIMER_STOPPABLE)
	if(!length(assassins))
		if(!warned_no_contender)
			warned_no_contender = TRUE
			to_chat(prey, span_cult("<i>No assassin answers GRAGGAR's call. HE will find me other prey.</i>"))
		return
	if(!marked)
		marked = TRUE
		if(!prey.has_flaw(/datum/charflaw/targeted))
			mark = new
			prey.charflaws += mark
		RegisterSignal(prey, COMSIG_HERETIC_PECULATED, PROC_REF(on_peculated))
		if(!prey.mind?.has_spell(/obj/effect/proc_holder/spell/self/graggar_scent/assassin))
			prey.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/graggar_scent/assassin)
		if(!prey.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/extract_heart))
			prey.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/extract_heart)
		to_chat(prey, span_userdanger("GRAGGAR HAS MARKED ME FOR DEATH!"))
		to_chat(prey, span_red("HIS assassins now know my name. I must slay one of them and eat its heart before they steal my soul."))
		prey.playsound_local(prey, 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE)

	for(var/mob/living/assassin as anything in assassins)
		to_chat(assassin, span_userdanger("GRAGGAR HAS MARKED [uppertext(prey.real_name)] FOR DEATH!"))
		to_chat(assassin, span_red("[span_notice(prey.real_name)] seeks to prove themselves to GRAGGAR. PECULATE them, and HE will reward me. They are somewhere in [span_notice(prey.prepare_deathsight_message())]."))
		assassin.playsound_local(assassin, 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE)

/datum/objective/heretic/graggar/culling/assassin_hunt/proc/on_heart_eaten(datum/source, obj/item/organ/heart/heart)
	SIGNAL_HANDLER
	var/obj/item/organ/heart/engorged/assassin_heart = heart
	if(completed || !istype(assassin_heart) || !assassin_heart.assassin_heart)
		return
	end_hunt()
	owner.current.playsound_local(owner.current, 'sound/magic/marked.ogg', 100)
	complete()

/datum/objective/heretic/graggar/culling/assassin_hunt/proc/on_peculated(datum/source, mob/living/assassin)
	SIGNAL_HANDLER
	var/mob/living/heretic = owner.current
	end_hunt()
	if(istype(assassin))
		assassin.change_stat(STATKEY_STR, 1)
		assassin.change_stat(STATKEY_PER, 1)
		assassin.change_stat(STATKEY_INT, 1)
		assassin.change_stat(STATKEY_CON, 1)
		assassin.change_stat(STATKEY_WIL, 1)
		assassin.change_stat(STATKEY_SPD, 1)
		assassin.change_stat(STATKEY_LCK, 1)
		assassin.playsound_local(assassin, 'sound/magic/marked.ogg', 100)
		to_chat(assassin, span_cultlarge("GRAGGAR is pleased with this offering. HIS strength flows through me."))
	to_chat(heretic, span_boldred("I have FAILED GRAGGAR. The weak are nothing to HIM."))
	if(heretic.mind)
		INVOKE_ASYNC(heretic.mind, TYPE_PROC_REF(/datum/mind, lose_heretic_awakening))

/datum/objective/heretic/graggar/culling/assassin_hunt/proc/end_hunt()
	var/mob/living/carbon/human/prey = owner?.current
	if(prey)
		UnregisterSignal(prey, COMSIG_HERETIC_PECULATED)
		prey.mind?.RemoveSpell(/obj/effect/proc_holder/spell/self/graggar_scent/assassin)
		prey.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/extract_heart)
		if(mark)
			prey.charflaws -= mark
	QDEL_NULL(mark)

/datum/objective/heretic/graggar/culling/assassin_hunt/progress_text()
	if(marked)
		return "GRAGGAR's assassins know my name!"
	return "GRAGGAR has yet to find me a worthy hunter."

/obj/effect/proc_holder/spell/self/graggar_scent/assassin
	name = "Scent of the Assassin"
	desc = "GRAGGAR lets me smell the nearest of HIS assassins."

/obj/effect/proc_holder/spell/self/graggar_scent/assassin/cast(list/targets, mob/user)
	var/mob/living/nearest
	for(var/mob/living/carbon/human/candidate in GLOB.player_list)
		if(candidate.stat == DEAD || !candidate.mind?.has_antag_datum(/datum/antagonist/assassin))
			continue
		if(!nearest || get_dist(user, candidate) < get_dist(user, nearest))
			nearest = candidate
	tracked = nearest ? WEAKREF(nearest) : null
	return ..()
