// Helper for generating damage description text based on thresholds, used by the condition summary on cursed collar UI.
/mob/living/carbon/proc/get_damage_descriptor_text(damage_amount, minor_text, moderate_text, severe_text)
	if(!damage_amount)
		return null
	if(damage_amount < 25)
		return minor_text
	if(damage_amount < 50)
		return moderate_text
	return severe_text

/mob/living/carbon/proc/get_damage_condition_summary()
	var/list/conditions = list()

	var/brute_condition = get_damage_descriptor_text(getBruteLoss(), "some bruises", "a lot of bruises", "black and blue")
	if(brute_condition)
		conditions += brute_condition

	var/fire_condition = get_damage_descriptor_text(getFireLoss(), "some burns", "many burns", "dragon food")
	if(fire_condition)
		conditions += fire_condition

	if(!length(conditions))
		return "No obvious bruises or burns"

	return capitalize(jointext(conditions, "; "))
