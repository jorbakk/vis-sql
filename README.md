# Run SQL commands on a database client and browse through output

Run region or buffer through a database client like sqlite3 and pipe the output to a pager
like vis-menu or fzf.

## Usage

In vis:

`:sql`

## Configuration

In visrc.lua:

```lua
plugin_vis_sql = require('plugins/vis-sql')

-- SQL client command (default: 'sqlite3 -column -header -batch')
plugin_vis_sql.sql_cmd = 'sqlite3 -column -header -batch'

-- SQL database (default: '')
plugin_vis_sql.sql_db  = os.getenv('HOME')..'data/my-database.db'

-- Pager command for output (default: 'fzf --reverse --header-lines=2 +i')
plugin_vis_sql.pgr_cmd = 'fzf --reverse --header-lines=2 +i'

-- Mapping configuration example (<Space>q)
vis.events.subscribe(vis.events.INIT, function()
    vis:map(vis.modes.NORMAL, " q", ":sql<Enter>", "run buffer as SQL command")
    vis:map(vis.modes.VISUAL, " q", ":sql<Enter>", "run selection as SQL command")
end)

```
