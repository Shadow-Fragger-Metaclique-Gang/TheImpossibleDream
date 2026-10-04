/mob/living/carbon/human/after_creation(mob/dead/new_player/new_player)
	. = ..()
	pay_for_the_big_one(client || new_player?.client)
