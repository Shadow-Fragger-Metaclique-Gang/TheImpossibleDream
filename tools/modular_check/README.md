# Modularization checker

A python CI mini-application that handles modularization bookkeeping to make contribution less tedious.

## TL;DR for contributors

When you finish coding and before you PR your branch/fork, run the following from the repo root:

```text
tools/modularize.bat --tag YOUR_TAG      (Windows, or double-click and it uses the only module you touched)
tools/modularize.sh --tag YOUR_TAG       (Linux / macOS / Git Bash)
```

Review the result and commit it. `--tag` can be left out if your branch only touches one `modular_tidi/` module. You can also use the terminal -> run task -> modularization options in VSC.

This tool compares a branch (including uncommitted changes) against `upstream/main`, `origin/main` or `main`, whichever exists first (can also be overridden by `--base <ref>`).

## Modularization Script

- Wraps every core-code change (any `.dm` outside `modular_tidi/`) in markers:
    - added lines get `// [SURREALIS-ADD] - TAG` ... `// [/SURREALIS-ADD]`
    - removed lines are put back inside `/* */` in a `SURREALIS-REMOVE` block
    - changed lines get a `SURREALIS-EDIT` block, and the originals are commented out
    - edits inside multi-line `{" "}` strings or `\`-continued `#define`s are wrapped
- Lists every changed core file in the module README under `## Core files changed`.
- Creates the module's `README.md` if it doesn't exist yet, and its `_<module>.dme` plus the include in `modular_tidi/global_modules.dm` once the module has `.dm` files.
- Adds new module `.dm` files to the module's `.dme`, and turns `modular_tidi\...` include paths into local ones.
- Offers to move new `.dm` files added outside `modular_tidi/` into `modular_tidi/<module>/code/` for you. It asks (`[y]es / [n]o / [a]ll / [q]uit`) for each file (unless you select one of the latter two options), then removes the file's line from `roguetown.dme`, and includes it from the module's `.dme` instead. `--move-new-files` is equivalent to yes to all; `--no-input` is equivalent to quit and is used by the CI checker. Files that are moved will compile after all core code, so it will warn you if the file has `#define`s that might need to be defined elsewhere.

## Build

`tools/build/build.bat` (or `build.sh`, or the VS Code tasks):

- `build.bat --modular`: normal build, with the check before DM compiles.
- `build.bat modular-check`: just checks and reports results.
- `build.bat modular-fix --tag=NOCS_BULB`: applies the comments for you. You can add `--move-new-files` to skip the questions.

## CI

- `.github/workflows/modularization.yml` runs `check` on every PR as the "Modularization" job of the BYOND Build suite (`ci_suite.yml`). Upon failure the run summary lists the problems and the run uploads a `modularize-patch` patch, prefixed by the `**Module tag:**` from the PR description. Can be included via `git apply`.
- `.github/workflows/modularization_title.yml` adds or corrects the `[SEMI-MODULAR]` / `[NON-MODULAR]` title prefix.
- Upstream merges are skipped: label the PR `Upstream Merge`, or put `[UPSTREAM]` or `[PARITY]` in the title.
