* Plays a hand edit of pins.do: sets one line, or adds it. do setpin.do <pins.do> <global> <value>
args f g v
mata: s = cat(st_local("f")); s = select(s, !ustrregexm(s, "^global " + st_local("g") + "(__[A-Za-z0-9_]+)? ")); s = s \ ("global " + st_local("g") + " " + char(34) + st_local("v") + char(34)); unlink(st_local("f")); fh = fopen(st_local("f"), "w"); for (k = 1; k <= rows(s); k++) fput(fh, s[k]); fclose(fh)
