# Terms of use

Each source is open to the whole team, and to Claude, unless its terms say otherwise.

## Where terms are written

- In the column `terms` of [the data map](data-map.md), for each raw source and each processed file.
- In a `README.md` in the source's folder, `raw/<source>/`, if the terms are not `open`.

`terms` reads `open`, `chair only`, or a restriction in the words that the provider used. Nothing is added to those words, because the entry binds everyone who reads it.

A processed file and a review sheet have their source's terms. A replication package ships only what the authors allow.

## Sources that may not reach an outside service

Claude Code sends what Claude reads to Anthropic's servers. Some providers bar that.

Claude's instructions cover such a source in two ways. In `data-processing`, Claude opens no data file once the source's `README.md` or its row in the data map states the bar. In a project, Claude stops if a task would read the source.

**What can go wrong.** These are instructions, not locks, and they leave three gaps today.

- [A new delivery](../curator/add-a-delivery.md). Claude looks at the first rows of a new source's text files, and asks for the terms afterwards.
- [A build](../curator/start-a-build.md). Claude shows the finished file's first rows, and the rows in `logs/qa/`.
- [A diagnosis](../researcher/find-why-a-run-failed.md). An explore file can print rows, and a project's instructions name no test of which source is restricted.

So saying the terms in your request does not keep the records out of the session. Decide first whether the provider's terms let Claude work on the source.
