local Listener = function(group_name)
  local self = {}
  local handlers = {}

  self.setup = function()
    local group = vim.api.nvim_create_augroup(group_name, { clear = true })

    vim.api.nvim_create_autocmd("BufRead", {
      pattern = "*",
      callback = function()
        local file = vim.fn.expand("<afile>:p")
        for _, fn in ipairs(handlers) do
          fn(file)
        end
      end,
      group = group,
    })
  end

  self.cleanup = function()
    vim.api.nvim_del_augroup_by_name(group_name)
  end

  self.on_change = function(fn)
    table.insert(handlers, fn)
  end

  return self
end

return Listener
