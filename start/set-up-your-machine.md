# Set up your machine

Do this once per machine. At the end, a full run of your first repo ends `Run complete`. A repo is one project's code on GitHub, and a full run runs all of it.

**Untested on Windows.** Nobody has yet done these steps on a university machine, or checked that each program installs without administrator rights.

## Before you start: what the data curator arranges

- **GitHub.** The data curator [adds you](../curator/manage-repos-and-people.md#add-a-member) to the chair's organisation. GitHub emails you an invitation: open its link and accept.
- **The data root,** the one folder of shared data, `chair-research-data`. Your machine needs it as a folder that Dropbox syncs.
- **A Claude account.**
- **The name of your first repo.** For a researcher, it is a practice project.

How members receive the data root and the Claude account is not yet settled.

## Install the programs and sign in

1. Stata 18 or later.
2. GitHub Desktop. Sign in with your GitHub account.
3. Git for Windows, with its installer's own choices. Claude needs it for git.
4. Claude Code, as the desktop app or for the command line. Sign in with the Claude account.

The data root needs Dropbox's own program. Only [a project with R steps](../researcher/work-with-r-steps.md) needs R and RStudio.

## Clone your first repo

A clone is your own copy of a repo, on your machine.

1. In GitHub Desktop, choose **File › Clone Repository** and pick the repo.
2. Set **Local Path** to a folder that does not sync, such as `C:/Users/<you>/GitHub/<project>`.
3. Click **Clone**.

A path that holds `Dropbox` or `OneDrive` syncs. Nobody has checked whether a university machine also syncs `Documents` and `Desktop`, so avoid both.

[Claude clones each further project](../researcher/start-or-get-a-project.md). The data curator keeps all clones in one folder, where the tests and two routines look for them.

## Open your first session and answer the trust question

1. Open a session on the clone's top folder. In the desktop app, open the folder in the **Code** tab. In a terminal, type `claude` in the folder.
2. Claude Code asks whether you trust this folder. Accept. Unless you accept, Claude Code ignores the repo's permission rules. The question comes the first time you open each clone.
3. Choose Auto mode, in which Claude asks no question before each command. In the app, pick **Auto** in the mode selector under the prompt box. In a terminal, press Shift+Tab until `auto mode on` shows.

Step 3 follows Claude Code's documentation, and no trial here has confirmed it. If **Auto** is missing, tell the data curator.

## Let Claude check the machine and run everything

**Ask Claude.** In your first repo:

```prompt
This is my first time on this computer.
```

Claude checks git, Stata, the data root and, in a project with R steps, R, one at a time. It stops at the first that is not right and says who puts it right. Where `stata-se` is not found, it looks in Stata's usual folder before it asks you.

**Claude will ask you.** The full path of the data root, the first time on a machine. Claude writes it into the data-root file in your home folder.

**Only you do.**

- In Explorer, open `chair-research-data`, copy the path from the address bar, and give it to Claude.
- Install what Claude names, keeping the choices its installer proposes, and say when it is done. Claude runs no installer, even if you ask: whatever needs an installer, administrator rights or a sign-in is yours.

Claude then runs one example file to prove the machine, and then everything.

**Check.** The example run ends `Step complete`, the full run ends `Run complete`, and no file in your clone changed. If exhibits changed, Claude names them before any commit.

On Windows, [you start the run yourself](../researcher/work-with-r-steps.md#run-the-project-on-windows) if the repo has R steps. In `data-processing`, say that the machine is new and give Claude the path.

Later, a run that stops before any step with a sentence about the machine, such as [the data root was not found](../reference/messages-project-run.md#before-anything-runs-the-machine-checks), goes the same way: tell Claude what it says.
