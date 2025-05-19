-- Moving selections, might switch to mini.move later on
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines 1 line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines 1 line up" })

-- Nifty movement keymaps keeping the view centered
vim.keymap.set("n", "J", "mzJ`z", { desc = "Append line below to current line" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll half buffer down and center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll half buffer up and center cursor" })
vim.keymap.set("n", "n", "nzzzv",
  { desc = "Next item matching search, including in folds, keeping cursor centered in buffer" })
vim.keymap.set("n", "N", "Nzzzv",
  { desc = "Prev item matchin search, including in folds, keeping cursor centered in buffer" })

-- Easy delete without populating yank register
vim.keymap.set("n", "<leader>d", [["_d]], { desc = "Delete to void register" })

-- Quickfix jump keymaps with centering
-- ThePrimeagen inspired keymap that I quite like
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Go to prev item in the quickfix list and center cursor" })
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Go to next item in the quickfix list and center cursor" })

-- Quick load current file
vim.keymap.set("n", "<leader><leader>", function() vim.cmd("so") end, { desc = "Shout out current file" })


-- Stay in visual mode when shifting in or out
vim.keymap.set("v", "<", "<gv", { desc = "Stay in visual mode when indenting selection" })
vim.keymap.set("v", ">", ">gt hunkv", { desc = "Stay in visual mode when indenting selection" })

-- Open Lazy package manager
vim.keymap.set("n", "<leader>L", "<Cmd>Lazy<cr>", { desc = "Open Lazy" })

-- My own small hobby fun package
vim.keymap.set("n", "<leader>tb", "<Cmd>ToggleNextBool<cr>", { desc = "Toggle next boolean" })
vim.keymap.set("n", "<leader>tB", "<Cmd>TogglePreviousBool<Cr>", { desc = "Toggle previous boolean" })

-- Open current file position in Oil
vim.keymap.set("n", "<leader>pv", "<Cmd>Oil<CR>", { desc = "Open path to current buffer in Oil.nvim", })

-- Open neogit
vim.keymap.set("n", "<leader>gg", "<Cmd>Neogit<cr>", { desc = "Open Neogit for current project" })

-- Undotree toggle
vim.keymap.set("n", "<leader>tu", "<Cmd>UndotreeToggle<cr>", { desc = "Toggle undotree" })

-- Flash.nvim keymaps
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })


-- Create some toggle mappings using Snacks
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
Snacks.toggle.diagnostics():map("<leader>td")
Snacks.toggle.line_number():map("<leader>tl")
Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
  "<leader>tc")
Snacks.toggle.treesitter():map("<leader>tT")
Snacks.toggle.inlay_hints():map("<leader>th")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>tD")
Snacks.toggle.zen():map("<leader>tz")
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
}):map("<leader>tG")

-- Mini diff keymap
vim.keymap.set("n", "<leader>go", function() require("mini.diff").toggle_overlay(0) end,
  { desc = "Toggle mini.diff overlay", })

-- Snacks keymaps, there are quite a lot :p
vim.keymap.set({ "n", "t" }, "<C-/>", function() Snacks.terminal() end, { desc = "Toggle terminal" })
vim.keymap.set({ "n", "t" }, "<leader>tt", function() Snacks.terminal() end, { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>tn", function() Snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })
vim.keymap.set("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Git Blame Line" })
vim.keymap.set("n", "<leader>gl", function() Snacks.lazygit.log() end, { desc = "Lazygit Log (cwd)" })
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Fuzzy (f)ind (f)iles" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Fuzzy (g)it (f)iles" })
vim.keymap.set("n", "<leader>fw", function() Snacks.picker.grep_word() end, { desc = "(w)ord under cursor ripgrep" })
vim.keymap.set("n", "<leader>fl", function() Snacks.picker.grep() end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Find help" })
vim.keymap.set("n", "<leader>fa", function() Snacks.picker.resume() end, { desc = "Resume search" })
vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "(g)it (f)ile history" })
vim.keymap.set("n", "<leader>fi", function() Snacks.picker.lines() end, { desc = "(f)ind line (i)nside file" })
vim.keymap.set("n", "<leader>fu", function() Snacks.picker.undo() end, { desc = "(f)ind (u)ndo" })
vim.keymap.set("n", "<leader>fc", function() Snacks.picker.pick('files', { cwd = vim.fn.stdpath('config') }) end,
  { desc = "Find config file" })
vim.keymap.set("n", "<leader>pe", function() Snacks.picker.explorer() end, { desc = "(p)roject (e)xplore with Snacks" })
vim.keymap.set("n", "<leader>N",
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
  { desc = "Neovim News" }
)

-- Neogen keymaps, I've loved these for python
vim.keymap.set("n", "<leader>nm", function() require("neogen").generate({ type = "func" }) end,
  { desc = "Neogen function docstring generation" })
vim.keymap.set("n", "<leader>nc", function() require("neogen").generate({ type = "class" }) end,
  { desc = "Neogen class docstring generation" })
vim.keymap.set("n", "<leader>nt", function() require("neogen").generate({ type = "type" }) end,
  { desc = "Neogen type docstring generation" })
vim.keymap.set("n", "<leader>ng", function() require("neogen").generate({}) end, { desc = "Neogen docstring generation" })
vim.keymap.set("n", "<leader>nf", function() require("neogen").generate({ type = "file" }) end,
  { desc = "Neogen file docstring generation" })

-- DAP keymaps. Only just barely used these with a cruddy C++ project at a previous company
vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "DAP Breakpoints" })
vim.keymap.set("n", "<leader>ds",
  function()
    local widgets = require("dap.ui.widgets")
    widgets.centered_float(widgets.scopes, { border = "rounded" })
  end, { desc = "DAP Scopes" })
vim.keymap.set("n", "<F5>", "<CMD>DapContinue<CR>", { desc = "DAP Continue" })
vim.keymap.set("n", "<F10>", "<CMD>DapStepOver<CR>", { desc = "Step Over" })
vim.keymap.set("n", "<F11>", "<CMD>DapStepInto<CR>", { desc = "Step Into" })
vim.keymap.set("n", "<F12>", "<CMD>DapStepOut<CR>", { desc = "Step Out" })
vim.keymap.set("n", "<leader>dv", "<Cmd>DapVirtualTextToggle<Cr>", { desc = "Toggle (D)AP (V)irtual Text" })
