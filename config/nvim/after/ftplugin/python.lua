vim.opt_local.shiftwidth = 4
vim.keymap.set(
  { "n", "i" },
  "<F5>",
  "<Cmd>w <bar> exec '!python '.shellescape('%')<CR>",
  { desc = "Save and run Python file" }
)

local function activate_venv()
  local venv_path = vim.fn.getcwd() .. "/.venv"
  if vim.fn.isdirectory(venv_path) == 1 then
    vim.env.VIRTUAL_ENV = venv_path
    vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
    vim.g.python_venv = venv_path
    vim.notify("Activated Python virtual environment: " .. venv_path, vim.log.levels.INFO)
  end
end

if not vim.g.python_activated then
  activate_venv()
  vim.g.python_activated = true
end

local mypy = {}

local mypy_errorformat = table.concat({
  -- With --show-error-end:
  -- path.py:12:9:12:20: error: message
  "%f:%l:%c:%*\\d:%*\\d: %t%*[^:]: %m",

  -- With --show-column-numbers:
  -- path.py:12:9: error: message
  "%f:%l:%c: %t%*[^:]: %m",

  -- Without column numbers:
  -- path.py:12: error: message
  "%f:%l: %t%*[^:]: %m",

  -- Fallbacks.
  "%f:%l:%c:%*\\d:%*\\d: %m",
  "%f:%l:%c: %m",
  "%f:%l: %m",

  -- Ignore everything else, including "Success: no issues found ..."
  "%-G%.%#",
}, ",")

local function project_root()
  return vim.fs.root(0, {
    "pyproject.toml",
    "mypy.ini",
    ".mypy.ini",
    "setup.cfg",
    ".git",
  }) or vim.uv.cwd()
end

function mypy.run(args)
  args = args or {}

  local cmd = {
    "uv",
    "run",
    "mypy",
    "--show-column-numbers",
    "--show-absolute-path",
    "--no-error-summary",
    "--no-color-output",
  }

  if #args == 0 then
    table.insert(cmd, ".")
  else
    vim.list_extend(cmd, args)
  end

  vim.system(
    cmd,
    {
      text = true,
      cwd = project_root(),
    },
    function(result)
      local output = table.concat({
        result.stdout or "",
        result.stderr or "",
      }, "\n")

      local lines = vim.split(output, "\n", {
        plain = true,
        trimempty = true,
      })

      vim.schedule(function()
        vim.fn.setqflist({}, "r", {
          title = table.concat(cmd, " "),
          lines = lines,
          efm = mypy_errorformat,
        })

        local qf = vim.fn.getqflist()

        if #qf == 0 then
          vim.cmd.cclose()

          if result.code == 0 then
            vim.notify("mypy: no issues", vim.log.levels.INFO)
          else
            vim.notify(
              output ~= "" and output or "mypy failed without parseable output",
              vim.log.levels.ERROR
            )
          end

          return
        end

        vim.cmd.copen()
      end)
    end
  )
end

vim.api.nvim_create_user_command("Mypy", function(opts)
  mypy.run(opts.fargs)
end, {
  nargs = "*",
  complete = "file",
})

vim.keymap.set("n", "<leader>tm", function()
  mypy.run()
end, {
  desc = "Run mypy into quickfix",
})


local ruff = {}

local function normalize_filename(root, filename)
  if filename:match("^/") then
    return filename
  end

  return vim.fs.normalize(root .. "/" .. filename)
end

local function diagnostic_to_qf_item(root, diagnostic)
  local code = diagnostic.code or "Ruff"
  local message = diagnostic.message or ""

  local location = diagnostic.location or {}
  local end_location = diagnostic.end_location or location

  return {
    filename = normalize_filename(root, diagnostic.filename),
    lnum = location.row or 1,
    col = location.column or 1,
    end_lnum = end_location.row or location.row or 1,
    end_col = end_location.column or location.column or 1,
    text = string.format("%s: %s", code, message),
    type = "E",
  }
end

function ruff.run(args)
  args = args or {}

  local root = project_root()

  local cmd = {
    "uv",
    "run",
    "ruff",
    "check",
    "--output-format",
    "json",
  }

  if #args == 0 then
    table.insert(cmd, ".")
  else
    vim.list_extend(cmd, args)
  end

  vim.system(
    cmd,
    {
      text = true,
      cwd = root,
    },
    function(result)
      vim.schedule(function()
        local stdout = result.stdout or ""
        local stderr = result.stderr or ""

        local ok, diagnostics = pcall(vim.json.decode, stdout)

        if not ok or type(diagnostics) ~= "table" then
          vim.fn.setqflist({}, "r", {
            title = table.concat(cmd, " "),
            items = {},
          })

          vim.cmd.cclose()

          local message = stderr ~= "" and stderr or stdout

          if message == "" then
            message = "ruff failed without JSON output"
          end

          vim.notify(message, vim.log.levels.ERROR)
          return
        end

        local items = {}

        for _, diagnostic in ipairs(diagnostics) do
          table.insert(items, diagnostic_to_qf_item(root, diagnostic))
        end

        vim.fn.setqflist({}, "r", {
          title = table.concat(cmd, " "),
          items = items,
        })

        if #items == 0 then
          vim.cmd.cclose()

          if result.code == 0 then
            vim.notify("ruff: no issues", vim.log.levels.INFO)
          else
            vim.notify("ruff: no parseable issues", vim.log.levels.WARN)
          end

          return
        end

        vim.cmd.copen()
      end)
    end
  )
end

vim.api.nvim_create_user_command("RuffCheck", function(opts)
  ruff.run(opts.fargs)
end, {
  nargs = "*",
  complete = "file",
})

vim.keymap.set("n", "<leader>tr", function()
  ruff.run()
end, {
  desc = "Run ruff check into quickfix",
})
