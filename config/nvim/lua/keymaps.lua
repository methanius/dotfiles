---@param lhs string
---@param rhs string|function
---@param desc string
---@param mode? string|string[]
---@param extra_opts? vim.keymap.set.Opts
local function keymap(lhs, rhs, desc, mode, extra_opts)
  mode = mode or "n"
  local opts = { desc = desc }
  if extra_opts then
    opts = vim.tbl_extend("keep", opts, extra_opts)
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

keymap("<leader>a", function()
  require("treesitter_home_tools").increment_next_integer(vim.v.count1)
end, "Increment integer using TreeSitter", { "n", "v" })


-- Moving selections, might switch to mini.move later on
keymap("J", ":m '>+1<CR>gv=gv", "Move selected lines 1 line down", "v")
keymap("K", ":m '<-2<CR>gv=gv", "Move selected lines 1 line up", "v")

-- Nifty movement keymaps keeping the view centered
keymap("J", "mzJ`z", "Append line below to current line")
keymap("<C-d>", "<C-d>zz", "Scroll half buffer down and center cursor")
keymap("<C-u>", "<C-u>zz", "Scroll half buffer up and center cursor")
keymap("n", "nzzzv", "Next item matching search, including in folds, keeping cursor centered in buffer")
keymap("N", "Nzzzv", "Prev item matchin search, including in folds, keeping cursor centered in buffer")

-- Easy delete without populating yank register
keymap("<leader>d", [["_d]], "Delete to void register")

-- Quickfix jump keymaps with centering
-- ThePrimeagen inspired keymap that I quite like
keymap("<C-k>", "<cmd>cprev<CR>zz", "Go to prev item in the quickfix list and center cursor")
keymap("<C-j>", "<cmd>cnext<CR>zz", "Go to next item in the quickfix list and center cursor")

-- Quick load current file
keymap("<leader><leader>", function() vim.cmd("so") end, "Shout out current file")


-- Stay in visual mode when shifting in or out
keymap("<", "<gv", "Stay in visual mode when indenting selection", "v")
keymap(">", ">gt hunkv", "Stay in visual mode when indenting selection", "v")

-- Open Lazy package manager
keymap("<leader>L", "<Cmd>Lazy<cr>", "Open Lazy")

-- My own small hobby fun package
keymap("<leader>tb", "<Cmd>ToggleNextBool<cr>", "Toggle next boolean")
keymap("<leader>tB", "<Cmd>TogglePreviousBool<Cr>", "Toggle previous boolean")

-- Open current file position in Oil
keymap("<leader>pv", "<Cmd>Oil<CR>", "Open path to current buffer in Oil.nvim")

-- Open neogit
keymap("<leader>gg", "<Cmd>Neogit<cr>", "Open Neogit for current project")

-- Undotree toggle
keymap("<leader>tu", "<Cmd>UndotreeToggle<cr>", "Toggle undotree")

-- Flash.nvim keymaps
keymap("s", function() require("flash").jump() end, "Flash", { "n", "x", "o" })
keymap("S", function() require("flash").treesitter() end, "Flash Treesitter", { "n", "x", "o" })
keymap("r", function() require("flash").remote() end, "Remote Flash", "o")
keymap("R", function() require("flash").treesitter_search() end, "Treesitter Search", { "o", "x" })


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
keymap("<leader>go", function() require("mini.diff").toggle_overlay(0) end, "Toggle mini.diff overlay")

-- Snacks keymaps, there are quite a lot :p
keymap("<C-/>", function() Snacks.terminal() end, "Toggle terminal", { "n", "t" })
keymap("<leader>tt", function() Snacks.terminal() end, "Toggle terminal", { "n", "t" })
keymap("<leader>tn", function() Snacks.notifier.hide() end, "Dismiss All Notifications")
keymap("<leader>gb", function() Snacks.git.blame_line() end, "Git Blame Line")
keymap("<leader>gl", function() Snacks.lazygit.log() end, "Lazygit Log (cwd)")
keymap("<leader>ff", function() Snacks.picker.files() end, "Fuzzy (f)ind (f)iles")
keymap("<leader>fg", function() Snacks.picker.git_files() end, "Fuzzy (g)it (f)iles")
keymap("<leader>fw", function() Snacks.picker.grep_word() end, "(w)ord under cursor ripgrep")
keymap("<leader>fl", function() Snacks.picker.grep() end, "Live grep")
keymap("<leader>fh", function() Snacks.picker.help() end, "Find help")
keymap("<leader>fa", function() Snacks.picker.resume() end, "Resume search")
keymap("<leader>gf", function() Snacks.picker.git_log_file() end, "(g)it (f)ile history")
keymap("<leader>fi", function() Snacks.picker.lines() end, "(f)ind line (i)nside file")
keymap("<leader>fu", function() Snacks.picker.undo() end, "(f)ind (u)ndo")
keymap("<leader>fc", function() Snacks.picker.pick('files', { cwd = vim.fn.stdpath('config') }) end, "Find config file")
keymap("<leader>pe", function() Snacks.picker.explorer() end, "(p)roject (e)xplore with Snacks")
keymap("<leader>N", function()
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
  "Neovim News"
)

-- Neogen keymaps, I've loved these for python
keymap("<leader>nm", function() require("neogen").generate({ type = "func" }) end, "Neogen function docstring generation",
  "n")
keymap("<leader>nc", function() require("neogen").generate({ type = "class" }) end, "Neogen class docstring generation",
  "n")
keymap("<leader>nt", function() require("neogen").generate({ type = "type" }) end, "Neogen type docstring generation",
  "n")
keymap("<leader>ng", function() require("neogen").generate({}) end, "Neogen file docstring generation")

-- DAP keymaps. Only just barely used these with a cruddy C++ project at a previous company
keymap("<leader>db", function() require("dap").toggle_breakpoint() end, "DAP Continue")
keymap("<F10>", "<CMD>DapStepOver<CR>", "Step Over")
keymap("<F11>", "<CMD>DapStepInto<CR>", "Step Into")
keymap("<F12>", "<CMD>DapStepOut<CR>", "Step Out")
keymap("<leader>dv", "<Cmd>DapVirtualTextToggle<Cr>", "Toggle (D)AP (V)irtual Text")
