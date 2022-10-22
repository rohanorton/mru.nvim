local Path = require("plenary.path")

local AUGROUP = "mru__group"

local Mru = function(store)
  local self = {}

  self.setup = function()
    local group = vim.api.nvim_create_augroup(AUGROUP, { clear = true })

    vim.api.nvim_create_autocmd("BufRead", {
      pattern = "*",
      callback = function()
        local file = vim.fn.expand("<afile>:p")
        store.add(file)
      end,
      group = group,
    })
  end

  self.cleanup = function()
    vim.api.nvim_del_augroup_by_name(AUGROUP)
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
