return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "t", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "g", desc = "Open Neogit", action = "<leader>gg" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      debug = {
        enabled = true,
      },
      words = {
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
      }
    },
    keys = {
      { "gn",         function() Snacks.words.jump(vim.v.count1, true) end,  desc = "Jump to next LSP reference", mode = "n" },
      { "gN",         function() Snacks.words.jump(-vim.v.count1, true) end, desc = "Jump to next LSP reference", mode = "n" },
      { "<C-/>",      function() Snacks.terminal() end,                      desc = "Toggle terminal",            mode = { "n", "t" } },
      { "<leader>un", function() Snacks.notifier.hide() end,                 desc = "Dismiss All Notifications" },
      { "<leader>gb", function() Snacks.git.blame_line() end,                desc = "Git Blame Line" },
      { "<leader>gl", function() Snacks.lazygit.log() end,                   desc = "Lazygit Log (cwd)" },
      { "<leader>ff", function() Snacks.picker.files() end,                  desc = "Fuzzy (f)ind (f)iles" },
      { "<leader>fg", function() Snacks.picker.git_files() end,              desc = "Fuzzy (g)it (f)iles" },
      { "<leader>fw", function() Snacks.picker.grep_word() end,              desc = "(w)ord under cursor ripgrep" },
      { "<leader>fl", function() Snacks.picker.grep() end,                   desc = "Live grep" },
      { "<leader>fh", function() Snacks.picker.help() end,                   desc = "Find help" },
      { "<leader>fa", function() Snacks.picker.resume() end,                 desc = "Resume search" },
      { "gr",         function() Snacks.picker.lsp_references() end,         desc = "References",                 nowait = true },
      { "gd",         function() Snacks.picker.lsp_definitions() end,        desc = "Goto Definition" },
      { "<leader>fd", function() Snacks.picker.diagnostics() end,            desc = "Diagnostics" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end,           desc = "(g)it (f)ile history" },
      { "<leader>fi", function() Snacks.picker.lines() end,                  desc = "(f)ind line (i)nside file" },
      { "<leader>fu", function() Snacks.picker.undo() end,                   desc = "(f)ind (u)ndo" },
      { "gt",         function() Snacks.picker.lsp_type_definitions() end,   desc = "Go to type defition" },
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
        end,
      })
    end,
  }
}
