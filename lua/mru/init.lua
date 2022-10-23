local Store = require("mru.store")
local FileListener = require("mru.file_listener")
local Mru = require("mru.mru")
local NullMru = require("mru.null_mru")

local AUGROUP = "mru__group"

local M = {}

local instance = NullMru()

M.setup = function(opts)
  local store = Store(opts.mru_file)
  local listener = FileListener(AUGROUP)
  instance = Mru(store, listener)
  instance.setup()
end

M.cleanup = function()
  instance.cleanup()
  instance = NullMru()
end

M.get = function()
  return instance.get()
end

M.get_absolute = function()
  return instance.get_absolute()
end

M.list = function()
  return instance.list()
end

M.list_absolute = function()
  return instance.list_absolute()
end

return M
