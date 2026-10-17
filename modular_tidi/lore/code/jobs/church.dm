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

/datum/advclass/herald
	name = "Herald of the Abyss"
	tutorial = "One of Abyssor's acolytes dedicated to the path of the dream painter. You are amongst the most studious of the cult, capable of casting the most powerful miracles. Detail your visions, bring great tidings... Perfom the grunt work to prepare the greatest rituals."

/datum/advclass/voice
	name = "Voice of the Seas"
	tutorial = "One of Abyssor's visionaries dedicated to the path of the dream painter. You are amongst the exhalted of the cult, leading this little branch of abyssorite misfits. Keep in mind your authority does not reach past the cult - and many would fear you for your draw towards the Dreamer. Perhaps you can recruit some of the loyal abyssorites around here."

/datum/advclass/templar/maris
	name = "Maris"
	tutorial = "One of Abyssor's sentinels dedicated to the path of the dream painter. You are amongst the protectors of the cult, keeping your fellow cultists safe from dreamfiends."

