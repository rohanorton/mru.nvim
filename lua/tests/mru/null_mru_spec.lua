local spy = require("luassert.spy")

local NullMru = require("mru.null_mru")

-- From vim.log.levels
local INFO = 2
local WARN = 3

-- Messages expected
local NOT_RUNNING_MSG = "MRU is not running. Run the setup function."
local NO_CLEANUP_MSG = "MRU is not running. Cleanup not necessary."

describe("NullMru", function()
  local uut, notify

  describe(".setup()", function()
    before_each(function()
      notify = spy.new(function() end)
      uut = NullMru(notify)
    end)

    it("throws error if invoked", function()
      assert.has_error(uut.setup, "Invariant Violation: setup should never be invoked")
    end)
  end)

  describe(".get()", function()
    before_each(function()
      notify = spy.new(function() end)
      uut = NullMru(notify)
    end)
    it("notifies user that mru not running", function()
      uut.get()
      assert.spy(notify).was.called_with(NOT_RUNNING_MSG, WARN)
    end)
  end)

  describe(".get_absolute()", function()
    before_each(function()
      notify = spy.new(function() end)
      uut = NullMru(notify)
    end)
    it("notifies user that mru not running", function()
      uut.get_absolute()
      assert.spy(notify).was.called_with(NOT_RUNNING_MSG, WARN)
    end)
  end)

  describe(".list()", function()
    before_each(function()
      notify = spy.new(function() end)
      uut = NullMru(notify)
    end)
    it("notifies user that mru not running", function()
      uut.list()
      assert.spy(notify).was.called_with(NOT_RUNNING_MSG, WARN)
    end)
  end)

  describe(".list_absolute()", function()
    before_each(function()
      notify = spy.new(function() end)
      uut = NullMru(notify)
    end)
    it("notifies user that mru not running", function()
      uut.list_absolute()
      assert.spy(notify).was.called_with(NOT_RUNNING_MSG, WARN)
    end)
  end)

  describe(".cleanup()", function()
    before_each(function()
      notify = spy.new(function() end)
      uut = NullMru(notify)
    end)

    it("notifies user that mru not running", function()
      uut.cleanup()
      assert.spy(notify).was.called_with(NO_CLEANUP_MSG, INFO)
    end)
  end)
end)
