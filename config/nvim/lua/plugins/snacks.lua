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
      image = {},
    },
    keys = {
      { "<C-/>",      function() Snacks.terminal() end,                      desc = "Toggle terminal",                mode = { "n", "t" } },
      { "<leader>tt", function() Snacks.terminal() end,                      desc = "Toggle terminal",                mode = { "n", "t" } },
      { "<leader>un", function() Snacks.notifier.hide() end,                 desc = "Dismiss All Notifications" },
      { "<leader>gb", function() Snacks.git.blame_line() end,                desc = "Git Blame Line" },
      { "<leader>gl", function() Snacks.lazygit.log() end,                   desc = "Lazygit Log (cwd)" },
      { "<leader>ff", function() Snacks.picker.files() end,                  desc = "Fuzzy (f)ind (f)iles" },
      { "<leader>fg", function() Snacks.picker.git_files() end,              desc = "Fuzzy (g)it (f)iles" },
      { "<leader>fw", function() Snacks.picker.grep_word() end,              desc = "(w)ord under cursor ripgrep" },
      { "<leader>fl", function() Snacks.picker.grep() end,                   desc = "Live grep" },
      { "<leader>fh", function() Snacks.picker.help() end,                   desc = "Find help" },
      { "<leader>fa", function() Snacks.picker.resume() end,                 desc = "Resume search" },
      { "gr",         function() Snacks.picker.lsp_references() end,         desc = "References",                     nowait = true },
      { "gd",         function() Snacks.picker.lsp_definitions() end,        desc = "Goto Definition" },
      { "<leader>fd", function() Snacks.picker.diagnostics() end,            desc = "Diagnostics" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end,           desc = "(g)it (f)ile history" },
      { "<leader>fi", function() Snacks.picker.lines() end,                  desc = "(f)ind line (i)nside file" },
      { "<leader>fu", function() Snacks.picker.undo() end,                   desc = "(f)ind (u)ndo" },
      { "gt",         function() Snacks.picker.lsp_type_definitions() end,   desc = "Go to type defition" },
      { "<leader>fs", function() Snacks.picker.lsp_symbols() end,            desc = "(f)ind lsp (s)ymbols" },
      { "<leader>pe", function() Snacks.picker.explorer() end,               desc = "(p)roject (e)xplore with Snacks" },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
            border = "single",
          })
        end,
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

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
            "<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle({
            name = "Mini Diff Signs",
            get = function() return vim.g.minidiff_disable ~= true end,
            set = function(state)
              vim.g.minidiff_disable = not state
              if state then require("mini.diff").enable(0) else require("mini.diff").disable(0) end
              -- HACK: redraw to update the signs
              vim.defer_fn(function()
                vim.cmd([[redraw!]])
              end, 200)
            end,
          }):map("<leader>uG")
        end,
      })
    end,
  }
}
