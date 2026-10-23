/datum/hunting_category/spiders/New()
	. = ..()
	animals = animals.Copy()
	animals[/mob/living/simple_animal/hostile/retaliate/rogue/drider] = 5
	preferred_tracks = preferred_tracks.Copy()
	preferred_tracks[/mob/living/simple_animal/hostile/retaliate/rogue/drider] = "small"
