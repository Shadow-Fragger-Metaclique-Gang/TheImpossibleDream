/datum/action/cooldown/spell/touch/orison
	desc = "The fundamental teachings of theology return to you:\n \
	<b>Light</b>: Issue a prayer for illumination, causing you or another living creature to begin glowing with light for five minutes - this stacks each time you cast it, with no upper limit. Using thaumaturgy on a person will remove this blessing from them, and MMB on your praying hand will remove any light blessings from yourself.\n \
	<b>Fill</b>: Beseech your Divine to create a small quantity of water in a container that you touch for some devotion. Pestrans create foul-tasting medicine. Baothans create sweet, soothing wine. \n \
	<b>Voice</b>: Direct a sliver of divine thaumaturgy into your being, causing your voice to become LOUD when you next speak. Known to sometimes scare the rats inside the SCOMlines. Can be used on light sources at range, and it will cause them flicker.\n \
	<b>Bless</b>: Utter a prayer for redemption to your Divine to bring a repentant soul into their flock. The close bonds of the Divine uniquely allow an initiate to choose whichever they feel closest to. THIS IS ONLY TO BE USED AFTER A CONVERSION IN ROLEPLAY. DO NOT USE THIS WITHOUT A ROLEPLAY BASIS OR THERE WILL BE DIRE CONSEQUENCES."

/datum/controller/global_vars/Initialize(mapload)
	. = ..()
	convert_incantations[/datum/patron/divine/undivided] = "Gods above, bring this wayward soul into thy embrace!!"
	convert_incantations[/datum/patron/inhumen/zizo] = "O, Demiurge! Show this one the truth of the world!"
