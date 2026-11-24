# Terms of use

Each source is open to the whole team, and to Claude, unless its terms say otherwise.

## Where terms are written

- In the column `terms` of [the data map](data-map.md), for each raw source and each processed file.
- In a `README.md` in the source's folder, `raw/<source>/`, if the terms are anything but `open` or `unknown`.

`terms` reads `open`, `chair only`, or a restriction in the words that the provider used. Nothing is added to those words, because the entry binds everyone who reads it.

A processed file and a review sheet have their source's terms. A replication package ships only what the authors allow.

## Sources that may not reach an outside service

Claude Code sends what Claude reads to Anthropic's servers. Some providers bar that.

Claude's instructions cover such a source. In `data-processing`, the bar holds once the source's `README.md` or its row in the data map states it, or, for [a new delivery](../curator/add-a-delivery.md), once you state it. Claude then opens no file of the source and shows no row or value of it, by any route: only counts and the names and types of variables. It never opens the log of a run of a build that reads the source, and takes from it only a few fixed lines: the outcome, the counts the steps print, the command that stopped, and the build's own sentences. You read the rest of the log yourself. For a new source, Claude asks for the terms before it opens a file. `unknown` and `chair only` do not bar anything.

In a project, the same test holds: terms that bar outside services, or a `README.md` that says not to open the files. Before an explore file on a source, or before it reads a log beyond its command and outcome lines, Claude reads the source's `README.md` and terms; on such a source it shows only counts, the outcome line and Stata's error, and stops where a task needs the records, also in [a diagnosis](../researcher/find-why-a-run-failed.md).

**What can go wrong.** These are instructions, not locks. Decide first whether the provider's terms let Claude work on the source.
