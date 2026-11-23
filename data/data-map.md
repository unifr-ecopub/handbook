# The data map

The data map says what each source and each dataset of the chair is.

It is the file `datamap.csv` at the top of `data-processing`. Members of the chair's organisation open it on github.com, which shows it as a table with a search box. It has one row for each raw source and one for each processed file.

A dataset's own page is `builds/<dataset>/README.md` in the same repo. It says what the build reads, and what changed in each version.

## The columns

| Column | For a raw source | For a processed file |
|---|---|---|
| `name` | Its folder name in `raw/` | `<dataset>/<file>` |
| `kind` | `raw` | `processed` |
| `description` | What one row is | The same |
| `origin` | Who sent it | `build <dataset>` |
| `received` | The dates of its deliveries | A pointer to the build's `README.md` |
| `unit` | The unit of observation | The same |
| `key` | The columns that identify a row | The same |
| [`boundary_year`](municipal-data.md) | The list or date that its municipality numbers follow | `<yyyy>`, or `<yyyy>, own territory` |
| [`terms`](terms-of-use.md) | The terms of use | The same |
| `built_from` | `none` | The sources, datasets and `intermediate/` folders behind it |

`unknown` means that nobody knows. `none` means that the field does not apply. A release refuses a processed file whose `key`, `boundary_year` or `terms` is blank or `unknown`.

No row describes a table made by hand. The processed file made with it names the table's folder under `built_from`.

Each project's `code/pins.do` shows which versions and deliveries the project reads.
