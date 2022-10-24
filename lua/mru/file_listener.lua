local EventEmitter = require("mru.event_emitter")

local CHANGE_EVT = "change"

local FileListener = function(group_name)
  local self = {}
  local event = EventEmitter()
  local last_file_registered

  local has_filename = function(file)
    return file and file ~= ""
  end

  local file_exists = function(file)
    return vim.fn.empty(vim.fn.glob(file)) == 0
  end

  local is_valid_file = function(file)
    return has_filename(file) and file ~= last_file_registered and file_exists(file)
  end

  local autocmd_callback = function()
    local file = vim.fn.expand("<afile>:p")
    if is_valid_file(file) then
      self.emit_change(file)
    end
  end

  self.setup = function()
    local group = vim.api.nvim_create_augroup(group_name, { clear = true })
    local events = { "BufLeave", "BufWritePost" }
    vim.api.nvim_create_autocmd(events, { pattern = "*", callback = autocmd_callback, group = group })
  end

  self.cleanup = function()
    pcall(vim.api.nvim_del_augroup_by_name, group_name)
    event = EventEmitter()
    last_file_registered = nil
  end

  self.on_change = function(fn)
    event.on(CHANGE_EVT, fn)
  end

  self.emit_change = function(file)
    last_file_registered = file
    event.emit(CHANGE_EVT, file)
  end

  return self
end

return FileListener
