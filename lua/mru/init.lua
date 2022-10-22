local M = {}

local AUGROUP = "mru__group"

local store

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

M.setup = function()
  store = {}

  local group = vim.api.nvim_create_augroup(AUGROUP, { clear = true })

  vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*",
    callback = function()
      local file = vim.fn.expand("<afile>")
      table.insert(store, 1, file)
    end,
    group = group,
  })
end

M.cleanup = function()
  vim.api.nvim_del_augroup_by_name(AUGROUP)
end

M.get = function()
  return store[1]
end

M.list = function()
  return remove_duplicates(store)
end

return M
