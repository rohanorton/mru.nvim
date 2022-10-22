local Store = require("mru.store")
local Path = require("plenary.path")

local M = {}

local AUGROUP = "mru__group"

local store

M.setup = function()
  store = Store()

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

M.cleanup = function()
  vim.api.nvim_del_augroup_by_name(AUGROUP)
end

M.get = function()
  return Path.new(store.get()):make_relative()
end

M.get_absolute = function()
  return store.get()
end

M.list = function()
  local s = store.list()
  local res = {}
  for i, filepath in ipairs(s) do
    res[i] = Path:new(filepath):make_relative()
  end
  return res
end

M.list_absolute = function()
  return store.list()
end

return M
