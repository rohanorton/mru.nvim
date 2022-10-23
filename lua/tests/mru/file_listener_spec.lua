local spy = require("luassert.spy")

local FileListener = require("mru.file_listener")

local f = string.format

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function mktemp(suffix)
  local res = vim.fn.system(f('mktemp -d --suffix="__%s"', suffix))
  return vim.fn.resolve(trim(res))
end

local TEST_GROUP_NAME = "MruTestingGroup"

describe("Listener", function()
  describe(".cleanup()", function()
    it("does not error if called twice", function()
      local uut = FileListener(TEST_GROUP_NAME)
      uut.cleanup()
      assert.Not.has_error(uut.cleanup)
    end)
  end)

  describe(".on_change()", function()
    local test_dir, original_dir, uut

    -- SETUP --

    original_dir = vim.fn.getcwd()
    -- Create tmp dir
    test_dir = mktemp("mru.nvim")
    -- Make working dir?
    vim.api.nvim_set_current_dir(test_dir)
    -- Create some files
    vim.fn.system("touch test_file_1 test_file_2 test_file_3")

    -- END SETUP --

    before_each(function()
      uut = FileListener(TEST_GROUP_NAME)
    end)

    after_each(function()
      pcall(uut.cleanup)
      vim.cmd("%bdelete")
    end)

    it("triggers event on file access", function()
      local handler = spy.new(function(arg) end)

      uut.on_change(handler)

      uut.setup()

      vim.cmd("edit test_file_1 | bdelete")

      assert.spy(handler).was.called_with(test_dir .. "/test_file_1")
    end)

    it("triggers event on new file write", function()
      local handler = spy.new(function(arg) end)

      uut.on_change(handler)

      uut.setup()

      vim.cmd("new")

      assert.spy(handler).was.not_called()

      vim.cmd("write test_file_new | bdelete")

      assert.spy(handler).was.called_with(test_dir .. "/test_file_new")
    end)

    it("triggers once if opening the same file", function()
      local handler = spy.new(function(arg) end)

      uut.on_change(handler)

      uut.setup()

      -- Open same file in buffer
      vim.cmd("e test_file_1")
      vim.cmd("e test_file_1")
      vim.cmd("e test_file_1")

      assert.spy(handler).was.called(1)
    end)

    it("triggers on file enter", function()
      local handler = spy.new(function(arg) end)

      uut.on_change(handler)

      uut.setup()

      -- Open file in buffer
      vim.cmd("e test_file_1")
      -- Open another file in buffer
      vim.cmd("e test_file_2")
      -- Navigate back to first buffer
      vim.cmd("e test_file_1")

      assert.spy(handler).was.called(3)
    end)

    it("does not trigger if file never saved", function()
      local handler = spy.new(function(arg) end)

      uut.on_change(handler)

      uut.setup()

      vim.cmd("e test_file_that_isnt_saved | bdelete")

      assert.spy(handler).was.not_called()
    end)

    it("does not trigger after cleanup", function()
      local handler = spy.new(function() end)
      uut.on_change(handler)

      uut.setup()

      uut.cleanup()

      vim.cmd("edit test_file_1 | bdelete")

      assert.spy(handler).was.not_called()
    end)

    -- TEARDOWN --

    -- Not sure if it's necessary, but reset working dir
    vim.api.nvim_set_current_dir(original_dir)
    -- Delete tmp dir
    vim.fn.system("rm -rf " .. test_dir)

    -- END TEARDOWN --
  end)
end)
