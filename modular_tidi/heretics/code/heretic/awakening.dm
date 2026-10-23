/datum/job
	var/heretic_awakening_chance = 0

/datum/advclass
	var/heretic_awakening_chance

/datum/job/roguetown/villager
	heretic_awakening_chance = 100

/datum/job/roguetown/lunatic
	heretic_awakening_chance = 100

/datum/job/roguetown/vagabond
	heretic_awakening_chance = 100

/datum/job/roguetown/apothecary
	heretic_awakening_chance = 50

/datum/job/roguetown/guildsman
	heretic_awakening_chance = 50

/datum/job/roguetown/physician
	heretic_awakening_chance = 50

/datum/job/roguetown/innkeeper
	heretic_awakening_chance = 50

/datum/job/roguetown/adventurer
	heretic_awakening_chance = 50

/datum/job/roguetown/cook
	heretic_awakening_chance = 50

/datum/job/roguetown/farmer
	heretic_awakening_chance = 50

/datum/job/roguetown/tapster
	heretic_awakening_chance = 50

/datum/job/roguetown/bathworker
	heretic_awakening_chance = 50

/datum/job/roguetown/trader
	heretic_awakening_chance = 50

/datum/job/roguetown/shophand
	heretic_awakening_chance = 50

/datum/job/roguetown/councillor
	heretic_awakening_chance = 50

/datum/job/roguetown/manorguard
	heretic_awakening_chance = 40

/datum/job/roguetown/archivist
	heretic_awakening_chance = 30

/datum/job/roguetown/servant
	heretic_awakening_chance = 30

/datum/job/roguetown/wapprentice
	heretic_awakening_chance = 30

/datum/job/roguetown/seneschal
	heretic_awakening_chance = 20

/datum/job/roguetown/suitor
	heretic_awakening_chance = 20

/datum/job/roguetown/veteran
	heretic_awakening_chance = 20

/datum/job/roguetown/sergeant
	heretic_awakening_chance = 20

/datum/job/roguetown/watchman
	heretic_awakening_chance = 20

/datum/job/roguetown/lord
	heretic_awakening_chance = 10

/datum/job/roguetown/lady
	heretic_awakening_chance = 10

/datum/job/roguetown/prince
	heretic_awakening_chance = 10

/datum/job/roguetown/marshal
	heretic_awakening_chance = 10

/datum/job/roguetown/magician
	heretic_awakening_chance = 10

/datum/job/roguetown/merchant
	heretic_awakening_chance = 10

/datum/job/roguetown/tailor
	heretic_awakening_chance = 10

/datum/job/roguetown/bathmaster
	heretic_awakening_chance = 10

/datum/job/roguetown/adventurer/courtagent
	heretic_awakening_chance = 10

GLOBAL_LIST_EMPTY(heretic_awakening_rolls) // You can only roll once per round
GLOBAL_LIST_EMPTY(heretic_awakened_players)

/datum/job/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()
	if(H.mind && M?.ckey)
		H.mind.schedule_heretic_awakening(M.ckey)

/datum/mind/proc/schedule_heretic_awakening(player)
	if(heretic_path || heretic_awaken_timer || !can_heretic_awaken())
		return
	if(player in GLOB.heretic_awakened_players)
		return
	if(isnull(GLOB.heretic_awakening_rolls[player]))
		GLOB.heretic_awakening_rolls[player] = prob(heretic_awakening_chance())
	if(!GLOB.heretic_awakening_rolls[player])
		return
	// Characters awaken five to thirty minutes after round start
	// You roll your chances on spawn, not after your timer is up
	// Latejoiners after thirty minutes awaken one minute after latejoining
	var/now = SSticker.HasRoundStarted() ? STATION_TIME_PASSED() : 0
	var/delay
	if(now >= HERETIC_AWAKEN_LATEST)
		delay = HERETIC_LATEJOIN_DELAY
	else
		delay = rand(max(HERETIC_AWAKEN_EARLIEST, now + HERETIC_LATEJOIN_DELAY), HERETIC_AWAKEN_LATEST) - now
	heretic_awaken_timer = addtimer(CALLBACK(src, PROC_REF(try_heretic_awakening)), delay, TIMER_STOPPABLE)

