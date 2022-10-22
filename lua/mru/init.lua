local Store = require("mru.store")
local Listener = require("mru.listener")
local Mru = require("mru.mru")
local NullMru = require("mru.null_mru")

local AUGROUP = "mru__group"

local M = {}

local instance = NullMru()

M.setup = function()
  local store = Store()
  local listener = Listener(AUGROUP)
  instance = Mru(store, listener)
  instance.setup()
end

M.cleanup = function()
  instance.cleanup()
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
