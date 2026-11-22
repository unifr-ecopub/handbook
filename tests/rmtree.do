* Removes a folder tree: do rmtree.do <folder> [writable]
* writable makes the tree writable first (a suite stopped during a case that makes a folder
* read-only leaves one behind). A link is removed itself and never followed, so the folder or file
* it points to stays: a folder handed to rmtree.do that is itself a link stops it before anything
* is changed, and inside the tree rm removes every link, one that points nowhere too. A link to a
* folder is known by Stata's cd, which resolves it to another path. On Windows a link is not looked
* for: making one needs rights that the tests do not have, and nothing under _t/ is one.
args dir writable
mata: st_local("there", strofreal(direxists(st_local("dir"))))
if "`there'" != "1" exit
if c(os) != "Windows" {
    local back "`c(pwd)'"
    quietly cd "`=substr("`dir'", 1, strrpos("`dir'", "/") - 1)'"
    local real "`c(pwd)'/`=substr("`dir'", strrpos("`dir'", "/") + 1, .)'"
    quietly cd "`dir'"
    local link = "`c(pwd)'" != "`real'"
    quietly cd "`back'"
    if `link' {
        display as error "rmtree.do: `dir' is a link, so nothing was changed or removed: remove the link itself."
        exit 693
    }
    if "`writable'" != "" shell chmod -R u+w "`dir'"
    shell find "`dir'" -mindepth 1 -maxdepth 1 -type l -exec rm {} +
}
local fs : dir "`dir'" files "*", respectcase
foreach f of local fs {
    erase "`dir'/`f'"
}
local back "`c(pwd)'"
quietly cd "`dir'"
local real "`c(pwd)'"
local ds : dir "`dir'" dirs "*", respectcase
foreach d of local ds {
    local link 0
    if c(os) != "Windows" {
        quietly cd "`real'/`d'"
        local link = "`c(pwd)'" != "`real'/`d'"
        quietly cd "`real'"
    }
    if `link' {
        shell rm "`dir'/`d'"
        mata: st_local("there", strofreal(direxists(st_local("dir") + "/" + st_local("d"))))
        if "`there'" == "1" {
            quietly cd "`back'"
            display as error "rmtree.do: the link `dir'/`d' could not be removed."
            exit 693
        }
    }
    else {
        quietly cd "`back'"
        do "${t_tests}/rmtree.do" "`dir'/`d'"
        quietly cd "`real'"
    }
}
quietly cd "`back'"
rmdir "`dir'"
