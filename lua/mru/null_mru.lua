local NullMru = function()
  local self = {}

  self.setup = function() end

  self.cleanup = function() end

  self.get = function() end

  self.get_absolute = function() end

  self.list = function() end

  self.list_absolute = function() end

  return self
end

return NullMru
