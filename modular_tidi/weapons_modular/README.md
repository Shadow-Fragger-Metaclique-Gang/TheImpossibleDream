# WEAPONS_MODULAR

For any changes concerning generic weaponry and their intents.

**Tag:** `WEAPONS`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/76

**Major changes:**

## Unarmed Weapons

Reverts https://github.com/Azure-Peak/Azure-Peak/pull/9387

## Layout

- `_weapons_modular.dme`: the module's .dme.
- `code/unarmed_weapons.dm`: new or overwritten unarmed weapons

## Core files changed

- `code\modules\mob\inventory.dm`: Removes the check preventing usage of shields with unarmed weapons.
- `code\modules\clothing\rogueclothes\gloves\unique.dm`: Removes the forced WEAPONLESS trait on wearing any form of knuckledusters.
