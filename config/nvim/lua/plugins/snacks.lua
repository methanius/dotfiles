return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = {
      "echasnovski/mini.diff",
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
      lazygit = {
        enabled = true,
      },
      statuscolumn = {
        enabled = true,
      },
      picker = {
        enabled = true,
      },
      zen = {
        enabled = true,
      },
      image = {},
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
