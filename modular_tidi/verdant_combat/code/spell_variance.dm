/proc/roll_spell_damage_variance(damage, variance_range, int_stat, skill_level)
	if(!variance_range)
		return damage
	var/variance_center = clamp((int_stat - 10) * 0.0125 + skill_level * 0.025, -1, 1)
	var/variance_roll = 0
	for(var/i in 1 to 3)
		variance_roll += rand(-variance_range, variance_range)
	variance_roll = clamp(variance_roll / 3 + variance_center * variance_range, -variance_range, variance_range)
	return round(damage * (1 + variance_roll / 100), 1)

/proc/spell_damage_bounds(damage, variance_range, int_stat, skill_level)
	if(!variance_range)
		return list(damage, damage)
	var/variance_center = clamp((int_stat - 10) * 0.0125 + skill_level * 0.025, -1, 1)
	var/low_roll = clamp(-variance_range + variance_center * variance_range, -variance_range, variance_range)
	var/high_roll = clamp(variance_range + variance_center * variance_range, -variance_range, variance_range)
	return list(round(damage * (1 + low_roll / 100), 1), round(damage * (1 + high_roll / 100), 1))

/datum/action/cooldown/spell/proc/get_damage_bounds(damage, mob/living/caster)
	if(!damage_variance || !ishuman(caster))
		return list(damage, damage)
	return spell_damage_bounds(damage, damage_variance, caster.STAINT, caster.get_skill_level(associated_skill))

GLOBAL_LIST_INIT(spell_element_names, list(
	"fire" = span_charred("Fire"),
	"frost" = span_frostbite("Frost"),
	"electrical" = span_electrical("Lightning"),
	"acid" = span_acid("Acid"),
	"magic" = "Arcyne",
))

GLOBAL_LIST_INIT(spell_physical_damage_names, list(
	"blunt" = "blunt",
	"slash" = "cutting",
	"stab" = "stabbing",
	"piercing" = "piercing",
))

/proc/spell_element_line(armor_flag)
	if(GLOB.spell_element_names[armor_flag])
		return span_info("Element: [GLOB.spell_element_names[armor_flag]]")
	if(GLOB.spell_physical_damage_names[armor_flag])
		return span_info("Element: <b>Physical</b> ([GLOB.spell_physical_damage_names[armor_flag]])")
	return null

/proc/caster_varied_spell_damage(damage, variance_range, mob/living/caster, skill_type = /datum/skill/magic/arcane)
	if(!variance_range || !ishuman(caster))
		return damage
	return roll_spell_damage_variance(damage, variance_range, caster.STAINT, caster.get_skill_level(skill_type))

/datum/action/cooldown/spell/proc/get_varied_damage(damage, mob/living/caster, variance_range = damage_variance)
	return caster_varied_spell_damage(damage, variance_range, caster, associated_skill)
