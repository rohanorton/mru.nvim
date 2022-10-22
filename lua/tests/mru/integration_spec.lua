local mru = require("mru")

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

describe("MRU", function()
  describe("stores ", function()
    local test_dir, mru_file, original_dir

    before_each(function()
      original_dir = vim.fn.getcwd()
      -- Create tmp dir
      test_dir = trim(vim.fn.system('mktemp -d --suffix="--mru.nvim"'))
      -- Make working dir?
      vim.api.nvim_set_current_dir(test_dir)
      -- Create some files
      vim.fn.system("touch test_file_1")
      vim.fn.system("touch test_file_2")
      vim.fn.system("touch test_file_3")
      -- Set mru_file variable
      mru_file = test_dir .. "/.mru"
    end)

    after_each(function()
      mru.cleanup()
      -- Not sure if it's necessary, but reset working dir
      vim.api.nvim_set_current_dir(original_dir)
      -- Delete tmp dir
      vim.fn.system("rm -rf " .. test_dir)
    end)

    it("retrieves most recently used file", function()
      mru.setup({
        mru_file = mru_file,
      })

      vim.cmd("edit test_file_1 | bdelete")
      vim.cmd("edit test_file_2 | bdelete")
      vim.cmd("edit test_file_3 | bdelete")

      assert.same("test_file_3", mru.get())
    end)
  end)
end)
