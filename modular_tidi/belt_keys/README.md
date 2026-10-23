# Belt Keys

**Tag:** `BELT_KEYS`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/62

**Major changes:**

## Belt Keys

Ported from Ratwood. Right-clicking a door locks or unlocks it with a matching key or keyring in your hand, on your belt, or inside something on your belt. Donjon and stone door viewports move to middle-click.

## Files

- `_belt_keys.dme`: local includes.
- `code/belt_keys.dm`: door `attack_right`, the belt key lookup procs, the `trykeylock` override, and the donjon/stone `attack_right` and `MiddleClick`.

## Core files changed

- `code/game/objects/structures/mineral_doors.dm`: removes AP's `attack_right` on `/obj/structure/mineral_door`, `/obj/structure/mineral_door/wood/donjon/stone` and `/obj/structure/mineral_door/wood/donjon` (moved to this module).
