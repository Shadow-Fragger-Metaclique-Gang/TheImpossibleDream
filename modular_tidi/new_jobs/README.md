# New jobs

**Tag:** `NEW_JOBS`

**Created In:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/71

**Major changes:**

Roles that do not exist in the core job definitions.

- `code/job_positions.dm`: the job-list changes applied at `SSjob` initialisation: Druid, Painter, Warden and Lamplighter are removed from their old lists, and the Merchant's Mercenary and Dungeoneer are added to the Merchant and Inquisition lists so they show on the latejoin menu.
- `code/primal_divines.dm`: the Primal Divines department and its latejoin grouping.
    - Warden of the Wilds: Dendor-only, 2 slots, with its own loadout (no houndstone or Garrison keyring), T2 miracles, and a Dendor scythe or bodkin quiver by weapon path.
    - Korybantes: Abyssor's Hiereis and Hetaeroi paths, 3 slots with the Seer. The Maenad, Korybantes and Seer all gain the Azure Native trait.
    - Druid is displayed as Maenad and Painter as Seer (Oracle subclass), and both move to this department.
- `code/landmarks.dm`: roundstart spawn landmarks for the Warden of the Wilds, Korybantes, Merchant Mercenary and Dungeoneer.
- `code/abyssor_cult_lock.dm`: the `abyssor_cult` key.
- `code/inquisition_dungeoneer.dm`: the Dungeoneer (placeholder name), a single-class Inquisition job. Stats weigh 7 (STR and SPD count double) with a speed penalty, and the class is forced to medium armor (replacing the Adjudicator's heavy armor trait). Otherwise it shares the Adjudicator's gear, skills, languages, T2 miracles, arrival slip, music and helmet/oath choices, but is forced to take a silver shortsword.
- `code/merchant_hireling.dm`: the Merchant's Mercenary, with the Mercenary's traits, stats and classes, a Merchant key, and no statue registration.

## Required core edits

- `code/modules/mob/dead/new_player/new_player.dm`: Primal Divines latejoin group
- `code/__DEFINES/jobs.dm`: the `KORYBANTES` job flag.
