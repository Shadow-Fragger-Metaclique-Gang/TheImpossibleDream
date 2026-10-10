/datum/usurpation_rite
	new_ruler_title = "Count"
	new_ruler_title_f = "Countess"
	new_realm_type = "County"
	new_realm_type_short = "County"

/datum/usurpation_rite/lunar_ascension
	roundend_epilogue = "As in Azuria, as across Naledi, here, before the Scar, " + \
		"an Archmagos rules openly without the assent of Astrata or the pretensions of wealth. " + \
		"They say their rule is enlightened. " + \
		"They say that their learned techniques shall bring forth greater marvels of witch-engineering than ever before: that Pharos will be a herald of learning, modernity, and the era-to-come. " + \
		"It is even claimed, joyously, that their thaumaturgic mastery shall discover even deeper secrets about the Scar and its state." + \
		"Can it be so? Could a Scar be wielded truly, or will they wound too deep - and render a hideous stain upon the realm?" + \
		"Will the rule of mages bring about a new golden age, " + \
		"or will it be a brief, shining moment before the realm burns in impossible flame?"

/datum/usurpation_rite/progressive_dominion
	name = "Rite of Anathematic Dominion"
	desc = "The rule of the ignorant must end. The rule of the weak must end. You, by your hand, will render this Scar - this lighthouse - your own. A minor Ambition, but one so very impactufl."
	explanation = {"<p>A mage of sufficient power, a follower of Zizo, or the undead, may claim the throne through the assent of those who embrace progress.</p>\
<p><b>Who may invoke:</b> Any mage with Apprentice-level Arcyne Training or higher, any follower of Zizo, or any undead.</p>\
<p><b>How it works:</b> Mages trained in the Arcyne arts, followers of Zizo, or those touched by undeath, must gather near the throne and speak the words 'I assent' to support your claim.</p>\
<p><b>Completion condition:</b> <b>5</b> voices must speak their assent. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Restrictions:</b> None. All who bear ambition are welcome — the living, the undead, the outlaw.</p>\
<p><b>Realm type if successful:</b> Dominion, ruled by an Exarch.</p>"}

/datum/usurpation_rite/psydonian_tribunal
	explanation = {"<p>The Inquisition may claim the throne through appeal to other Psydonites - provided they can hold the realm against any opposition.</p>\
<p><b>Who may invoke:</b> Members of the Inquisition (Inquisitor, Absolver, Orthodoxist).</p>\
<p><b>How it works:</b> Followers of Psydon must gather near the throne and speak the words 'I assent' to support your claim.</p>\
<p><b>Completion condition:</b> Only <b>4</b> followers of Psydon may speak their assent. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Restrictions:</b> Only followers of Psydon may invoke or assent. The undead are excluded, but not outlaws.</p>\
<p><b>Realm type if successful:</b> Ordinate, ruled by a Superior.</p>"}
	new_ruler_title = "Superior"
	new_ruler_title_f = "Superior"
	roundend_epilogue = \
		"His Majesty's Holy Inquisition has seized power in the name of His Majesty - be it Psydon, or the King. " + \
		"An oddity repeated rarely, and almost never with stable assent. " + \
		"The Inquisition - fanatics, criminals, assassins, the best and the dregs of His faithful - " + \
		"now rule in His name, over a realm waylaid by the Pentacle, who have long since abandoned Psydon " + \
		"for those Gods that will listen to their prayers. " + \
		"How long can this rule last?" + \
		"\n\n" + \
		"How long will the neighboring fiefdoms tolerate this overextension of royal power? How long will the Pantheonic populace withstand the inevitable? " + \
		"Few have not feared the insurrection of the Psydonian. Few do not fear their pogroms, their inquisition, or their crusades - both peasant or noble. " + \
		"Otava will be pleased, of course. Perhaps they had planned this from the very beginning. " + \
		"\n\n" + \
		"But just as Psydon stirs and endures for His return, " + \
		"so does the Inquisition endure to re-establish His rule upon Psydonia."

/datum/usurpation_rite/sacred_supercession
	desc = "When a king fails to uphold the divine order, the faithful must act. Reluctantly, the temple must claim temporal power, to shepherd the faithful back on an orderly path."
	explanation = {"<p>A member of the Temple of the Pentacle may claim the throne through divine mandate.</p>\
<p><b>Who may invoke:</b> Any member of the Temple who follows one of the divine patrons.</p>\
<p><b>How it works:</b> Members of the Temple of Pharos, or those who have reached the First Tier of Divine devotion, must gather near the throne and speak the words 'I assent' to support your claim. Only followers of the Pantheon may participate.</p>\
<p><b>Completion condition:</b> <b>5</b> weighted voices must speak their assent. Foreign or wandering clergy count as only half a voice. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Restrictions:</b> Only followers of the Pantheon may invoke or assent. Outlaws and the undead are shunned.</p>\
<p><b>Realm type if successful:</b> Prince-Bishopric, ruled by a Prince-Bishop.</p>"}
	roundend_epilogue = "Astrata's sacred order has been restored, but with a twist. " + \
		"For as long as most faithful can remember, realms of Psydonia were ruled by the blue-blooded, " + \
		"those who derive their power from Astrata's divinity, but never wielded Her power directly. " + \
		"Now, the Temple itself has taken the throne. " + \
		"Is this truly Astrata's will? To mix temporal and spiritual power in one ruler? " + \
		"The Sun Goddess is silent, or perhaps she has acquiesced to this new order." + \
		"\n\n" + \
		"To the west, the smoke of a signal fire rises. " + \
		"Through this takeover, the Temple has broken the balance of power that kept in check the uneven balance of a kingdom wrack with schism. - " + \
		"Those of the Pantheon, the faith of the majority, and those of Psydon - the minority, but only just." + \
		"Each tolerated the other - with effort - and kept each other in check. " + \
		"The regent may believe themselves final, and just in their reign, " + \
		"But this usurpation shall come at a cost: in blood, in wealth, in rebellion, inquisition, and protestation. The children of the Progenitus shall not stay silent." + \
		"Strife is inevitable. The Scar shall witness it all."

/datum/usurpation_rite/solar_succession
	explanation = {"<p>A noble may claim the throne through the assent of their peers. An ancient tradition upheld by the order ordained by Astrata.</p>\
<p><b>Who may invoke:</b> Any noble.</p>\
<p><b>How it works:</b> Nobles of the realm must then gather near the throne and speak the words 'I assent' to support your claim.</p>\
<p><b>Completion condition:</b> Members of the noble family (Consort, Prince), Insiders (Hand, Steward, Councillor) and those with Heartfelt ties need only <b>3</b> noble voices — a palace coup. All other nobles require a quorum of <b>5</b> voices. Resident nobles of Pharos count as a full voice; foreign (wanderer) nobles count as only half. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Restrictions:</b> Outlaws and those touched by the stench of undead may not invoke or assent.</p>\
<p><b>Realm type if successful:</b> County, ruled by a Count / Countess.</p>"}
