#define FLAIL_WAVE1 0.7 SECONDS
#define FLAIL_WAVE2 1.4 SECONDS

/datum/special_intent/greatflail_swing
	name = "Greatflail Swing"
	desc = "Swing your greatflail all around you in a ring of Judgement."
	tile_coordinates = list(
		list(0,0), list(1,0), list(1,-1),list(1,-2),list(0,-2),list(-1,-2),list(-1,-1),list(-1,0),\
		list(0,1, FLAIL_WAVE1), list(1,1, FLAIL_WAVE1), list(-1,1, FLAIL_WAVE1),list(1,-3, FLAIL_WAVE1),list(0,-3, FLAIL_WAVE1),list(-1,-3, FLAIL_WAVE1),list(-2,0, FLAIL_WAVE1),list(-2,-1, FLAIL_WAVE1),list(-2,-2, FLAIL_WAVE1),list(2,0, FLAIL_WAVE1),list(2,-1, FLAIL_WAVE1),list(2,-2, FLAIL_WAVE1),\
		list(0,0, FLAIL_WAVE2), list(1,0, FLAIL_WAVE2), list(1,-1, FLAIL_WAVE2),list(1,-2, FLAIL_WAVE2),list(0,-2, FLAIL_WAVE2),list(-1,-2, FLAIL_WAVE2),list(-1,-1, FLAIL_WAVE2),list(-1,0, FLAIL_WAVE2)
		)
	post_icon_state = "sweep_fx"
	pre_icon = 'icons/effects/telegraph.dmi'
	pre_icon_state = "warning"
	sfx_pre_delay = 'sound/combat/flail_sweep.ogg'
	respect_adjacency = FALSE
	respect_dir = TRUE
	delay = 0.7 SECONDS
	cooldown = 30 SECONDS
	stamcost = 25	//Stamina cost
	var/dam = 60
	var/slow_dur = 2
	var/hitcount = 0
	var/self_debuffed = FALSE
	var/self_immob = 2.2 SECONDS
	var/self_clickcd = 2.1 SECONDS
	var/self_vuln = 2.3 SECONDS
	var/list/mob/living/wave_victims = list()
	var/exposed_init = 3 SECONDS
	var/offbalanced_init = 1.5 SECONDS
	var/knockdown = 2 SECONDS
	var/immobilize_init = 1 SECONDS

/datum/special_intent/greatflail_swing/_reset()
	hitcount = initial(hitcount)
	self_debuffed = initial(self_debuffed)
	wave_victims.Cut()
	. = ..()

//It's a bad idea to hook into _process_grid, but this is a ghetto way to check which "wave" we are at.
//As process grid is called for every set of tiles.
/datum/special_intent/greatflail_swing/_process_grid(list/turfs, newdelay)
	if(!self_debuffed)
		howner.Immobilize(self_immob) //we're committing
		howner.apply_status_effect(/datum/status_effect/debuff/vulnerable, self_vuln)
		howner.apply_status_effect(/datum/status_effect/debuff/clickcd, self_clickcd)
		self_debuffed = TRUE
	hitcount++
	. = ..()


/datum/special_intent/greatflail_swing/post_delay(list/turfs)
	wave_victims.Cut()
	. = ..()
	var/list/mob/living/victims = wave_victims.Copy()
	wave_victims.Cut()
	var/victim_count = length(victims)
	var/effect_count = min(victim_count, 9)

	for(var/mob/living/victim as anything in victims)
		apply_sweep_effects(victim, effect_count)

	playsound(howner, 'sound/combat/wooshes/bladed/wooshlarge (3).ogg', 100, TRUE)

/datum/special_intent/greatflail_swing/apply_hit(turf/T)
	for(var/mob/living/victim in get_hearers_in_view(0, T))
		if(victim == howner)
			continue
		victim.Slowdown(slow_dur)
		if(!(victim.mobility_flags & MOBILITY_STAND))
			continue
		wave_victims |= victim
		var/hitdmg = dam
		switch(hitcount)
			if(2)
				hitdmg *= 1.5
			if(3)
				hitdmg *= 2
		apply_generic_weapon_damage(
			victim,
			hitdmg,
			"blunt",
			BODY_ZONE_CHEST,
			bclass = BCLASS_BLUNT,
		)

		if(hitcount == 3)
			apply_generic_weapon_damage(
				victim,
				dam * 0.8,
				"blunt",
				BODY_ZONE_CHEST,
				bclass = BCLASS_BLUNT,
				no_pen = TRUE,
			)
		playsound(T, 'sound/combat/flail_sweep_hit_major.ogg', 100, TRUE)
	..()

/datum/special_intent/greatflail_swing/proc/apply_sweep_effects(
	mob/living/victim,
	effect_count,
	)
	if(QDELETED(victim) || QDELETED(howner) || effect_count <= 0)
		return
	var/newslow = slow_dur + effect_count
	var/newexposed = exposed_init + (effect_count SECONDS)
	var/newoffb = offbalanced_init + (effect_count SECONDS)
	var/newimmob = immobilize_init + (effect_count SECONDS)
	victim.Slowdown(newslow)
	if(effect_count >= 2)
		victim.Immobilize(newimmob)
		victim.apply_status_effect(
			/datum/status_effect/debuff/exposed,
			newexposed,
		)
	if(effect_count >= 3)
		victim.Knockdown(knockdown)
	if(effect_count >= 5)
		victim.OffBalance(newoffb)
		victim.Stun(5 SECONDS)
	var/turf/throwtarget = get_edge_target_turf(
		howner,
		get_dir(howner, get_step_away(victim, howner)),
	)
	if(throwtarget)
		victim.safe_throw_at(
			throwtarget,
			CLAMP(effect_count, 1, 5),
			1,
			howner,
			force = MOVE_FORCE_EXTREMELY_STRONG,
		)

#undef FLAIL_WAVE1
#undef FLAIL_WAVE2
