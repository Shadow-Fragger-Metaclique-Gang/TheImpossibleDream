/datum/hex/battle_mage
	name = "\improper Hex of the Battle Mage"
	var/current_arcane_skill
	var/current_arcyne_skill
	var/current_unarmed_skill
	var/ismage = FALSE

/datum/hex/battle_mage/on_apply(mob/living/carbon/human/sufferer = victim)
	if(sufferer.get_skill_level(/datum/skill/combat/arcyne) >= 1 || sufferer.get_skill_level(/datum/skill/magic/arcane) >= 1)
		ismage = TRUE
		to_chat(sufferer, span_cult("I feel my knowledge of the arcana slip from my mind and be replaced by something much more... brutish."))
		current_arcane_skill = sufferer.get_skill_level(/datum/skill/magic/arcane)
		current_arcyne_skill = sufferer.get_skill_level(/datum/skill/combat/arcyne)
		current_unarmed_skill = sufferer.get_skill_level(/datum/skill/combat/unarmed)
		var/granted_unarmed_skill = min(max(current_arcane_skill, current_arcyne_skill), 4) // you are not about to go grind mageloop just to learn unarmed past expert. sorry.
		sufferer.adjust_skillrank_down_to(/datum/skill/magic/arcane, SKILL_LEVEL_NONE, FALSE)
		sufferer.adjust_skillrank_down_to(/datum/skill/combat/arcyne, SKILL_LEVEL_NONE, FALSE)
		sufferer.adjust_skillrank_up_to(/datum/skill/combat/unarmed, granted_unarmed_skill, FALSE) // do note how this doesn't change your stats. you may have "good" unarmed you're still a mage with mage stats.
		ADD_TRAIT(sufferer, TRAIT_SPELLCOCKBLOCK, REF(src)) // FIGHT. AND. WIN.
	return

/datum/hex/battle_mage/on_remove(mob/living/carbon/human/sufferer = victim)
	if(!ismage)
		return
	to_chat(sufferer, span_cult("Years of arcane knowledge flood my mind once again!"))
	sufferer.adjust_skillrank_up_to(/datum/skill/magic/arcane, current_arcane_skill, FALSE)
	sufferer.adjust_skillrank_up_to(/datum/skill/combat/arcyne, current_arcyne_skill, FALSE)
	sufferer.adjust_skillrank_down_to(/datum/skill/combat/unarmed, current_unarmed_skill, FALSE)
	REMOVE_TRAIT(sufferer, TRAIT_SPELLCOCKBLOCK, REF(src))
	ismage = FALSE
