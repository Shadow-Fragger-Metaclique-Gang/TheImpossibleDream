# Deadite Tweaks

**Tag:** `DEADITE_TWEAKS`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/91

**Major changes:**

Gives deadites some stat changes through a status effect so it hopefully shouldn't be abusable like other past implementations have done.
Summoned deadites including skeletons get a UI indicator to show who their master is.
Regular deadites are too stupid to feint. Greater deadites from heretic rituals can be feinted, because they use swords.

## Layout

- `_deadite_tweaks.dme`: the .dme.
- `_deadite_tweaks_defines.dm`: `TRAIT_TOO_STUPID_TO_FEINT`.
- `code/deadite_tweaks.dm`: proc overrides on `transform_zombie()` and `on_removal()` that add and remove the trait and the `deadite_stats`, and `/datum/rmb_intent/feint/special_attack()` that fails the feint against anyone with the trait.
- `code/master_hud.dm`: the `summoned_by` ref on `/mob/living`, the procs that show and hide the master hud to the minion, and overrides on `Login()`, `Logout()`, `death()` and `revive()` to keep it in sync.

## Core files changed

- `code/modules/spells/spell_types/undead/summon/raise_undead.dm`: Fortified Skeletons record their summoner.
- `code/game/objects/items/rogueitems/necro_relics.dm`: Greater Skeletons from the necromancer crystal record their summoner.
