return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      -- Signs
      for _, group in pairs({
        "DapBreakpoint",
        "DapBreakpointCondition",
        "DapBreakpointRejected",
        "DapLogPoint",
      }) do
        vim.fn.sign_define(group, { text = "●", texthl = group })
      end

      local dap = require("dap")
      -- dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
      -- C, C++
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" },
      }

      dap.listeners.before.event_terminated.dap_view_config = function()
        require("dap-view").close()
      end
      dap.listeners.before.event_exited.dap_view_config = function()
        require("dap-view").close()
      end
    end,
    dependencies = {
      "mfussenegger/nvim-dap",
      { "stevearc/overseer.nvim", config = true },
      {
        "igorlfs/nvim-dap-view",
        ---@type dapview.Config
        opts = {
          winbar = {
            sections = {
              "console", "watches", "scopes", "exceptions", "threads", "repl",
            },
          },
          windows = {
            size = function(_pos)
              if vim.bo.filetype == "python" then
                local parser = vim.treesitter.get_parser()
                if parser ~= nil then
                  local tree = parser:parse()[1]
                  local query = vim.treesitter.query.get(vim.bo.filetype, "polars_pandas_module")
                  if query ~= nil then
                    if vim.iter(query:iter_matches(tree:root(), vim.api.nvim_get_current_buf(), 0, -1)):next() and true or false then
                      return 23
                    end
                  end
                end
              end
              return 0.25
            end
          }
        },
      },
      {
        "mfussenegger/nvim-dap-python",
        config = function()
          require("dap-python").setup("uv")
        end
      },
    },
    cmd = {
      "DapEval",
    }
  },
}
