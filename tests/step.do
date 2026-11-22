* Writes a test step into the toy project: do step.do <project> <step path> <kind>
* The step begins with the lines of the project's code/templates/step.do as they ship, its stop
* lines included, up to the two lines that mark the template as not a step; the kind's lines follow.
* kinds: load (the raw pin and the toy version), loadcheck (load, after checking that temp/ and the
* results folders hold no stray file), fig, fig2 (two exports, no replace), figrep (two exports with
* replace), figmore (fig, and a second figure <stem>_b.png), tab (a table and a number made from
* both inputs), esttab (a regression on made-up numbers, its table written with esttab and no
* replace), misnamed, explore, hand (the sum of a hand-made table in intermediate/toy/, as a table),
* map (two squares drawn with grmap, Stata's own map command, which must be activated first)
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
if "`kind'" == "explore" file write `fh' "chair_use toy/toy, clear" _n `"display as text "explore: " _N " rows; data root @{data}""' _n
file close `fh'
* "@{" stands for a dollar sign and a brace, which file write would expand.
mata: t = cat(st_local("P") + "/code/templates/step.do"); m = selectindex(substr(t, 1, 40) :== "display as error " + char(34) + "templates/step.do is a"); st_local("m", strofreal(rows(m) == 1 ? m[1] : 0))
if "`m'" == "0" {
    display as error "The line that marks code/templates/step.do as a template was not found: step.do takes the lines above it."
    exit 459
}
mata: s = cat(st_local("P") + "/code/" + st_local("s")); s = subinstr(s, "@{", char(36) + "{"); s = subinstr(s, "@T", char(96) + "t" + char(39)); s = t[1..m[1] - 1] \ s; unlink(st_local("P") + "/code/" + st_local("s")); fh = fopen(st_local("P") + "/code/" + st_local("s"), "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
