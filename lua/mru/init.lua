local Config = require("mru.config")
local Mru = require("mru.mru")
local NullMru = require("mru.null_mru")

local M = {}

local instance = NullMru()

M.setup = function(opts)
  local config = Config(opts)
  local store = config.create_store()
  local listener = config.create_listener()
  instance = Mru(store, listener)
  instance.setup()
end

M.cleanup = function()
  instance.cleanup()
  instance = NullMru()
end

M.get = function(opts)
  return instance.get(opts)
end

M.get_absolute = function(opts)
  return instance.get_absolute(opts)
end

M.list = function()
  return instance.list()
end

M.list_absolute = function()
  return instance.list_absolute()
end

return M
