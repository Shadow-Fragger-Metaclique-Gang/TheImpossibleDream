# Werewolf Sexcon

**Tag:** `WW_SEXCON`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/134

**Major changes:**

Gives the people what they fucking deserve: hot werewolf sex.

## Werewolf Sexcon

## Layout

- `_ww_sexcon.dme`: local includes.
- `code/ww_sexcons.dm`: Appliies a local override in the werewolf icon generation as well as shims in the genital code.

## Core files changed

-`code\modules\antagonists\roguetown\villain\werewolf\werewolf_transformation.dm`: Shims in adding the werewolf genitals. I couldn't think of a more modular way to do this without somehow reacquiring the owner.

- `code\modules\mob\living\carbon\human\species_types\roguetown\other\gnoll.dm`: See above.
- `code/game/objects/items/rogueitems/keyrings.dm`: ADD near `/obj/item/storage/keyring/Initialize`
- `code/modules/jobs/job_types/roguetown/adventurer/types/antag/gnoll/gnoll_berserker.dm`: EDIT near `/datum/outfit/job/roguetown/gnoll/berserker/pre_equip`
- `code/modules/jobs/job_types/roguetown/adventurer/types/antag/gnoll/gnoll_impure.dm`: EDIT near `/datum/outfit/job/roguetown/gnoll_impure/pre_equip`
- `code/modules/jobs/job_types/roguetown/adventurer/types/antag/gnoll/gnoll_knight.dm`: EDIT near `/datum/outfit/job/roguetown/gnoll/knight/pre_equip`
- `code/modules/jobs/job_types/roguetown/adventurer/types/antag/gnoll/gnoll_shaman.dm`: EDIT near `/datum/outfit/job/roguetown/gnoll/shaman/pre_equip`
- `code/modules/jobs/job_types/roguetown/adventurer/types/antag/gnoll/gnoll_templar.dm`: EDIT near `/datum/outfit/job/roguetown/gnoll/templar/pre_equip`
- `code/modules/mob/status_procs.dm`: ADD near `/mob/proc/update_eye_blur`
- `icons/roguetown/misc/machines.dmi`: changed