/datum/mind/proc/can_heretic_awaken()
	var/mob/living/carbon/human/H = current
	if(!istype(H) || H.stat == DEAD)
		return FALSE
	if(heretic_path || heretic_converted)
		return FALSE
	if(!istype(H.patron, /datum/patron/inhumen))
		return FALSE
	if(NOBLOOD in H.dna?.species?.species_traits)
		return FALSE
	if(istype(active_preset(), /datum/storyteller/gamemode/extended))
		return FALSE
	if(length(antag_datums))
		return FALSE
	if(H.get_skill_level(/datum/skill/magic/ritualist))
		return FALSE
	return TRUE

/datum/mind/proc/heretic_awakening_chance()
	var/datum/job/assigned_job = SSjob.GetJob(assigned_role)
	. = assigned_job ? assigned_job.heretic_awakening_chance : 0
	if(!isnull(picked_advclass?.heretic_awakening_chance))
		. = picked_advclass.heretic_awakening_chance

/datum/mind/proc/try_heretic_awakening()
	heretic_awaken_timer = null
	if(!can_heretic_awaken())
		return
	awaken_heretic()

/datum/mind/proc/awaken_heretic()
	var/mob/living/carbon/human/H = current
	GLOB.heretic_awakened_players |= ckey(key)
	H.playsound_local(H, 'modular_tidi/heretics/sound/heretic_awaken.ogg', 100, FALSE)
	to_chat(H, span_cult(span_reallybig("I am a heretic of [get_god_name(H.patron)].")))
	to_chat(H, span_cult("<i>HERE — where the VEIL is at its weakest, I am able to freely commune with my patron in order to enact their DARK WILL.</i>"))
	to_chat(H, span_cult("<i>By enacting their DARK WILL, I will surely be REWARDED.</i>"))
	to_chat(H, span_notice("With any knife, I may draw a ritual circle of [get_god_name(H.patron)] in blood. From there, my objectives and rewards will be made clear."))
	to_chat(H, span_doyourjobidiot("Being a heretic does not make you immune to the server's rules."))
	to_chat(H, span_notice("My patron asks of me:"))
	heretic_path = new /datum/heretic_path(src, H.patron.type)

/datum/mind/proc/lose_heretic_awakening()
	if(heretic_awaken_timer)
		deltimer(heretic_awaken_timer)
		heretic_awaken_timer = null
	if(!heretic_path)
		return
	QDEL_NULL(heretic_path)
	if(current)
		to_chat(current, span_warning("<i>The voice of my old patron falls silent.</i>"))

/datum/mind/proc/heretic_conversion()
	heretic_converted = TRUE
	lose_heretic_awakening()
	var/mob/living/carbon/human/H = current
	if(istype(H) && H.get_skill_level(/datum/skill/magic/ritualist))
		H.adjust_skillrank(/datum/skill/magic/ritualist, -H.get_skill_level(/datum/skill/magic/ritualist), TRUE)

/mob/living/carbon/human/set_patron(datum/patron/new_patron)
	. = ..()
	if(mind?.heretic_path && !istype(patron, mind.heretic_path.patron_type))
		mind.heretic_conversion()

/mob/living/carbon/human/convert_other(atom/victim)
	var/mob/living/carbon/human/new_convert = victim
	var/old_patron_type = istype(new_convert) ? new_convert.patron?.type : null
	. = ..()
	if(istype(new_convert) && new_convert.mind && new_convert.patron?.type != old_patron_type)
		new_convert.mind.heretic_conversion()

/datum/antagonist/assassin/change_patron(mob/living/user)
	var/old_patron_type = user?.patron?.type
	. = ..()
	if(user?.mind && user.patron?.type != old_patron_type)
		user.mind.heretic_conversion()
