/datum/objective/heretic/graggar/culling/gnoll_hunt
	name = "BEESTS FOR GRAGGAR"
	heretic_tier = 4
	heretic_branch = HERETIC_PATH_MARAUDER
	var/summoning = FALSE

/datum/objective/heretic/graggar/culling/gnoll_hunt/update_explanation_text()
	explanation_text = "A gnoll of GRAGGAR has been sent to hunt me as a test of my might. Hunt it down and eat its heart before it eats mine."

/datum/objective/heretic/graggar/culling/gnoll_hunt/seek_contender()
	seek_timer = null
	var/mob/living/carbon/human/first_chosen = owner?.current
	if(completed || duel || summoning || QDELETED(first_chosen))
		return
	if(!first_chosen.getorganslot(ORGAN_SLOT_HEART))
		seek_timer = addtimer(CALLBACK(src, PROC_REF(seek_contender)), 3 MINUTES, TIMER_STOPPABLE)
		return
	summoning = TRUE
	INVOKE_ASYNC(src, PROC_REF(summon_gnoll))

/datum/objective/heretic/graggar/culling/gnoll_hunt/proc/summon_gnoll()
	var/mob/living/carbon/human/first_chosen = owner?.current
	var/mob/living/carbon/human/second_chosen
	var/list/contenders = list()
	for(var/mob/living/carbon/human/candidate in GLOB.player_list)
		if(candidate.stat == DEAD || !candidate.client || !candidate.mind?.has_antag_datum(/datum/antagonist/gnoll))
			continue
		if(!candidate.getorganslot(ORGAN_SLOT_HEART) || heretic_culling_duel_of(candidate) || heretic_culling_area_blacklist(candidate))
			continue
		contenders += candidate
	if(length(contenders))
		second_chosen = pick(contenders)
	else
		var/list/candidates = pollGhostCandidates("Do you want to play as a gnoll of GRAGGAR, sent to hunt [first_chosen.real_name]?", ROLE_GNOLL, null, null, 20 SECONDS)
		summoning = FALSE
		if(QDELETED(src) || completed || QDELETED(first_chosen))
			return
		if(LAZYLEN(candidates))
			second_chosen = spawn_hunter(pick(candidates), "Gnoll", CTAG_GNOLL)
	summoning = FALSE
	if(!second_chosen)
		if(!warned_no_contender)
			warned_no_contender = TRUE
			to_chat(first_chosen, span_cult("<i>No gnoll answers GRAGGAR's call. HE will find me other prey.</i>"))
		seek_timer = addtimer(CALLBACK(src, PROC_REF(seek_contender)), 3 MINUTES, TIMER_STOPPABLE)
		return
	var/datum/culling_duel/heretic/new_duel = new(first_chosen, second_chosen)
	GLOB.graggar_cullings += new_duel
	join_culling(new_duel)
	new_duel.begin()

/datum/objective/heretic/graggar/culling/gnoll_hunt/progress_text()
	if(!duel)
		return "GRAGGAR has yet to find me a worthy hunter."
	return ..()
