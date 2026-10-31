# Throw refactor

**Tag:** `THROWING_REFACTOR`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/98

**Major changes:**

This is a near total rewrite of how thrown objects path in flight, in addition to adjusting their gliding behavior.

## Layout

- README.md - This file, containing the documentation.

## Core files changed

- `\code\controllers\subsystem\throwing.dm` - Handles new behavior for in flight pathing.
- `\code\game\atoms_movable.dm` - Majorly just the rework to how diagonal movements get split.
- `\code\game\objects\items\rogueweapons\mmb\jump.dm` - Adds a callback to make this less laggy, consequently removing endlag on landing because I'm not incompetent.
- `\code\modules\pixel_shift\pixel_shifting.dm` - slightly relevant bugfix
