/datum/runeritual/god/broken_glass
	name = "Rite of Broken Glass"
	desc = "Grants a spell that upon use will instantly teleport the user back to the ritual circle. Your Fortune will be harshly affected until you return."
	flavor = "Sacrifice your vitality for a single-use gaol-escape tool. A draining ritual for cowards and the paranoid that leaves a shard of one's Self anchored to the ritual circle, ready to be rejoined with at a moment's notice."
	tier = SKILL_LEVEL_APPRENTICE
	cooldown = 1 HOURS
	awakened_heretic_only = TRUE
	layout = list("C" = /obj/item/handmirror)
	chant_lines = list(
		"#Anathema, I beseech your strength!",
		"#Shatter this manifestation of Self...",
		"... as you have the glass pane of Reality!",
	)

/datum/runeritual/god/broken_glass/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/obj/structure/ritualcircle/circle = locate() in loc
	if(!circle || !user.mind)
		return FALSE
	var/datum/action/cooldown/spell/broken_glass/old_glass = user.mind.get_spell(/datum/action/cooldown/spell/broken_glass)
	if(old_glass)
		old_glass.shatter()
	var/datum/action/cooldown/spell/broken_glass/glass = new
	user.mind.AddSpell(glass)
	glass.set_circle(circle)
	user.apply_status_effect(/datum/status_effect/debuff/broken_glass)
	to_chat(user, span_cultsmall("<i>A shard of my Self lingers upon this rune. At any point, I can cast the Broken Glass spell to return to it.</i>"))
	return TRUE

/datum/action/cooldown/spell/broken_glass
	name = "Broken Glass"
	desc = "Rejoin with my shattered Self, instantly returning to where I performed the Rite of Broken Glass."
	button_icon = 'icons/roguetown/items/crafting.dmi'
	button_icon_state = "shard1"
	sound = null
	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	primary_resource_type = SPELL_COST_NONE
	secondary_resource_type = SPELL_COST_NONE
	spell_requirements = SPELL_REQUIRES_HUMAN
	check_flags = AB_CHECK_CONSCIOUS
	var/obj/structure/ritualcircle/circle
	var/teleport_delay = 5

/datum/action/cooldown/spell/broken_glass/Destroy()
	if(circle)
		UnregisterSignal(circle, COMSIG_QDELETING)
		circle = null
	var/mob/living/user = owner
	if(istype(user))
		user.remove_status_effect(/datum/status_effect/debuff/broken_glass)
	return ..()

/datum/action/cooldown/spell/broken_glass/proc/set_circle(obj/structure/ritualcircle/new_circle)
	if(circle)
		UnregisterSignal(circle, COMSIG_QDELETING)
	circle = new_circle
	RegisterSignal(circle, COMSIG_QDELETING, PROC_REF(on_circle_deleted))

/datum/action/cooldown/spell/broken_glass/proc/on_circle_deleted(datum/source)
	SIGNAL_HANDLER
	to_chat(owner,span_warning("<i>I feel a chill as my Shard is forcefully rejoined. The rune that held it has been erased.</i>"))
	owner.playsound_local(owner, 'sound/foley/glass_step.ogg', 30, FALSE)
	shatter()

/datum/action/cooldown/spell/broken_glass/proc/shatter()
	var/mob/living/user = owner
	if(istype(user))
		user.remove_status_effect(/datum/status_effect/debuff/broken_glass)
	if(user?.mind)
		user.mind.RemoveSpell(src)
	else
		qdel(src)

/datum/action/cooldown/spell/broken_glass/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/turf/dest = get_turf(circle)
	if(!dest)
		return FALSE
	if(alert(H, "Return?", "Broken Glass", "Yes", "No") != "Yes")
		return FALSE
	if(QDELETED(src) || QDELETED(circle))
		return FALSE
	H.visible_message(span_warning("Cracks spiderweb through the air around [H]!"))
	playsound(get_turf(H), 'sound/magic/shadowstep.ogg', 50, TRUE)
	addtimer(CALLBACK(src, PROC_REF(step_through), H), teleport_delay)
	return TRUE

/datum/action/cooldown/spell/broken_glass/proc/step_through(mob/living/carbon/human/user)
	if(QDELETED(user) || user.stat == DEAD || QDELETED(circle))
		return
	var/turf/dest = get_turf(circle)
	var/turf/start = get_turf(user)
	var/obj/effect/after_image/img = new(start, 0, 0, 0, 0, 0.5 SECONDS, 2 SECONDS, 0)
	img.name = user.name
	img.appearance = user.appearance
	img.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	img.alpha = 80
	QDEL_IN(img, 2 SECONDS)
	user.buckled?.unbuckle_mob(user, TRUE)
	user.pulledby?.stop_pulling()
	do_teleport(user, dest, channel = TELEPORT_CHANNEL_MAGIC)
	user.set_blood_corruption(100)
	user.visible_message(
		span_warning("[user] steps out of a shattering pane of nothing!"),
		span_notice("Reality splinters, and I'm sent tunneling back to rejoin with my shattered Self."))
	playsound(dest, 'modular_tidi/heretics/sound/blood_portal.ogg', 50, TRUE)
	shatter()

/datum/status_effect/debuff/broken_glass
	id = "broken_glass"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/broken_glass
	effectedstats = list(STATKEY_LCK = -2)

/atom/movable/screen/alert/status_effect/debuff/broken_glass
	name = "Broken Glass"
	desc = "A piece of me is missing. I won't be whole until I rejoin with it."
	icon_state = "debuff"
