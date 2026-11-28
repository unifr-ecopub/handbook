* Writes a test step into the toy project: do step.do <project> <step path> <kind>
* The step begins with the lines of the project's code/templates/step.do as they ship, its stop
* lines included, up to the two lines that mark the template as not a step; the kind's lines follow.
* kinds: load (the raw pin and the toy version), loadcheck (load, after checking that temp/ and the
* results folders hold no stray file), fig, fig2 (two exports, no replace), figrep (two exports with
* replace), figmore (fig, and a second figure <stem>_b.png), tab (a table and a number made from
* both inputs), esttab (a regression on made-up numbers, its table written with esttab and no
* replace), misnamed, explore, hand (the sum of a hand-made table in intermediate/toy/, as a table),
* map (two squares drawn with grmap, Stata's own map command, which must be activated first),
* flowbuild (two working files with chair_save, and two chair_merge against one file, each with
* six rows unmatched and its own note), flowmore (temporary files merged: one chair_use made, one
* built and named, three in a loop; three files named from a value in a loop, one alone, one with
* the value inside its name; clear all; a chair_append of two files), counts (a file saved twice,
* another once, a third with save; a merge with update; a save after other data were loaded; a raw
* delivery read in a helper; the project's setting p_step), edge (chair_merge and chair_append of a
* temporary file with no rows; chair_save of a name that holds a dollar sign),
* order (two numbers written b first, then a), dupkey (chair_save on a key that repeats), nokey
* (chair_save on a key with a missing value), badmerge (chair_merge with an outcome expect() lacks)
args P s kind
tempname fh
file open `fh' using "`P'/code/`s'", write text replace
local stem = substr("`s'", strrpos("`s'", "/") + 1, .)
local stem = substr("`stem'", 1, strlen("`stem'") - 3)
if "`kind'" == "loadcheck" {
    foreach f in "@{p_temp}/stray.dta" "@{p_temp}/explore/stray.txt" "@{p_results}/tables/stray.tex" "@{p_results}/figures/stray.png" "@{p_results}/numbers/stray.txt" {
        file write `fh' `"capture confirm file "`f'""' _n "assert _rc" _n
    }
    file write `fh' `"confirm file "@{p_temp}/README.md""' _n
}
if inlist("`kind'", "load", "loadcheck") {
    file write `fh' `"import delimited using "@{p_raw}/@{raw_toy}/weights.csv", clear"' _n "isid ctn" _n `"save "@{p_temp}/weights.dta", replace"' _n
    file write `fh' "chair_use toy/toy, clear" _n `"merge 1:1 ctn using "@{p_temp}/weights.dta", assert(match) nogenerate"' _n "generate weighted = value * weight" _n "isid ctn" _n `"save "@{p_temp}/toy.dta", replace"' _n
}
if inlist("`kind'", "fig", "fig2", "figrep", "figmore") file write `fh' `"use "@{p_temp}/toy.dta", clear"' _n "scatter value ctn" _n `"graph export "@{p_results}/figures/`stem'.png", width(400)"' (cond("`kind'" == "figrep", " replace", "")) _n
if "`kind'" == "figmore" file write `fh' "scatter ctn value" _n `"graph export "@{p_results}/figures/`stem'_b.png", width(400)"' _n
if inlist("`kind'", "fig2", "figrep") file write `fh' "scatter ctn value" _n `"graph export "@{p_results}/figures/`stem'.png", width(400)"' (cond("`kind'" == "figrep", " replace", "")) _n
if "`kind'" == "tab" file write `fh' `"use "@{p_temp}/toy.dta", clear"' _n "summarize weighted" _n "tempname t" _n `"file open @T using "@{p_results}/tables/`stem'.tex", write text"' _n `"file write @T "total " %12.0f (r(sum)) _n"' _n `"file close @T"' _n `"file open @T using "@{p_results}/numbers/`stem'_total.txt", write text"' _n `"file write @T %12.0f (r(sum)) _n"' _n `"file close @T"' _n
if "`kind'" == "esttab" file write `fh' "clear" _n "set obs 26" _n "generate x = _n" _n "generate y = 2 * x + mod(_n, 3)" _n "eststo: regress y x" _n `"esttab using "@{p_results}/tables/`stem'.tex", se"' _n
if "`kind'" == "misnamed" file write `fh' `"use "@{p_temp}/toy.dta", clear"' _n "scatter value ctn" _n `"graph export "@{p_results}/figures/fig_misnamed.png", width(400)"' _n
if "`kind'" == "hand" file write `fh' `"import delimited using "@{p_intermediate}/toy/factor.csv", clear"' _n "summarize factor" _n "tempname t" _n `"file open @T using "@{p_results}/tables/`stem'.tex", write text"' _n `"file write @T "total " %12.0f (r(sum)) _n"' _n `"file close @T"' _n
if "`kind'" == "map" {
    file write `fh' "clear" _n "set obs 12" _n "generate _ID = 1 + (_n > 6)" _n "generate k = mod(_n - 1, 6)" _n "generate _X = cond(k == 0, ., cond(inlist(k, 1, 2, 5), 0, 1)) + _ID - 1" _n "generate _Y = cond(k == 0, ., cond(inlist(k, 2, 3), 1, 0))" _n "drop k" _n "sort _ID, stable" _n `"save "@{p_temp}/`stem'_shp.dta", replace"' _n
    file write `fh' "clear" _n "set obs 2" _n "generate _ID = _n" _n "generate value = 4 * _n" _n "isid _ID" _n `"grmap value using "@{p_temp}/`stem'_shp.dta", id(_ID) clmethod(unique)"' _n `"graph export "@{p_results}/figures/`stem'.png", width(400)"' _n
}
if "`kind'" == "flowbuild" {
    file write `fh' `"import delimited using "@{p_raw}/@{raw_toy}/weights.csv", clear"' _n `"chair_save "@{p_temp}/weights.dta", key(ctn)"' _n "keep if ctn <= 20" _n `"chair_save "@{p_temp}/half.dta", key(ctn)"' _n
    file write `fh' "chair_use toy/toy, clear" _n `"chair_merge 1:1 ctn using "@{p_temp}/half.dta", expect(master match) nogenerate note(First list.)"' _n
    file write `fh' `"chair_merge 1:1 ctn using "@{p_temp}/half.dta", expect(master match) nogenerate note(Second list.)"' _n `"chair_save "@{p_temp}/toy.dta", key(ctn)"' _n
}
if "`kind'" == "flowmore" {
    file write `fh' `"use "@{p_temp}/toy.dta", clear"' _n "preserve" _n "chair_use toy/toy, clear" _n "rename value value2" _n "tempfile st" _n "save @Qst@E" _n "restore" _n "chair_merge 1:1 ctn using @Qst@E, expect(match) nogenerate" _n
    file write `fh' "preserve" _n "clear" _n "set obs 26" _n "generate ctn = _n" _n "generate flag = 1" _n "tempfile built" _n "save @Qbuilt@E" _n "restore" _n "chair_merge 1:1 ctn using @Qbuilt@E, expect(match) nogenerate name(built)" _n
    file write `fh' "forvalues k = 1/3 {" _n "    preserve" _n "    chair_use toy/toy, clear" _n "    rename value v@Qk@E" _n "    tempfile p@Qk@E" _n "    save @Qp@Qk@E@E" _n "    restore" _n "    chair_merge 1:1 ctn using @Qp@Qk@E@E, expect(match) nogenerate" _n "}" _n
    file write `fh' "generate grp = mod(ctn, 3)" _n "forvalues g = 0/2 {" _n "    preserve" _n "    keep if grp == @Qg@E" _n `"    chair_save "@{p_temp}/bygrp_@Qg@E.dta", key(ctn)"' _n "    restore" _n "}" _n
    file write `fh' "local v = ctn[1]" _n `"chair_save "@{p_temp}/one_@Qv@E.dta", key(ctn)"' _n `"chair_save "@{p_temp}/mid_@Qv@E_x.dta", key(ctn)"' _n
    file write `fh' "clear all" _n `"use "@{p_temp}/bygrp_0.dta", clear"' _n "local a 1" _n "local b 2" _n `"chair_append using "@{p_temp}/bygrp_@Qa@E.dta" "@{p_temp}/bygrp_@Qb@E.dta""' _n `"chair_save "@{p_temp}/joined.dta", key(ctn)"' _n
}
if "`kind'" == "counts" {
    file write `fh' `"assert "@{p_step}" == "my setting""' _n `"include "@{p_helpers}/readw.do""' _n `"use "@{p_temp}/toy.dta", clear"' _n `"chair_save "@{p_temp}/batch_1.dta", key(ctn)"' _n "keep if ctn == 1" _n `"chair_save "@{p_temp}/batch_1.dta", key(ctn)"' _n `"chair_save "@{p_temp}/batch_2.dta", key(ctn)"' _n `"save "@{p_temp}/batch_3.dta""' _n
    file write `fh' "clear" _n "set obs 2" _n "generate ctn = _n" _n "generate value = cond(_n == 1, 0, .)" _n `"chair_save "@{p_temp}/uleft.dta", key(ctn)"' _n "replace value = 11 * _n" _n `"chair_save "@{p_temp}/uright.dta", key(ctn)"' _n
    file write `fh' `"use "@{p_temp}/uleft.dta", clear"' _n `"chair_merge 1:1 ctn using "@{p_temp}/uright.dta", update expect(match match_update match_conflict) nogenerate"' _n `"use "@{p_temp}/toy.dta", clear"' _n `"chair_save "@{p_temp}/fromtoy.dta", key(ctn)"' _n
}
if "`kind'" == "edge" {
    file write `fh' "clear" _n "set obs 1" _n "generate ctn = 1" _n "tempfile empty" _n "preserve" _n "drop in 1" _n "save @Qempty@E, emptyok" _n "restore" _n
    file write `fh' "chair_merge 1:1 ctn using @Qempty@E, expect(master) nogenerate name(empty)" _n "chair_append using @Qempty@E, name(empty)" _n
    file write `fh' `"local w = "@{p_temp}/explore/wrapped" + char(36) + "data.dta""' _n `"chair_save "@Qmacval(w)@E", key(ctn)"' _n `"confirm file "@Qmacval(w)@E""' _n `"erase "@Qmacval(w)@E""' _n `"save "@{p_temp}/explore/edge_ok.dta", replace"' _n
}
if "`kind'" == "order" {
    file write `fh' "tempname t" _n
    foreach x in b a {
        file write `fh' `"file open @T using "@{p_results}/numbers/`stem'_`x'.txt", write text"' _n `"file write @T "`x'" _n"' _n "file close @T" _n
    }
}
if "`kind'" == "dupkey" file write `fh' `"use "@{p_temp}/toy.dta", clear"' _n "replace ctn = 1 in 2" _n `"chair_save "@{p_temp}/dup.dta", key(ctn)"' _n
if "`kind'" == "nokey" file write `fh' `"use "@{p_temp}/toy.dta", clear"' _n "replace ctn = . in 2" _n `"chair_save "@{p_temp}/dup.dta", key(ctn)"' _n
if "`kind'" == "badmerge" file write `fh' "chair_use toy/toy, clear" _n `"chair_merge 1:1 ctn using "@{p_temp}/half.dta", expect(match) nogenerate"' _n
if "`kind'" == "explore" file write `fh' "chair_use toy/toy, clear" _n `"display as text "explore: " _N " rows; data root @{data}""' _n
file close `fh'
* "@{" stands for a dollar sign and a brace, which file write would expand.
mata: t = cat(st_local("P") + "/code/templates/step.do"); m = selectindex(substr(t, 1, 40) :== "display as error " + char(34) + "templates/step.do is a"); st_local("m", strofreal(rows(m) == 1 ? m[1] : 0))
if "`m'" == "0" {
    display as error "The line that marks code/templates/step.do as a template was not found: step.do takes the lines above it."
    exit 459
}
mata: s = cat(st_local("P") + "/code/" + st_local("s")); s = subinstr(s, "@{", char(36) + "{"); s = subinstr(s, "@T", char(96) + "t" + char(39)); s = subinstr(subinstr(s, "@Q", char(96)), "@E", char(39)); s = t[1..m[1] - 1] \ s; unlink(st_local("P") + "/code/" + st_local("s")); fh = fopen(st_local("P") + "/code/" + st_local("s"), "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
