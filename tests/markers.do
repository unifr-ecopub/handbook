* Marker files that show a run cleared nothing: do markers.do <project> plant | check
* plant writes marker.txt into temp/, temp/explore/ and the three results folders. check sets the
* caller's local kept to 1 when all five are still there as planted, else 0, and erases them.
args P what
local kept 1
foreach d in temp temp/explore paper/results/tables paper/results/figures paper/results/numbers {
    if "`what'" == "plant" {
        capture mkdir "`P'/`d'"
        mata: fh = fopen(st_local("P") + "/`d'/marker.txt", "w"); fput(fh, "marker"); fclose(fh)
        continue
    }
    mata: st_local("m", strofreal(fileexists(st_local("P") + "/`d'/marker.txt")))
    if `m' mata: st_local("m", strofreal(cat(st_local("P") + "/`d'/marker.txt") == "marker"))
    local kept = `kept' & `m'
    capture erase "`P'/`d'/marker.txt"
}
if "`what'" == "check" c_local kept `kept'
