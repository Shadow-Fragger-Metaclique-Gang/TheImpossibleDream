/datum/job/roguetown/monk
	tutorial = "Chores, some more chores- Even more chores.. Oh how the life of a humble acolyte is exhausting… You have faith, but even you know you gave up a life of adventure for that of the security in the Temple. Assist the Pontifex in their daily tasks, maybe today will be the day something interesting happens."

/datum/advclass/acolyte
	tutorial = "Chores, some more chores- Even more chores.. Oh how the life of a humble acolyte is exhausting… You have faith, but even you know you gave up a life of adventure for that of the security in the Temple. Assist the Pontifex in their daily tasks, maybe today will be the day something interesting happens."
	subclass_stashed_items = list(
		"The Verses and Acts of the Pantheon" = /obj/item/book/rogue/bibble,
	)

/datum/job/roguetown/keeper
	tutorial = "Disfigured, shunned, or simply filled with purpose and dedication for Pestra. Some of you are horrifically mutated, disfigured, or diseased. No matter, even the pretty ones feel the toll as it leaves their strength atrophied. Someone has to harvest the holy blood required to purify lux and perpetuate Pestra's gift of medicine. Unfortunately, that's you. That's correct, I'm the one tasked with protecting the sacred Heart Beast of Pestra here. To study it and empower it so that Pestra's medicine may blossom even in the furthest reaches of this Scarland. Keep in mind you are NOT directly affiliated with the fivefold Temple, under most any circumstance. You answer to the sect of Pestra foremost."

/datum/advclass/keeper
	tutorial = "Disfigured, shunned, or simply filled with purpose and dedication for Pestra. Some of you are horrifically mutated, disfigured, or diseased. No matter, even the pretty ones feel the toll as it leaves their strength atrophied. Someone has to harvest the holy blood required to purify lux and perpetuate Pestra's gift of medicine. Unfortunately, that's you. That's correct, I'm the one tasked with protecting the sacred Heart Beast of Pestra here. To study it and empower it so that Pestra's medicine may blossom even in the furthest reaches of this Scarland. Keep in mind you are NOT directly affiliated with the fivefold Temple, under most any circumstance. You answer to the followers of Pestra foremost."

/datum/job/roguetown/martyr
	tutorial = "Martyrs are hand-picked among the most devout of the Temple's chosen. They are given one of the Star's cherished relics to protect the Temple, and to inspire hope and lead by example of grace, kindness and vicious intolerance to any who do not carry the weight of the Wheel. They have sworn an Oath in the sight of the gods, and will fulfill it to the bitter end."

/datum/advclass/martyr
	tutorial = "Martyrs are hand-picked among the most devout of the Temple's chosen. They are given one of the Star's cherished relics to protect the Temple, and to inspire hope and lead by example of grace, kindness and vicious intolerance to any who do not carry the weight of the Wheel. They have sworn an Oath in the sight of the gods, and will fulfill it to the bitter end."
	subclass_stashed_items = list(
		"The Verses and Acts of the Pantheon" = /obj/item/book/rogue/bibble,
	)

/datum/job/roguetown/priest
	display_title = "Pontifex"
	tutorial = "The Divine is all that matters in a world of the immoral. The Shattered God abandoned us, and in his stead the PENTACLE rules over us mortals--and you will preach their wisdom to any who still heed their will. The faithless are growing in number. It is up to you to shepherd them toward a Gods-fearing future, o bridge-builder."

/datum/advclass/bishop
	tutorial = "The Divine is all that matters in a world of the immoral. \
	The Shattered God abandoned us, and in his stead the PENTACLE rules over us mortals--and you will preach their wisdom to any who still heed their will. The faithless are growing in number. \
	It is up to you to shepherd them toward a Gods-fearing future, o bridge-builder."
	subclass_stashed_items = list(
		"The Verses and Acts of the Pantheon" = /obj/item/book/rogue/bibble,
	)

/datum/job/roguetown/sexton
	display_title = "Initiate"
	tutorial = "You are an apprentice helping hand for the Temple. Freshly converted or oathsworn to the Pentacle, your rightful place - Solar-defined - is below that of all others within. Serve with dignity and grace, and perhaps you may earn your superior's grace."

/datum/advclass/sexton/groundskeeper
	tutorial = "You are the groundskeeper for the temple, and are responsible for all the little odd-jobs that keep it running. \
	Your duties range from cleaning the floors and pews to managing the stores and conducting base business for the Gods."

/datum/job/roguetown/templar
	tutorial = "Templars are warriors who have forsaken wealth and title in lieu of service to the Great Gods, due to either zealotry or a past shame. They guard the temple and its inhabitants while keeping a watchful eye against heresy and nite-creechers. Within troubled dreams, they wonder if the blood they shed makes them holy or stained."

/datum/advclass/templar/crusader
	tutorial = "You are a templar of the Gods, trained in heavy weaponry and zealous warfare. You are the instrument of your God's wrath, clad in steel and faith."
	subclass_stashed_items = list(
		"The Verses and Acts of the Pantheon" = /obj/item/book/rogue/bibble,
	)

/obj/structure/roguemachine/vaultbank/church/get_authority_label()
	return "the Pontifex or Martyr"

/datum/advclass/druid
	name = "Maenad"
	tutorial = "Shape-changer, fanatic, long has your body been declared to the Lord of Madness. Your frenzied ways will not bow to the careful culturing of society, and your chants grow more than just trees and flowers. Loose your wyld ways upon the land, and chase your desires!"

/datum/advclass/herald
	name = "Hiereis"
	tutorial = "Though housed by no temple and sworn to no holy books, you are as any priest- dedicated to your God. The Dreamer slumbers beneath the waves, and you uphold the balance of life on land, blessing fisherfolk and sailors and healing the drowned."

/datum/advclass/voice
	name = "Oracle"
	tutorial = "Diviner of the Deep, Seer of the Unseen, the tides sing to you. Create your Dream in the image of His, and with your brush remake the path of the sea and sand."

/datum/advclass/templar/maris
	name = "Hetaeroi"
	tutorial = "Armored by faith and anointed in salted brine, you have been chosen to fight the Tidefather’s battles on land and protect the vulnerable hiereis. Like the washing of the waves, you are determined to wear away the evyls of this world."

