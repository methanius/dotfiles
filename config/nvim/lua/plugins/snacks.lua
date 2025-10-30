return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = {
      "nvim-mini/mini.diff",
      "mfussenegger/nvim-dap",
    },
    ---@type snacks.Config
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = "<Cmd>lua Snacks.dashboard.pick('files')<cr>" },
            { icon = " ", key = "n", desc = "New File", action = "<Cmd>ene | startinsert<cr>" },
            { icon = " ", key = "t", desc = "Find Text", action = "<Cmd>lua Snacks.dashboard.pick('live_grep')<cr>" },
            { icon = " ", key = "g", desc = "Open Neogit", action = "<Cmd>Neogit<cr>" },
            { icon = " ", key = "r", desc = "Recent Files", action = "<Cmd>lua Snacks.dashboard.pick('oldfiles')<cr>" },
            { icon = " ", key = "c", desc = "Config", action = "<Cmd>lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})<cr>" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = "<Cmd>Lazy<cr>", enabled = package.loaded.lazy ~= nil },
            { icon = "󱌣", key = "M", desc = "Mason", action = "<Cmd>Mason<cr>" },
            { icon = " ", key = "q", desc = "Quit", action = "<Cmd>qa<cr>" },
          },
        },
      },
      debug = {
        enabled = true,
      },
      notifier = {
        enabled = true,
      },
      gitbrowse = {
        enabled = true,
      },
      statuscolumn = {
        enabled = true,
      },
      picker = {
        enabled = true,
        sources = {
          dap_breakpoints = {
            title = "DAP Breakpoints",
            finder = function(_opts, _ctx)
              local breakpoints = require("dap.breakpoints").get()
              local index = 0
              local items = {}
              local current_buf = vim.api.nvim_get_current_buf()
              for buf_nr, lines_table in pairs(breakpoints) do
                local buf_name = vim.api.nvim_buf_get_name(buf_nr)
                for _, line_table in pairs(lines_table) do
                  local text = vim.trim(vim.api.nvim_buf_get_lines(buf_nr, line_table.line - 1, line_table.line, true)
                    [1])
                  index = index + 1
                  table.insert(items, {
                    file = buf_name,
                    idx = index,
                    text = text,
                    pos = { line_table.line, 0 },
                    score_add = (buf_nr == current_buf) and 1000 or 0,
                    line = text,
                    item = line_table,
                  })
                end
              end
              return items
            end,
            format = "file",
            preview = "file",
          }
        },
      },
      zen = {
        enabled = true,
      },
      image = {},
      rename = {
        enabled = true,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command
        end,
      })
    end,
  }
}
