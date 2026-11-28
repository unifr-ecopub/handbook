* Writes an R test step into the toy project: do rstep.do <project> <step path> <kind>
* The step begins with the lines of the project's code/templates/step.R as they ship, its source
* line included, up to the line that marks the template as not a step; the kind's lines follow.
* kinds: tab (a table from the pinned toy version, the raw delivery, a hand-made table from
* intermediate/rtoy/ and the Stata step's working file, a line of letters in the order R sorts
* them, and one draw after the seed), stop, quit,
* kill (tab, then R stops with an error, quits with status 0 or is killed), twice (tab, then a
* second write to the same table through new_file()), explore, digit (loads 1toy/toy), qa (writes
* a list of unmatched rows under logs/qa/), flow (chair_save, two chair_merge against one file and
* a chair_append; the merge keeps a tibble, the master's row order and a column of its own named
* .chair_l, the name an earlier version used inside), rdup (chair_save on a key that
* repeats), rbad (chair_merge with an outcome expect lacks)
args P s kind
local stem = substr("`s'", strrpos("`s'", "/") + 1, .)
local stem = substr("`stem'", 1, strlen("`stem'") - 2)
* "@" stands for a dollar sign, which Stata would expand.
mata: b = J(0, 1, "")
if inlist("`kind'", "tab", "stop", "quit", "kill", "twice") {
    mata: b = b \ `"d <- chair_use("toy/toy")"' \ `"w <- read.csv(file.path(P@raw_toy, "weights.csv"))"' \ `"f <- read.csv(file.path(P@intermediate, "rtoy", "factor.csv"))"'
    mata: b = b \ `"s <- haven::read_dta(file.path(P@temp, "toy.dta"))"' \ `"m <- merge(merge(as.data.frame(d), w, by = "ctn"), f, by = "ctn")"' \ `"stopifnot(nrow(m) == 26, nrow(s) == 26)"'
    mata: b = b \ `"out <- new_file(file.path(P@tables, "`stem'.tex"))"' \ `"writeLines(c(sprintf("total %.0f", sum(m@value * m@weight * m@factor)), paste("order", paste(sort(c("b", "A", "\u00e9", "a", "B", "e")), collapse = " ")), sprintf("draw %.6f", runif(1))), out)"' \ `"cat("`stem'.R: wrote", out, "\n")"'
}
if "`kind'" == "stop" mata: b = b \ `"stop("a failure inside the R script")"'
if "`kind'" == "quit" mata: b = b \ `"quit(save = "no", status = 0)"'
if "`kind'" == "kill" mata: b = b \ `"tools::pskill(Sys.getpid(), if (.Platform@OS.type == "windows") tools::SIGTERM else tools::SIGKILL)"' \ "Sys.sleep(5)"
if "`kind'" == "twice" mata: b = b \ `"writeLines("again", new_file(file.path(P@tables, "`stem'.tex")))"'
if "`kind'" == "explore" mata: b = b \ `"d <- chair_use("toy/toy")"' \ `"cat(sprintf("explore: %d rows; data root %s\n", nrow(d), P@data))"'
if "`kind'" == "qa" mata: b = b \ `"writeLines("ctn", file.path(P@logs, "qa", "`stem'_unmatched.csv"))"' \ `"cat("`stem'.R: wrote its unmatched rows\n")"'
if "`kind'" == "flow" {
    mata: b = b \ `"d <- chair_use("toy/toy")"' \ `"w <- read.csv(file.path(P@raw_toy, "weights.csv"))"' \ `"chair_save(w[w@ctn <= 20, ], file.path(P@temp, "rhalf.dta"), key = "ctn")"'
    mata: b = b \ `"d <- d[order(-d@ctn), ]"' \ `"d@.chair_l <- d@ctn + 60L"' \ `"m <- chair_merge(d, file.path(P@temp, "rhalf.dta"), type = "1:1", on = "ctn", expect = c("both", "left_only"), note = "R list.")"'
    mata: b = b \ `"stopifnot(inherits(m, "tbl_df"), nrow(m) == 26, identical(as.numeric(m@ctn), as.numeric(d@ctn)), identical(m@.chair_l, d@.chair_l))"'
    mata: b = b \ `"m2 <- chair_merge(m, file.path(P@temp, "rhalf.dta"), type = "1:1", on = "ctn", expect = c("both", "left_only"), keep = "both")"'
    mata: b = b \ `"a <- chair_append(file.path(P@temp, "rhalf.dta"), file.path(P@temp, "rhalf.dta"))"' \ `"stopifnot(nrow(a) == 40, nrow(m2) == 20)"' \ `"chair_save(m, file.path(P@temp, "rmerged.rds"), key = "ctn")"'
}
if "`kind'" == "rdup" mata: b = b \ `"chair_save(data.frame(ctn = c(1, 1)), file.path(P@temp, "explore", "dup.dta"), key = "ctn")"'
if "`kind'" == "rbad" mata: b = b \ `"m <- chair_merge(chair_use("toy/toy"), file.path(P@temp, "rhalf.dta"), type = "1:1", on = "ctn", expect = "both")"'
if "`kind'" == "digit" mata: b = b \ `"d <- chair_use("1toy/toy")"' \ `"cat(sprintf("digit: %d rows\n", nrow(d)))"'
mata: t = cat(st_local("P") + "/code/templates/step.R"); m = selectindex(strpos(t, "stop(" + char(34) + "templates/step.R is a template") :== 1); st_local("m", strofreal(rows(m) == 1 ? m[1] : 0))
if "`m'" == "0" {
    display as error "The line that marks code/templates/step.R as a template was not found: rstep.do takes the lines above it."
    exit 459
}
mata: s = t[1..m[1] - 1] \ subinstr(b, "@", char(36)); f = st_local("P") + "/code/" + st_local("s"); if (fileexists(f)) unlink(f); fh = fopen(f, "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
