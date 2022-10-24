local Path = require("plenary.path")

local Mru = function(store, listener)
  local self = {}

  self.setup = function()
    store.setup()
    listener.on_change(store.add)
    listener.setup()
  end

  self.cleanup = function()
    listener.cleanup()
  end

  self.get = function(opts)
    return Path.new(store.get(opts)):make_relative()
  end

  self.get_absolute = function(opts)
    return store.get(opts)
  end

  self.list = function(opts)
    local s = store.list(opts)
    local res = {}
    for i, filepath in ipairs(s) do
      res[i] = Path:new(filepath):make_relative()
    end
    return res
  end

  self.list_absolute = function(opts)
    return store.list(opts)
  end

  return self
end

return Mru
