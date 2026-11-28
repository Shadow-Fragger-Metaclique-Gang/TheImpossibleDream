# Modular keybinds

**Tag:** `MODULAR_KEYBINDS`

**Created in:** _PR link to be added once opened_

**Major changes:**

## Modular keybinds

- Concerns keybinds, which are modular. In this first case, it is just a hold to sprint button, but I will add more after review, or people are welcome to do the same.
- Additionally, tweaks some annoyances and deals with my personal skill issue.

## Files

- `_keybinds_modular.dme`: local includes.
- `code/keybinds.dm`: contains all core code. .

## Core files changed

- `code\game\objects\structures.dm`: Makes charging into your scenery damage your chest instead of head.
- `code\game\turfs\closed\_closed.dm`: Ditto
- `code\modules\mob\living\living.dm`: Makes you no longer able to charge into things from a standstill.
