# Add a Stata package to a project

The project stores community packages, such as `reghdfe`, in its `ado/` folder, which git tracks so every machine runs the same version. A run looks for packages only there and among Stata's own commands. Steps install nothing while running.

## Ask Claude for the package

**Ask Claude.** In the project, when a new step needs a package:

```prompt
Install the Stata package <package>.
```

Or when a run stops with Stata's message that it does not know a command:

```text
command <name> is unrecognized
```

Tell Claude what the run says. To keep the exact version that an old project ran on, ask instead:

```prompt
Copy the package <package> from my Stata.
```

**Claude will ask you.** Your yes, before each change to `ado/`, once it has named the package and what it is for. Claude fetches the package once, through `master.do`, or copies it from your own Stata's package folder, which it finds itself. If your Stata does not have it, Claude fetches it instead and says that its version may differ.

**Check.** Claude names the package, its version and where it came from, and the step that needed it runs past the command. Ask Claude to commit the package's new files in `ado/` with the step.

## Packages that fetch other packages

Some packages fetch others when they run. Claude checks each new package for this behaviour, tells you which package does it, and with your yes puts what it would fetch into `ado/` too. Where the package has an option that stops automatic fetching, Claude proposes adding that option to each call, with your yes. One such option changes a later random draw in the run, such as a bootstrap, and Claude says so first.

**What can go wrong.** If a run leaves a new or changed file in `ado/`, a package fetched something while it ran. Do not commit that file unread: tell Claude.

## A command that must be activated

A run can stop with Stata's own message `grmap not yet activated`, and the advice to type `grmap, activate`. Never type it: in Stata's window it writes to a folder that no run reads, and the next run fails the same way. Tell Claude what the run says: with your yes, it activates the command inside the project.

Never install a package from Stata's window either. Ask Claude instead, so that Claude puts the package in `ado/` with your yes and names its version.
