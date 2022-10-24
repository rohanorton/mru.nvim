local Store = require("mru.store")
local FileListener = require("mru.file_listener")

local has_sqlite, sqlite = pcall(require, "sqlite")
if not has_sqlite then
  error("This plugin requires sqlite.lua (https://github.com/tami5/sqlite.lua) " .. tostring(sqlite))
end

local DATA_HOME = vim.fn.stdpath("data")

local Config = function(opts)
  local self = {}

  local defaults = {
    database_filepath = DATA_HOME .. "/mru.db",
    event_listener_augroup = "mru__group",
  }

  opts = vim.tbl_deep_extend("keep", opts or {}, defaults)

  self.create_store = function()
    local db = sqlite:open(opts.db_filename)
    if not db then
      vim.notify("MRU could not open database", vim.log.levels.ERROR)
      return
    end
    return Store(db)
  end

  self.create_listener = function()
    return FileListener(opts.event_listener_augroup)
  end

  return self
end

return Config
