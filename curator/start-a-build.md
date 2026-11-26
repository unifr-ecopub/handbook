# Start a build

A build is the folder `builds/<dataset>/` in `data-processing`: the code that turns a raw source into a dataset. Claude writes and runs it with you, the build author. A release is [a request of its own](release-a-version.md).

## Ask Claude to start it

First [add the delivery](add-a-delivery.md), so that it has its row in the data map.

**Ask Claude.** In `data-processing`:

```prompt
Start a build for <dataset> from <source>.
```

**Claude will ask you.** Everything in one message:

- The dataset's name and each finished file's name. The dataset's name is lower case, with hyphens between words, and at most 28 characters, or 27 if it begins with a digit.
- What one row is, its key, and which variables to keep.
- The finished file's terms of use. When a build reads several inputs whose terms differ (at its start or when another input is added), the build author chooses the finished file's terms, including whether reading part of a restricted dataset passes its terms on. Claude asks you, proposes keeping every restriction from every input unless you name another, and records your answer under **Decided** in the build's `decisions.md` and in `datamap.csv`.
- The cases that code cannot decide, which go to [a review round](run-a-review-round.md).
- Your name, for the build's `decisions.md`.

## Check the result

**Check.** Claude shows the counts that the steps printed, the rows written to `logs/qa/`, and each finished file's first ten rows.

For a source whose terms [bar outside services](../data/terms-of-use.md#sources-that-may-not-reach-an-outside-service), or say not to open its files, Claude shows only the counts and the variables' names and types.

**Only you do.** For such a source, look at the rows yourself.

## Read what the run left, then commit and push

On the data curator's machine, a run that ends `Run complete` and `Staged` leaves a candidate built from uncommitted code. On any other machine, the build stages nothing.

Ask Claude to [commit and push](commit-and-push.md) the build's folder and `datamap.csv`. Once they are pushed exactly as they were when the build ran, that candidate can be [released](release-a-version.md) with no new build. If the code that makes the dataset changes after the run, the build runs again first: `release.do` refuses the candidate otherwise.
