local FILES_TBL = "files"
local VIEWS_TBL = "views"

local Store = function(db)
  local self = {}

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
      string.format(
        [[

      INSERT INTO %s
          (filepath)   

      VALUES
          (:filepath)   

      ON CONFLICT(filepath) DO UPDATE
          SET count = count + 1 

      RETURNING id;

    ]],
        FILES_TBL
      ),
      { filepath = filepath }
    )
    db:insert(VIEWS_TBL, { file_id = res[1].id, timestamp = create_timestamp() })
  end

  self.list = function(opts)
    opts = vim.tbl_deep_extend("keep", opts or {}, { limit = 100, offset = 0 })

    local rows = db:eval(
      string.format(
        [[

    SELECT
        files.filepath, MAX(views.timestamp)

    FROM
        %s files

    INNER JOIN
        %s views
            ON files.id = views.file_id 

    GROUP BY files.filepath


    ORDER BY
        views.timestamp DESC

    LIMIT :limit OFFSET :offset;

    ]],
        FILES_TBL,
        VIEWS_TBL
      ),
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
