local has_sqlite, sqlite = pcall(require, "sqlite")
if not has_sqlite then
  error("This plugin requires sqlite.lua (https://github.com/tami5/sqlite.lua) " .. tostring(sqlite))
end

local FILES_TBL = "files"
local VIEWS_TBL = "views"

local Store = function(db_filename)
  local self = {}
  local db

  local pluck = function(key, xs)
    local res = {}
    for i, x in ipairs(xs) do
      res[i] = x[key]
    end
    return res
  end

  local create_timestamp = function()
    return math.floor(vim.loop.hrtime() / 100)
  end

  self.setup = function()
    db = sqlite:open(db_filename)

    if not db then
      vim.notify("MRU could not open database", vim.log.levels.ERROR)
      return
    end

    if db:exists(FILES_TBL) and db:exists(VIEWS_TBL) then
      return
    end

    db:create(FILES_TBL, {
      id = true,
      filepath = { type = "text", unique = true, required = true },
      count = { type = "int", required = true, default = 1 },
    })

    db:create(VIEWS_TBL, {
      id = true,
      file_id = { type = "int", reference = "files.id", required = true, on_delete = "cascade" },
      timestamp = { type = "int", required = true },
    })
  end

  self.add = function(filepath)
    local res = db:eval(
      [[
      INSERT INTO files 
          (filepath)   
      VALUES
          (:filepath)   

      ON CONFLICT(filepath) DO UPDATE
          SET count = count + 1 

      RETURNING id;
    ]],
      { filepath = filepath }
    )
    db:insert(VIEWS_TBL, { file_id = res[1].id, timestamp = create_timestamp() })
  end

  self.list = function(opts)
    opts = vim.tbl_deep_extend("keep", opts or {}, { limit = 100, offset = 0 })

    local rows = db:eval(
      [[

    SELECT
        f.filepath, MAX(v.timestamp)

    FROM
        files f

    INNER JOIN
        views v
            ON f.id = v.file_id 

    GROUP BY f.filepath


    ORDER BY
        v.timestamp DESC

    LIMIT :limit OFFSET :offset

    ]],
      {
        limit = tostring(opts.limit),
        offset = tostring(opts.offset),
      }
    )

    return pluck("filepath", rows)
  end

  self.get = function(opts)
    opts = vim.tbl_deep_extend("force", opts or {}, { limit = 1 })
    return self.list(opts)[1]
  end

  return self
end

return Store
