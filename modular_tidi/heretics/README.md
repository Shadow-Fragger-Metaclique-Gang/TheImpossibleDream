# HERETICS

**Tag:** `HERETICS`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/60

**Major changes:**

## Heretics

Does way too much. Basically, adds awakened heretics as a brand new antagonist. You do rituals to progress your powers, kind of like heretics from TG code. Also includes a lot of stuff I'm way too lazy to list here. Go and look at the layout.

## Layout

- `_heretics.dme`: the module's .dme.
- `_heretics_defines.dm`: the module's defines.
- `code/rites/_god_rite.dm`: the new datum for god rites with the minecraft crafting table recipes, the ritual circle menu, and overrides for disabling the rites expended debuffs since we're moving to ritual costs instead of cooldowns, typically.
- `code/rites/pantheon/god/`: the pantheon's circles.
- `code/rites/inhumen/god/`: the Inhumen circles. `zizo/raise_deadite.dm` is a new rite. `zizo/avantyne_weapons.dm` is for new avantyne weapons summonable with the reworked arming rites. `zizo/flesh_monolith.dm` is for one of the heretic objectives.
- `code/rites/patron_knives.dm`: rites that reforge a knife into a heretic knife.
- `code/rites/ascension.dm`: the Rite of Ascension, which progresses heretic objectives.
- `code/heretic/heretic_path.dm`: an awakened heretic's tier, current objective and tier rewards.
- `code/heretic/corruption.dm`: blood corruption which is raised by doing evil crap and is used for identifying heretics by the inquisition.
- `code/heretic/engorged_heart.dm`: engorged hearts, which are an objective hook used by Graggar heretic objectives. You can eat them as any Graggar heretic for a stat buff.
- `code/heretic/lux.dm`: Baotha worshippers can take bites out of lux. For an objective hook and also for fun.
- `code/heretic/awakening.dm`: who awakens and when they do.
- `code/heretic/objective_hooks.dm`: signals that more than one objective uses. Other objective hooks used by only one objective usually live in the objective's file.
- `code/heretic/churn_value.dm`: copy of the Matthios transact miracle but with objective hooks, given to heretics to use.
- `code/heretic/apostasy.dm`: speaking the names of the evil gods makes everyone pissed off and gives them influence. Objective hooks.
- `code/heretic/objectives/graggar/T3_culling_games.dm`: disables AP's culling games event to replace it with our own, which is used as an objective hook for several Graggar heretic events.
- `code/heretic/objectives/`: heretic objectives, one file for each god, named by tier `T1_` to `T5_`. `_heretic_objective.dm` holds the base and `T0_the_calling.dm` the tier zero calling objective.
- `code/heretic/admin.dm`: a Heretic section at the bottom of the traitor panel to awaken, force, advance, reroll or remove heretics. Debug crap.
- `code/heretic/progression.dm`: knives carving ritual circles in blood if you're a heretic ritualist.
- `code/inquisition/indexer.dm`: the reworked indexer, which quietly draws blood a la Lifeweb inquisition and fills reusable blood vials for testing. Indexers are no longer attached to writs. Blood vials replace the old indexer's functionality for the most part.
- `code/inquisition/assayer.dm`: the hematic assayer, used for testing extracted blood vials for blood corruption.
- `code/carriageman.dm`: the carriageman's toll refreshes rite cooldowns instead of getting rid of the rites expended debuff.
- `code/runes.dm`: the list of god runes.
- `code/chalk.dm`: ritual chalk offers every rune to everyone.
- `code/ritualism/ritualism_skill.dm`: the Ritualism skill.
- `code/ritualism/ritualist_grants.dm`: everything that granted the ritualist trait grants Expert Ritualism instead.

## Core files changed

- `code/datums/mind.dm`: the Notes panel lists a heretic's current objective under Objectives.
- `tgui/packages/tgui/styles/main.scss`: loads the heretic theme and the ritual menu's styles.

New TGUI files:

- `tgui/packages/tgui/interfaces/SurrealisRitualMenu.tsx`: the ritual menu.
- `tgui/packages/tgui/styles/interfaces/SurrealisRitualMenu.scss`: the heretic path chart.
- `tgui/packages/tgui/styles/themes/surrealis_heretic.scss`: the evil heretic theme for tgui.

## Changes in other modules

- SEXCON: `code/overrides/ritual_circles.dm` is gone, womb tattoo ritual now lives in `code/rites/inhumen/baotha/fertility_boon.dm`.
