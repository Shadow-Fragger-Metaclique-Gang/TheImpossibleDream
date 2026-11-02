# Werewolf Tweaks

**Tag:** `WW_TWEAKS`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/83

**Major changes:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/83

This tweaks the behavior of werewolves and the infection rate.

## Werewolf Tweaks

## Layout

- `_ww_tweaks.dme`: local includes.
- `code/ww_tweaks.dm`: Contains an var override for the `werewolf_infection_probability` used by all wounds, and an proc override on `death()` that removes the `/datum/antagonist/werewolf` mind datum on death.

## Core files changed

- `code/game/objects/items/rogueweapons/mmb/bite.dm`: Adjusts the infection ratio % depending on if artery bite and if bitten by lesser werewolf or alpha werewolf.
