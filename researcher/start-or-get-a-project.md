# Start a new project, or get one onto your machine

Use this page to start a new project from the template, fill an empty repo you created on GitHub, or clone an existing project of the chair.

## Start a new project

**Ask Claude.** In a project that you already have, if your GitHub account can create repositories in the chair's organisation:

```prompt
Start a new project <project>.
```

Claude creates a private repo from `project-template` with `gh` and clones it into your projects folder. Without `gh` or a sign-in, create the repo on github.com with **Use this template** on `project-template`; Claude clones it once it is there (not yet tested).

**Only you do.** Once Claude has made a repo for you, ask the data curator to give the team of all members the role **Write** on it. If your account cannot create repositories in the organisation, give the data curator the project's bare name and nothing more. The names `data`, `data-processing`, `handbook` and `project-template` are taken. The data curator [makes the repo from the template](../curator/manage-repos-and-people.md#create-a-project-repo-from-the-template).

Never make a project from a ZIP or `git archive`: a folder without `AGENTS.md` and `.claude/` is not a working project.

## If you created an empty repo on GitHub

**Ask Claude.** In a project that you already have, if you created a new repo without **Use this template** (not yet tested):

```prompt
My new repo is empty.
```

**Claude will ask you.** For your yes before it puts the template's files into the repo (over any `README.md` or `.gitignore` that GitHub wrote). If the repo already holds an old project's files, Claude puts no template file among them. With your yes, Claude renames the folder on this machine and starts a new project beside it so you can [move the old project in](move-an-existing-project-in.md).

**Only you do.** If the repo held an old project, that repo still holds the name on GitHub. Rename it there (**Settings**, **Repository name**) or choose another name for the new project.

## Get a project of the chair onto your machine

**Ask Claude.** In a project that you already have:

```prompt
Get me the project <project>.
```

Claude clones the project and tells you where the clone is. You clone only [the first repo on a machine](../start/set-up-your-machine.md#clone-your-first-repo) yourself.

**Claude will ask you.** Once, the folder where you keep your projects. It refuses a folder inside Dropbox, OneDrive or another project. If a folder of that name is already there, it says so and clones nothing.

**Untested on Windows.** Claude clones with Git for Windows. If git is missing, Claude says so, and you install it.

## Open the new clone and run everything

1. Open a new session on the new clone's top folder.
2. Claude Code asks whether you trust this folder. Accept. Unless you accept, Claude Code ignores the repo's permission rules.
3. Ask:

   ```prompt
   Run everything.
   ```

   On Windows, with R or Python steps, [start the run yourself](work-with-r-steps.md#run-the-project-on-windows).

**Check.** The run ends `Run complete`, and no file in your clone changed. If exhibits changed, your run differs from the committed results, and Claude names them before any commit.
