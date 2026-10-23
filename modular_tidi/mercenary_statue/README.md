# Mercenary statue

**Tag:** `MERCENARY_STATUE`

**Created In:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/71

**Major changes:**

Automatic roster registration for the Mercenary statue.

- `code/statue_registration.dm`:
    - Registers Mercenaries after their class is chosen, and Wretches after their subclass is chosen.
    - Gives Wretches a category-based nom de guerre and a colored chat notice instead of their real name.
    - Removes Mercenaries and Wretches from the roster when they far-travel.
    - Hitting the statue with a silver coin (ziliqua, 5 mammons) consumes one coin and reveals the Wretch roster to everyone for 5 minutes. There is no UI button for it, and messaging stays restricted to Bathhouse staff.
    - Adds a discreet mention of the silver slot to the statue description.
- `code/statue_preferences.dm`: character-creator pre-sets, saved per character slot.
    - Wretches (Villain tab): nom de guerre (empty keeps the class-based alias) and description.
    - Mercenaries (Descriptors tab): message only.
    - Adventurers (Descriptors tab): opt-in to being auto-posted on joining, and message.
    - Status is not preset; everyone joins as Available and changes it in game.
    - Mercenaries and Wretches cannot opt out of being listed; they only edit how they appear.
    - UI lives in the downstream `Descriptors.tsx` and `Villains.tsx` hooks.

## Required core edits

- `code/modules/jobs/job_types/roguetown/sidefolk/mercenary.dm`: replaces the remote registration prompt with automatic registration.
- `code/game/objects/structures/fartravel.dm`: unregisters departing characters.
- `code/game/objects/structures/roguetown/talkstatue_tgui.dm`: hides Wretch real names.
- `tgui/packages/tgui/interfaces/Talkstatue.tsx`: shows the Wretch tab during a public reveal.
