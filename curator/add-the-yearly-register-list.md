# Add the register's January list

Each January, `<source>` publishes its list of municipalities as of 1 January. The list is a new delivery, and leads to a new version of the municipality register.

1. Copy the list into `raw/` and have it recorded, as [a raw delivery](add-a-delivery.md).
2. Ask Claude, in `data-processing`:

   ```prompt
   The new January list of the municipalities is in raw/.
   ```

   The register build's `README.md` names each place that holds the delivery's date or the last year. Claude changes each one, then runs the whole build.
3. [Commit and push](commit-and-push.md) Claude's changes.
4. Ask Claude to run the register's build again. The first run used code that was not yet committed, so its candidate names the wrong commit.
5. Ask Claude to [release](release-a-version.md) the register.

**Claude will ask you.** How many municipalities the new list has. Take the figure from the publication of `<source>`. Claude never takes it from a run.

Each dataset that the register touches is released again when you ask.
