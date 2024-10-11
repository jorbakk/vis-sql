--- Copyright (C) 2024  Jörg Bakker
--- This is a terrible hack!
---

--- Piping s.th. into fzf doesn't work, no matter which way I try.

local module = {}

--- Command version 1
-- module.sql_cmd = "sqlite3 -column -header -batch 2013-2022_bugfix.db | fzf --reverse --header-lines=2 +i"

--- Command version 2
-- module.sql_cmd = "fzf --reverse --header-lines=2 +i"

--- Command version 3
-- module.sql_cmd = "cat scratch.sql | fzf --reverse --header-lines=2 +i"

--- Command version 4
-- module.sql_cmd = "cat > /tmp/vis.log"

--- Command version 5
--- !!!!!!!!!!!!!!!!!!!!!!!!!!!
--- This works!!!
-- module.sql_cmd = 'FZF_DEFAULT_COMMAND="sqlite3 -column -header 2013-2022_bugfix.db \'select * from accident limit 10\'" fzf --reverse --header-lines=2 +i'
--- !!!!!!!!!!!!!!!!!!!!!!!!!!!

--- Command version 6
--- !!!!!!!!!!!!!!!!!!!!!!!!!!!
--- This works!!!
-- module.sql_cmd = "echo select casenr, country from accident limit 10 | sqlite3 -column -header -batch 2013-2022_bugfix.db | fzf --reverse --header-lines=2 +i"
--- !!!!!!!!!!!!!!!!!!!!!!!!!!!


module.sql = function(win, selection, range)
	-- local command = module.sql_cmd

	local query = string.gsub(win.file:content(range), '\n', ' ')
	--- FIXME quote all ' characters
	query = string.gsub(query, "'", "\'")
	-- local command = 'FZF_DEFAULT_COMMAND="sqlite3 -column -header 2013-2022_bugfix.db \''..query..'\'" fzf --reverse --header-lines=2 +i'
	local command = 'echo "'..query..'" | sqlite3 -column -header -batch 2013-2022_bugfix.db | fzf --reverse --header-lines=2 +i'

	--- This shows fzf:
	local status, out, err = vis:pipe(win.file, {start = 1, finish = 0}, command, false)

	--- This blocks fzf when running cmd versions 1 and 2, but works with cat
	-- local status, out, err = vis:pipe(win.file, range, command, false)
	
	--- Lua error: file expected for first paramter, got string
	-- local status, out, err = vis:pipe("Some text", "cat > /tmp/vis.log", false)

	--- This gives a bash syntax error
	-- local status, out, err = vis:pipe("select * from accident limit 1;", command)

	vis:info(string.format("SQL status: %i, out: %s, err: %s", status, out, err))
	-- vis:info(selection)
	return true
end

vis:command_register("sql", function(argv, force, win, selection, range)
	module.sql(win, selection, range)
end, "SQL")

return module
