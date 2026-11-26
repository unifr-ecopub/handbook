# Work on a project with Python steps

`master.do` runs Python steps alongside Stata and R steps. This page covers setting up Python with `uv`, running on Windows, managing packages, and checking lock changes.

**Untested on Windows.** Nobody has yet run a Python step through `master.do` on a Windows machine.

| Task | Who |
|---|---|
| Install `uv` | You (or IT) |
| Fetch Python and restore the packages | Claude |
| Start a run on Windows | You, in Stata's window |
| Try a step in an editor | You |

## Add the first Python step

Claude sets up Python in your project with `uv`, using `.python-version`, `pyproject.toml` and `uv.lock`.

**Ask Claude.** In the project:

```prompt
I want to write my first Python step.
```

**Claude will ask you.** Claude checks whether `uv` is on your machine, then asks whether the network is on. `uv` downloads Python and the packages into `.venv/`, which takes a few minutes. If `uv` is missing, Claude asks whether you will install it and gives you the command for your system. You do not need to install Python yourself: `uv` fetches the version that `.python-version` names.

With your yes, Claude copies `.python-version`, `pyproject.toml` and `uv.lock` from `code/templates/py-project/` into the project folder and runs `uv sync --frozen`. Claude then adds any further packages that the step imports, writes the step, and runs it through `master.do`.

**Only you do.** If `uv` is missing, run the install command Claude gives you in your own terminal, or ask IT to install it. If Claude still cannot find `uv` afterwards, close Claude Code and open it again.

**Check.** The step ends `Step complete`. Ask Claude to commit `.python-version`, `pyproject.toml` and `uv.lock` with the step (git ignores `.venv/`).

## Run the project on Windows

On Windows, Claude cannot start any run in a project with Python steps. This covers full runs, single steps and explore files.

**Only you do.**

1. Double-click `code/master.do` in Explorer.
2. Click **Do** in Stata's do-file editor.
3. Tell Claude what Stata showed.

For a single step, Claude tells you what to type in Stata's window. Claude still restores the Python packages itself.

## Try a step on its own in an editor

You can run a Python step directly in your editor to inspect code.

**Only you do.** Choose the project's `.venv` Python as the interpreter in your editor (`.venv/bin/python`, or `.venv/Scripts/python.exe` on Windows) and run the step there. Running a step outside `master.do` overwrites its exhibits, so take results from a full run of `master.do` only.

## When master.do says Python is not ready

Every run that names a `.py` file checks `.python-version`, `uv.lock` and `.venv/` before running any step; [Python steps](../reference/messages-project-run.md#python-steps) quotes each message. Tell Claude what the run says, and it handles each case:

- **Missing or outdated packages:** in a fresh clone or after a pull, Claude runs `uv sync --frozen` to fetch Python and the packages into `.venv/`. If `uv` is missing, you or IT install it first.
- **Missing `uv.lock` or `.python-version`:** Claude copies the starter files from `code/templates/py-project/` and syncs `.venv/`. If you deleted or changed `.python-version` by accident, discard that change in GitHub Desktop.
- **Python older than 3.11:** Claude asks which version to use and updates `.python-version` and `pyproject.toml`. It then locks, syncs, and runs the fresh-copy check.

## Add or remove a Python package, or take the packages of another date

Claude manages Python packages through `uv` and writes every version into `uv.lock`; no step installs a package while it runs.

**Ask Claude.** In the project:

```prompt
Install the Python package <name>.
```

```prompt
Remove the Python package <name> from pyproject.toml and uv.lock.
```

```prompt
Use the packages of <date>.
```

Claude adds each package name to `pyproject.toml` without a version number. The project's date (`exclude-newer`) then chooses each version in `uv.lock`. Tell Claude if a step stops with `No module named '<name>'`. Do the same if `pandas` reports a missing optional dependency (such as `jinja2`, `openpyxl` or `pyarrow`). If you ask for one exact version, Claude pins it and tells you that package no longer follows the project's date.

For another date, Claude changes `exclude-newer` in `pyproject.toml`, updates `uv.lock`, and syncs `.venv/`. An older date's package may lack a build for the project's Python. Claude names the package and asks before changing `.python-version` and `requires-python` together (not yet tested).

## After a change to the packages

After any change to `pyproject.toml` or `uv.lock`, Claude checks that the lock restores on its own before saying the change works.

Claude copies the committed files into a fresh folder under `temp/`, along with `old-data-folder.txt` if `code/pins.do` still holds an `old_` line. In that copy, Claude runs `uv sync --frozen` and `master.do`'s Python check. In a project that also has R steps, Claude restores R in the same fresh copy so one copy checks both. On Windows, Claude makes the copy and runs the sync. You then run that check in Stata's window and tell Claude how it ended.

**Check.** Claude reports the packages and their versions from `uv.lock`, the date, and what the fresh-copy check showed. Ask Claude to commit `pyproject.toml`, `uv.lock` and `.python-version` with the step that needs them.

**Untested on Windows.** Nobody has yet tested the fresh-copy check in Stata's window on Windows.
