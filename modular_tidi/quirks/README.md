# QUIRKS

**Tag:** `QUIRKS`

**Created in:**

**Major changes:**

## Quirk Points

Replaces AP's quirks system with RW's. Instead of needing vices or statpacks to get quirks, you get points by taking vices which can be spent on quirks. If you don't have enough points, you can buy quirks with triumphs instead.

## Layout

- `_quirks_defines.dm`: the quirk traits `PREFERENCE_CHARFLAW_DENIAL_QUIRK`, and the `span_pretty` spans.
- `_quirks.dme`: the module's .dme.
- `code/quirk.dm`: the quirk datum's variables and handlers.
- `code/quirk_points.dm`: Q-Points, saving and loading, spawn application and the round end payout.
- `code/quirk_list.dm`: every quirk.
- `code/quirk_hooks.dm`: trait descriptions, examine, and recipe overrides.
- `code/quirk_ui.dm`: the preference menu data and actions.
- `code/malodorous.dm`: the Malodorous quirk and all its stuff.
- `code/overrides.dm`: hidden vices, job restrictions, and statpack text.
- `icons/malodorous.dmi`: the stink cloud.

## Proc changes

- `apply_prefs_quirk()` is replaced by `surrealis_apply_prefs_quirks()`, and `apply_quirk()` by `surrealis_apply_quirk()`.
- `/datum/preferences/_load_quirk()` and `save_character()` load and save the new quirk list.
- `declare_completion()` pays out unspent quirk points.
- `ui_data_popup_quirk()`, `ui_act_popup_quirk()` and the identity data procs feed the new quirk menu; `ui_data_popup_virtue()` and `ui_act_popup_virtue_select()` block virtues that conflict with a quirk.
- `cannot_take_flaw()` hides the Hunted and Targeted vices and blocks vices that conflict with a quirk.

## Core files changed

Removed:

- `code/datums/quirk/lesser.dm`: removes Nihilist and Otherworldly.
- `code/datums/character_flaw/_character_flaw.dm`: removes the triumph gains from Leper, Asundered Mind and Wanted.

Hooks:

- `code/_globalvars/special_traits.dm`: spawn calls `surrealis_apply_prefs_quirks()`.
- `code/controllers/subsystem/job.dm`: quirks no longer block job selection.
- `code/modules/mob/dead/new_player/new_player.dm`: quirks no longer block joining.
- `code/modules/mob/living/carbon/human/examine.dm`: quirk examine lines, and gnolls can see who is Marked by Gnolls.
- `code/modules/mob/living/carbon/human/human_topic.dm`: Gossiper can read noble gossip.
- `code/game/objects/structures/mirror.dm`: Unsettling mirror stress.
- `code/modules/antagonists/roguetown/villain/gnoll/gnoll_spells.dm`: checks Marked by Gnolls instead of the Hunted vice.
- `code/modules/antagonists/roguetown/villain/minor_antags/assassin/assassin_gear.dm`: checks Marked for Death instead of the Targeted vice.
- `code/modules/antagonists/roguetown/villain/minor_antags/assassin/assassin_spells.dm`: checks Marked for Death instead of the Targeted vice.
- `code/modules/events/antagonist/solo/assassins.dm`: checks the Marked traits instead of the vices.
- `code/modules/antagonists/roguetown/villain/bandit.dm`: strips the Marked traits.
- `code/modules/antagonists/roguetown/villain/dark_itinerant.dm`: strips the Marked traits.
- `code/modules/antagonists/roguetown/villain/dreamwalker.dm`: strips the Marked traits.
- `roguetown.dme`: ticks `_quirks_defines.dm`.

New TGUI files:

- `tgui/packages/tgui/interfaces/PreferencesMenu/popups/SurrealisQuirk.tsx`: the quirk menu.
- `tgui/packages/tgui/interfaces/PreferencesMenu/popups/SurrealisCharflaw.tsx`: the vice menu with Q-Points visible.
- `tgui/packages/tgui/interfaces/PreferencesMenu/tabs/CharacterCreator/subtabs/SurrealisIdentityCards.tsx`: the Quirks and Vices cards.

## Changes in other modules

- SEXCON: `sexcon.dm` and `sexcon_knotting.dm` Malodorous spreading mechanics.
