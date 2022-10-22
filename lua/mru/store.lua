local Store = function()
  local self = {}
  local store = {}

  local function remove_duplicates(xs)
    local res = {}
    local seen = {}
    for _, value in ipairs(xs) do
      if not seen[value] then
        table.insert(res, value)
      end
      seen[value] = true
    end
    return res
  end

  self.add = function(file)
    table.insert(store, 1, file)
    store = remove_duplicates(store)
  end

  self.list = function()
    return store
  end

  self.get = function()
    return store[1]
  end

  return self
end

return Store
