--- Copyright (C) 2024  Jörg Bakker
---

--- Piping s.th. into fzf from vis doesn't work, so we need to build the pipe
--- before and just run it.

local module = {}
module.sql_cmd = 'sqlite3 -column -header -batch'
module.sql_db  = ''
module.pgr_cmd = 'fzf --reverse --header-lines=2 +i'

module.sql = function(win, range)
	--- Replace newlines with blanks
	local query = string.gsub(win.file:content(range), '\n', ' ')
	--- Quote all ' characters
	query = string.gsub(query, "'", "\'")
	local command = 'echo "'..query..'" | '..module.sql_cmd..' '..module.sql_db..' | '..module.pgr_cmd
	local status, out, err = vis:pipe(win.file, {start = 1, finish = 0}, command, false)
	return true
end

vis:command_register("sql", function(argv, force, win, selection, range)
	module.sql(win, range)
end, "Run queries on an SQL database")

return module
