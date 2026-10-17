// Copy of and mutually exclusive with transact that listens for sacrificing certain things or things worth a certain amount of value
// Hook for some of Matthios's objectives
/datum/action/cooldown/spell/matthios/transact
	exclusive_group = "transact"

/datum/action/cooldown/spell/matthios/transact/churn_value
	name = "Churn Value"
	desc = "Sacrifice an item in your hand, applying a heal over time to yourself with strength depending on its value. The Free-God takes note of what I churn."

/datum/action/cooldown/spell/matthios/transact/churn_value/cast(atom/cast_on)
	var/obj/item/held_item = owner.get_active_held_item()
	var/value = held_item?.get_real_price()
	if(held_item && (value < 10 || !isliving(cast_on)))
		var/datum/objective/heretic/matthios/churn/churn_objective = owner.mind?.heretic_path?.current_objective
		if(istype(churn_objective) && !churn_objective.completed && churn_objective.is_worthy(held_item, value))
			playsound(owner, 'sound/combat/hits/burn (2).ogg', 100, TRUE)
			to_chat(owner, "<font color='yellow'>[held_item] is engulfed in unholy flame and dissipates into ash. My transaction is accepted.</font>")
			SEND_SIGNAL(owner, COMSIG_HERETIC_VALUE_CHURNED, held_item, value)
			qdel(held_item)
			return TRUE
	. = ..()
	if(. && held_item)
		SEND_SIGNAL(owner, COMSIG_HERETIC_VALUE_CHURNED, held_item, value)

/mob/living/carbon/human/proc/grant_churn_value()
	if(!mind || mind.has_spell(/datum/action/cooldown/spell/matthios/transact/churn_value))
		return
	mind.RemoveSpell(/datum/action/cooldown/spell/matthios/transact)
	mind.AddSpell(new /datum/action/cooldown/spell/matthios/transact/churn_value, src)
	to_chat(src, span_cult("<i>My patron grants me CHURN VALUE. The Free-God will see what I give up.</i>"))
