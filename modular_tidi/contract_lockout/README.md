# Contract lockout

**Tag:** `CONTRACT_LOCKOUT`

**Created in:** https://github.com/Shadow-Fragger-Metaclique-Gang/TheImpossibleDream/pull/102

**Major changes:**

## Contract lockout

Makes it so you can only take the maximum amount of contracts once every hour, encouraging teams to be formed so more lucrative contracts can be taken.

## Files

- `_contract_lockout.dme`: no code files, since the change is a single core define.

## Core files changed

- `code/__DEFINES/economy/questing.dm`: `QUEST_TAKE_COOLDOWN` changed from `10 MINUTES` to `1 HOURS`. The original line is commented out.
