# Inquisition SCOM

**Tag:** `INQUISITION_SCOM`

**Created in:** _PR link to be added once opened_

**Major changes:**

## Inquisition SCOMline

A private SCOM network for the Inquisition, parallel to the Garrison line.

- **Inquisistone** (`/obj/item/scomstone/inquisition`): receive-only. It never hears the general SCOMline: its `repeat_message` is a no-op, which also covers `scom_announce`, decrees and every other public loop. It only receives through `repeat_inquisition_message`.
- **Puritanstone** (`/obj/item/scomstone/inquisition/puritan`): can also transmit with right-click, but only to the Inquisition line, with the usual cooldown. It cannot reach the general line.
- Both are direct subtypes of `scomstone`, so the garrison loops (which iterate `/garrison` types) can never reach them.
- Wearing either stone in the ring slot grants `TRAIT_INQUISITION_ITEM`, exactly as the garrison stones grant `TRAIT_GARRISON_ITEM`. A stone has to be on a mob to receive messages, like the other stones.
- Middle-clicking any SCOM with that trait toggles `inquisitionline`. It is mutually exclusive with `garrisonline`: a garrison member middle-clicking an inquisition-line SCOM takes it over for the garrison line.
- Messages on the line are coloured `INQUISITION_SCOM_COLOR` (`#4A7BFF`). An inquisition-line SCOM uses the `scomm4` / `rcomm4` icon state.

## Spawning

`post_equip` overrides on the advclasses give a stone, placed in the first worn storage item with room (back, belt, belt pouches, cloak), then a free hand, then the floor:

- Inquisistone: Absolver, Penitent One, and the five Orthodoxist classes (Templar, Disciple, Sojourner, Confessor, Psyaltrist).
- Puritanstone: Inquisitor (Inspector and Ordinator).

## Files

- `_inquisition_scom.dme`: local includes.
- `code/defines.dm`: `TRAIT_INQUISITION_ITEM` and `INQUISITION_SCOM_COLOR`.
- `code/inquisition_stones.dm`: the two stone types.
- `code/scomm_inquisition_line.dm`: the SCOM var, the toggle and relay procs, and `broadcast_inquisition_line`.
- `code/spawn_stones.dm`: the stone-giving helper and the advclass `post_equip` overrides.

## Core files changed

- `code/modules/roguetown/roguemachine/scomm/scomm.dm`: hooks in `get_mechanics_examine`, `MiddleClick` (`toggle_inquisition_line`), `update_icon` (`scomm4` / `rcomm4`) and `Hear` (`relay_inquisition_line`). The core code only calls procs.
