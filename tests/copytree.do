* Copies a folder tree: do copytree.do <from> <to>   (skips .git, _t, logs/, *.log, and all of temp/ but its README)
args from to
capture mkdir "`to'"
local fs : dir "`from'" files "*", respectcase
foreach f of local fs {
    if substr("`f'", -4, .) == ".log" continue
    copy "`from'/`f'" "`to'/`f'", replace
}
local ds : dir "`from'" dirs "*", respectcase
foreach d of local ds {
    if inlist("`d'", ".git", "_t", "logs") continue
    * A project's or a build's working folder temp/: its README only.
    if "`d'" == "temp" {
        capture mkdir "`to'/temp"
        capture copy "`from'/temp/README.md" "`to'/temp/README.md", replace
        continue
    }
    do "${t_tests}/copytree.do" "`from'/`d'" "`to'/`d'"
}
