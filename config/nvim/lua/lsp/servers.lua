local pylsp = vim.lsp.config.pylsp
local old_before_init = pylsp and pylsp.before_init

---@type lsp.ClientCapabilities
local ty_capabilities = vim.lsp.protocol.make_client_capabilities()
ty_capabilities.textDocument.hover = nil

--- I use lspconfig, so these are just the overrides
---@type table<string, vim.lsp.Config>
local M = {
  bashls = {},
  clangd = {},
  lua_ls = {},
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            enabled = false,
          },
          pyflakes = {
            enabled = false,
          },
          mccabe = {
            enabled = false,
          },
          autopep8 = {
            enabled = false,
          },
          yapf = {
            enabled = false,
          },
          ruff = {
            enabled = false,
            formatEnabled = true,
            preview = true,
          },
          pylsp_mypy = {
            live_mode = true,
          },
        },
      },
    },
    before_init = function(init, config)
      local a = require "mason-core.async"
      local _ = require "mason-core.functional"

      vim.api.nvim_create_user_command(
        "PylspInstall",
        a.scope(function(opts)
          local notify = require "mason-lspconfig.notify"
          local pypi = require "mason-core.installer.managers.pypi"
          local process = require "mason-core.process"
          local spawn = require "mason-core.spawn"

          local plugins = opts.fargs
          local plugins_str = table.concat(plugins, ", ")
          notify(("Installing %s..."):format(plugins_str))
          local result = spawn.pip {
            "install",
            "-U",
            "--disable-pip-version-check",
            plugins,
            stdio_sink = process.StdioSink:new {
              stdout = vim.schedule_wrap(vim.notify),
              stderr = vim.schedule_wrap(function(string)
                vim.notify(string, vim.diagnostic.severity.ERROR)
              end),
            },
            with_paths = { pypi.venv_path(vim.fn.expand "$MASON/packages/python-lsp-server") },
          }
          if vim.in_fast_event() then
            a.scheduler()
          end
          result
              :on_success(function()
                notify(("Successfully installed pylsp plugins %s"):format(plugins_str))
              end)
              :on_failure(function()
                notify("Failed to install requested pylsp plugins.", vim.log.levels.ERROR)
              end)
        end),
        {
          desc = "[mason-lspconfig.nvim] Installs the provided packages in the same venv as pylsp.",
          nargs = "+",
          complete = _.always {
            "pyls-flake8",
            "pyls-isort",
            "pyls-memestra",
            "pyls-spyder",
            "pylsp-mypy",
            "pylsp-rope",
            "python-lsp-black",
            "python-lsp-ruff",
          },
        }
      )
      if old_before_init then
        old_before_init(init, config)
      end
    end
  },
  ruff = {},
  ty = {
    cmd = { "uvx", "ty", "server" },
    filetypes = { "python" },
    root_dir = vim.fs.root(0, { ".git/", "pyproject.toml", "ty.toml" }),
    -- init_options = {
    --   settings = {
    --     experimental = {
    --       completions = {
    --         enable = true,
    --       },
    --     },
    --   },
    -- },
    single_file_support = true,
    capabilities = ty_capabilities,
  },
}

return M
