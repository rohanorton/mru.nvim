local mru = require("mru")
local f = string.format

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function mktemp(suffix)
  local res = vim.fn.system(f('mktemp -d --suffix="__%s"', suffix))
  return vim.fn.resolve(trim(res))
end

describe("MRU", function()
  describe("stores ", function()
    local test_dir, database_filepath, original_dir

    before_each(function()
      original_dir = vim.fn.getcwd()
      -- Create tmp dir
      test_dir = mktemp("mru.nvim")
      -- Make working dir?
      vim.api.nvim_set_current_dir(test_dir)
      -- Create some files
      vim.fn.system("touch test_file_1")
      vim.fn.system("touch test_file_2")
      vim.fn.system("touch test_file_3")
      -- Set db filepath variable
      database_filepath = test_dir .. "/.mru"
    end)

    after_each(function()
      mru.cleanup()
      -- Not sure if it's necessary, but reset working dir
      vim.api.nvim_set_current_dir(original_dir)
      -- Delete tmp dir
      vim.fn.system("rm -rf " .. test_dir)
    end)

    it("retrieves most recently used file", function()
      assert.same(nil, mru.list(), "Calling list without calling setup should return nothing")

      mru.setup({
        database_filepath = database_filepath,
      })

      vim.cmd("edit test_file_1 | bdelete")
      vim.cmd("edit test_file_2 | bdelete")
      vim.cmd("edit test_file_3 | bdelete")

      assert.same("test_file_3", mru.get(), "Get should return the most recently viewed file")

      vim.cmd("edit test_file_1 | bdelete")
      assert.same("test_file_1", mru.get(), "Get should return the most recently viewed file")

      assert.same({
        "test_file_1",
        "test_file_3",
        "test_file_2",
      }, mru.list(), "List files should return files in correct order")

      assert.same({
        test_dir .. "/test_file_1",
        test_dir .. "/test_file_3",
        test_dir .. "/test_file_2",
      }, mru.list_absolute(), "List Absolute should return absolute file paths")

      assert.same(test_dir .. "/test_file_1", mru.get_absolute(), "Get Absolute should return absolute path")

      vim.cmd("edit test_file_2")
      assert.same("test_file_1", mru.get(), "Should not get the file that is open.")
      vim.cmd("bdelete")
      assert.same("test_file_2", mru.get(), "Once the file closes, it should be listed")
    end)
  end)
end)
