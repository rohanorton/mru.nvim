local Store = require("mru.store")
local FileListener = require("mru.file_listener")

local DATA_HOME = vim.fn.stdpath("data")

local Config = function(opts)
  local self = {}

  local defaults = {
    database_filepath = DATA_HOME .. "/mru.db",
    event_listener_augroup = "mru__group",
  }

  opts = vim.tbl_deep_extend("keep", opts or {}, defaults)

  self.create_store = function()
    return Store(opts.database_filepath)
  end

  self.create_listener = function()
    return FileListener(opts.event_listener_augroup)
  end

  return self
end

return Config
