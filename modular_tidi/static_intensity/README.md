# Static Intensity

**Tag:** `STATIC_INTENSITY`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/80

**Major changes:**

## Static Intensity

Disables the roundstart intensity vote and uses a single fixed gamemode preset, `Static Intensity`, instead.

- No wretches and no bandits.
- Major antagonists (Lich, Vampire Lord, Werewolf, Masquerade, Rebel) are enabled through slot counts. Only one rolls per round, picked at random among those above 0, and each still needs 40 players.
- Gnolls, Hag, Assassin and the Dreamwalker stay available.

It works by setting `allow_vote = FALSE` and `selected_storyteller` on `SSgamemode` and pre-filling `SSgamemode.admin_slots`, the same slot system admins use when they disable the vote. Admins can still change slots or the preset from the Gamemode panel before roundstart. Toggling "Allow Player Vote" back on there clears the slots and restores the vote, as in upstream.

## Editing the intensity

Everything you would want to tune is in `code/static_intensity_config.dm`:

- Each antagonist has a roundstart slot count, and `0` disables it.
- Each major antagonist has a `weight`. When several are enabled, the chance of each is its weight divided by the total weight of the enabled ones. These apply even if admins turn the vote back on.
- Midround events (Wandering Lich, Death Cult Rising for Assassins, Gnoll Migration) have a `max_occurrences`, and Assassins and Gnolls have a slot cap. They never change the roundstart slots.

The Assassin migrant wave and the Gnoll migration use small subtypes in `code/static_intensity.dm`. The Assassin one reads its cap from the config because the upstream event hardcodes 2. The Gnoll one writes the raised slot count back to `SSgamemode.admin_slots["Gnoll"]`, because the Gnoll job resets to that value whenever the latejoin menu opens.

## Layout

- `_static_intensity.dme`: the module's .dme.
- `code/static_intensity_config.dm`: the slot counts and roll weights per antagonist. The only file you should need to edit.
- `code/static_intensity.dm`: the `Static Intensity` preset and the overrides that disable the vote and select it.

## Core files changed

None.

## Changes in other modules

None.
