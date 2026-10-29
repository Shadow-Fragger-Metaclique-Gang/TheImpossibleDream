# ADDITIONAL_SKINTONES

**Tag:** `ADDITIONAL_SKINTONES`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/99

**Major changes:**

## Combat Music

This holds SRLS-specific skintonesc.

## Layout

- `_additional_skintones.dme`: the module's .dme.
- `code/additional_skintones.dm`: holds SRLS-specific skintones.

## Core files changed

- 'code\modules\mob\living\carbon\human\species_types\roguetown\elf\elfs.dm' had to add a variable due to a byond bug https://www.byond.com/forum/post/2992317 , otherwise it would create a new subtype of the race.
