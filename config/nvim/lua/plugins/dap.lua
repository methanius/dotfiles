return {
  {
    "mfussenegger/nvim-dap",
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
      { "stevearc/overseer.nvim",          config = true },
      {
        "igorlfs/nvim-dap-view", lazy = false, opts = { winbar = { sections = { "console", "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" } } },
      },
      { "theHamsta/nvim-dap-virtual-text", opts = {} }
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require("dap-python").setup("uv")
    end
  },
}
