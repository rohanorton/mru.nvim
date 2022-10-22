local NOT_RUNNING_MSG = "MRU is not running. Run the setup function."
local NO_CLEANUP_MSG = "MRU is not running. Cleanup not necessary."

local NullMru = function(notify)
  notify = notify or vim.notify

  local self = {}

  local warn_not_running = function()
    notify(NOT_RUNNING_MSG, vim.log.levels.WARN)
  end

  local inform_cleanup_not_necessary = function()
    notify(NO_CLEANUP_MSG, vim.log.levels.INFO)
  end

  self.setup = function()
    error("Invariant Violation: setup should never be invoked")
  end

  self.cleanup = function()
    inform_cleanup_not_necessary()
  end

  self.get = function()
    warn_not_running()
  end

  self.get_absolute = function()
    warn_not_running()
  end

  self.list = function()
    warn_not_running()
  end

  self.list_absolute = function()
    warn_not_running()
  end

  return self
end

return NullMru
