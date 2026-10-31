# GREENTEXT

**Tag:** `GREENTEXT`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/106

**Major changes:**

## Greentext

The framework for showing antagonist objectives and how they went on the round-end screen. The first user is awakened heretics.

- Awakened heretics no longer forget completed objectives. Their memory lists every objective they have finished, followed by the current one.
- Objectives record who they were done to (victims), shown in memories and on the round-end screen.
- At round end a separate Villains window opens next to the Chronicle, listing every villain, their objectives and whether they were completed.
- Awakened heretics are also listed under the Chronicle's Villains tab.

To record a victim from an objective, call `record_victim(mob)` before `complete()`. It can be called more than once for objectives that need several targets.

## Layout

- `_greentext.dme`: the module's .dme.
- `code/greentext_record.dm`: `/datum/objective/greentext_record`, the permanent snapshot of a completed objective.
- `code/heretic_hooks.dm`: victim tracking on heretic objectives, and the heretic path's list of completed objectives.
- `code/roundend.dm`: the HTML for the villains list and the round-end window.

## Core files changed

- `code/datums/mind.dm`: the Notes panel lists all of a heretic's completed objectives instead of only the current one.
- `code/modules/client/round_end_panel.dm`: the Villains tab lists awakened heretics.
- `code/__HELPERS/roundend.dm`: opens the villains window at round end.

## Changes in other modules

- HERETICS: `code/heretic/objectives/_heretic_objective.dm` snapshots the objective when it completes. `code/heretic/heretic_path.dm` snapshots it on advancing as well, since rite-offering objectives are completed without calling `complete()`. Objectives with identifiable targets call `record_victim()`.
