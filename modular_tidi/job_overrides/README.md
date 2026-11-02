# Job overrides

**Tag:** `JOB_OVERRIDES`

**Created In:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/71

**Related PRs:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/112

**Major changes:**

Files are split by job category.

- `code/retinue.dm`: Knights get 2 slots and Squires 3 (no `GUARDSMAN` trait); Squires gain Expert in their chosen weapon.
- `code/garrison.dm`: no `GUARDSMAN` trait on Sergeants and Men-at-Arms, who have their worn gambeson, iron maille and gorget swapped in `post_equip` for a padded gambeson, steel haubergeon and steel gorget, and receive a steel mask (worn if the face is free, otherwise carried). The original Warden is disabled.
- `code/inquisition.dm`: Orthodoxists (Practicus) get 4 slots.
- `code/inquisition_rooms.dm`: Otavan Embassy bedroom IV and V keys (`OEB4`, `OEB5`), added to the Inquisition room key vendor.
- `code/church.dm`: Templars get 2 slots. Hiereis and Hetaeroi are removed from the Acolyte and Templar subclass lists (they are Abyssor-only, now Korybantes).
- `code/burghers.dm`: a Malum Guildmaster gets T4 miracles, Ritualist, Expert holy skill, a ritual chalk and a Malum psicross on their wrist.
- `code/courtier.dm`: every Jester gets Xylix's T4 miracles and Expert holy skill whatever their patron. A Xylix Jester also gets Ritualist, a ritual chalk a Xylix cross on the wrist.
- `code/sidefolk.dm`: Mercenaries get 7 slots. Lirvan Tithebound is disabled.
- `code/peasants.dm`: Shophand becomes Docker with 2 slots. Docker no longer offers its own class; it picks from its own copies of the Goon, Wise Guy and Big Fella classes, with separate slot counts from the Towner versions. Goon and Big Fella Dockers get Appraiser and Wise Guy Dockers get Skilled Appraiser. Goon, Wise Guy and Big Fella stat changes: Goon and Wise Guy get 4 slots. Goon gains Journeyman in the three "Whatever I Can Find" weapon skills. Wise Guy gains Journeyman knives and Expert slings when a sling is chosen.
- `code/pilgrim.dm`: the Levy gets 8 slots and spawns with the watchtower key. Witches cannot take Pestra.
- `code/adventurer.dm`: Lamplighters become Adventurer subclasses with 2 slots each. Adventurer Cleric subclasses are Pentacle-only with 2 slots each, except the Cantor, which also accepts Xylix.
- `code/veteran.dm`: Adds options for Veteran Mercenary to be from places other than Grenzelhoft.

## Required core edits

- `code/__DEFINES/jobs.dm`: the Primal Divines department flag, color and display order, the Merchant's Mercenary display order, and department colors for Primal Divines and Merchantry.
- `code/controllers/subsystem/job.dm`: maps the new departments to their latejoin group names.
- `code/controllers/subsystem/lobby.dm`: the roundstart ready screen shows a job's display title.
- `code/modules/mob/dead/new_player/new_player.dm`: latejoin menu groups for the new departments.
- `code/modules/roguetown/roguemachine/titan.dm`: stops un-outlawing from granting `TRAIT_GUARDSMAN`.
- `tgui/packages/tgui/interfaces/PreferencesMenu/` and `tgui/packages/tgui/styles/interfaces/PreferencesMenu.scss`: class-selection menu categories and layout.
