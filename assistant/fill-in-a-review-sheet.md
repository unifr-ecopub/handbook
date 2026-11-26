# Fill in a review sheet

A review sheet is an Excel file that lists the cases code cannot decide, such as an uncertain match. You decide each case, and Claude never edits a sheet.

## Fill in decision and note

In the data root, open `intermediate/<dataset>/<dataset>-review-<n>.xlsx` in Excel.

Each row is one case. Its first columns identify the case and show what you need to judge it. `1` says yes and `0` says no to the build's question, such as whether a match is right. If the sheet does not show the question, ask the data curator.

- `decision`: type `1` or `0`. If you cannot decide yet, leave the cell blank.
- `note`: type your reason in a few words.

Change nothing else. Do not rename, move or delete a column, a row or the file. Save the file in its folder, and tell the data curator that it is filled. The build's next run reads it from there.

A sheet follows the [terms of use](../data/terms-of-use.md) of its source.

## What stops the next build

The build reads each `.xlsx` file in the folder, and stops in three cases. The data curator then asks you to correct the sheet; for the first two stops, the message names the sheets and the Excel rows.

- A decision is something other than `1`, `0` or blank.
- Two rows decide one case differently, whether in two sheets (including a conflicted copy that Dropbox made) or in one sheet that lists a case twice.
- A sheet lacks a column.
