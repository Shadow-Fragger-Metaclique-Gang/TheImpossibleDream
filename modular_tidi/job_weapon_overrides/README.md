# Job and weapon overrides

**Tag:** `JOB_WEAPON_OVERRIDES`

**Created In:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/40

**Major changes:**

## Ducal standards

Ports [Ratwood PR #3017](https://github.com/Rotwood-Vale/Ratwood-2.0/pull/3017) (Yuckuza)

- `code/ducal_standard.dm`: pike intents, a poleaxe with three grip movesets,
  weapon special selection, strapless, and two-tone ducal scheme banner colors.
- `code/standard_bearer.dm`: removes the greatweapon strap, assigns the standard
  choices
- `icons/ducal_standards.dmi`: upstream standard sprites

## Shared weapon overrides

Shared weapon changes from [Ratwood PR #2589](https://github.com/Rotwood-Vale/Ratwood-2.0/pull/2589) (Yuckuza):

- `code/flail_overrides.dm`: fireproof iron and hefty greatflails, hefty greatflail damage intents, and its weapon special assignment.
- `code/greatflail_special.dm`: the shared greatflail swing special.
- `code/weapon_disarm.dm`: shared sword disarming behavior.

Drow-specific jobs, equipment, driders, and assets live in [`DROW_MERCS`](../drow_mercs/README.md), which uses these shared weapon changes.
