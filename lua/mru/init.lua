local M = {}

local AUGROUP = "mru__group"

local store

M.setup = function()
  local group = vim.api.nvim_create_augroup(AUGROUP, { clear = true })

  vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*",
    callback = function()
      local file = vim.fn.expand("<afile>")
      store = file
    end,
    group = group,
  })
end

M.cleanup = function()
  vim.api.nvim_del_augroup_by_name(AUGROUP)
end

M.get = function()
  return store
end

return M
