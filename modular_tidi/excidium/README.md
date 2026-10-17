# EXCIDIUM

**Tag:** `EXCIDIUM`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/56

**Major changes:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/56

- Only members of the faction that posted the bounty can now see it in the excidium, bounties posted in-round are seen by everyone.
- Removes printing magical bounty lists.
- Disabled TRAIT_JUSTICARSIGHT and excommunicated/outlaw logic on examine.

## Excidium

## Layout

- `excidium\code\consult_bounties.dm` - overrides the `/obj/structure/roguemachine/bounty/consult_bounties()` proc
- `excidium\code\defines.dm` - adds defines for internal module logic
- `excidium\code\get_excidium_faction.dm` - provides logic for matching bounty's poster and the user's faction

## Core files changed

- `code\modules\mob\living\carbon\human\examine.dm` commented out TRAIT_JUSTICARSIGHT and excommunicated/outlaw logic on examine
- `code\modules\roguetown\roguemachine\bounty.dm` commented out print_bounty_scrolls() of excidium
-
