/datum/dominant_faith_tracker
	reign_messages = list(
		/datum/faith/divine = list(
			/datum/faith/divine = "$patron shines bright in your Lux! The Pantheon are in their rightful place.",
			/datum/faith/inhumen = "The firmament feels thick. The Pantheon's influence wanes; the Inhumen rise.",
			/datum/faith/old_god = "The world is quiet. A soft wind blows. The divines rest, for now.",
		),
		/datum/faith/inhumen = list(
			/datum/faith/inhumen = "$patron outshines the mendacity of the Pentacle! Mortalkind ascend!",
			/datum/faith/divine = "The firmanent feels thick. The Pentacle's influence is overpowering!",
			/datum/faith/old_god = "The world is quiet. A soft wind blows. The divines rest, for now.",
		),
		/datum/faith/old_god = list( // psydonites can only tell whether they're dominant or not, here
			/datum/faith/divine = "The world is quiet. The wind has an ominous twinge.",
			/datum/faith/inhumen = "The world is quiet. The wind has an ominous twinge.",
			/datum/faith/old_god = "The world is quiet. The wind is calm and reassuring.",
		)
	)
