local EventEmitter = function()
  local self = {}
  local listeners = {}

  local set_listeners = function(evt, val)
    listeners[evt] = val
  end

  local get_listeners = function(evt)
    if not listeners[evt] then
      listeners[evt] = {}
    end
    return listeners[evt]
  end

  self.add_listener = function(evt, fn)
    local scoped_listeners = get_listeners(evt)
    table.insert(scoped_listeners, fn)
  end

  self.on = self.add_listener

  self.prepend_listener = function(evt, fn)
    local scoped_listeners = get_listeners(evt)
    table.insert(scoped_listeners, 1, fn)
  end

  local once = function(evt, fn)
    local function self_removing_listener(...)
      self.remove_listener(evt, self_removing_listener)
      fn(...)
    end
    return self_removing_listener
  end

  self.once = function(evt, fn)
    local scoped_listeners = get_listeners(evt)
    table.insert(scoped_listeners, once(evt, fn))
  end

  self.prepend_once_listener = function(evt, fn)
    local scoped_listeners = get_listeners(evt)
    table.insert(scoped_listeners, 1, once(evt, fn))
  end

  self.emit = function(evt, ...)
    local scoped_listeners = get_listeners(evt)
    for _, fn in ipairs(scoped_listeners) do
      fn(...)
    end
  end

  self.remove_listener = function(evt, fn_to_remove)
    local scoped_listeners = get_listeners(evt)
    local filtered = {}
    for _, fn in ipairs(scoped_listeners) do
      if fn_to_remove ~= fn then
        table.insert(filtered, fn)
      end
    end
    set_listeners(evt, filtered)
  end

  self.remove_listener = self.remove_listener

  self.remove_all_listeners = function(evt)
    if evt then
      set_listeners(evt, {})
    else
      listeners = {}
    end
  end

  return self
end

return EventEmitter
