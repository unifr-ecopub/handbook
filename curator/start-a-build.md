# Start a build

A build is the folder `builds/<dataset>/` in `data-processing`: the code that turns a raw source into a dataset. Claude writes and runs it with you, the build author. A release is [a request of its own](release-a-version.md).

## Ask Claude

First [add the delivery](add-a-delivery.md), so that it has its row in the data map.

**Ask Claude.** In `data-processing`:

```prompt
Start a build for <dataset> from <source>.
```

**Claude will ask you.** Everything in one message.

- The dataset's name and each finished file's name: lower case, under 28 characters. A file's name takes no hyphen.
- What one row is, its key, and which variables to keep.
- The finished file's terms of use.
- The cases that code cannot decide, which go to [a review round](run-a-review-round.md).
- Your name, for the build's `decisions.md`.

For municipal data, Claude also asks which list the numbers follow, which boundary year you choose, and how figures are added up, averaged or split.

`chair_boundary`, which brings municipality numbers to one boundary year, stops if the data can be read two ways. Claude shows you [the sentence](../reference/messages-build-and-release.md#stops-of-the-boundary-command) and the rows, and your answer becomes a D-number.

## Check the result

**Check.** Claude shows the counts that the steps printed, the rows written to `logs/qa/`, and each finished file's first ten rows.

**What can go wrong.** Those rows reach Anthropic's servers. Nothing in Claude's instructions stops this display for [a source that bars outside services](../data/terms-of-use.md#sources-that-may-not-reach-an-outside-service).

## Read what the run left, then commit and push

On the data curator's machine, a candidate now waits. It was made from code that is not yet committed, so do not release it. On any other machine, nothing is staged. [Commit and push](commit-and-push.md) the build's folder and `datamap.csv`, then ask for the build again, for example:

```prompt
Run the build for <dataset> again.
```
