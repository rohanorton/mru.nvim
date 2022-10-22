local Path = require("plenary.path")

local Mru = function(store, listener)
  local self = {}

  self.setup = function()
    listener.on_change(store.add)
    listener.setup()
  end

  self.cleanup = function()
    listener.cleanup()
  end

  self.get = function()
    return Path.new(store.get()):make_relative()
  end

  self.get_absolute = function()
    return store.get()
  end

  self.list = function()
    local s = store.list()
    local res = {}
    for i, filepath in ipairs(s) do
      res[i] = Path:new(filepath):make_relative()
    end
    return res
  end

  self.list_absolute = function()
    return store.list()
  end

  return self
end

return Mru
