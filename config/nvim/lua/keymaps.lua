local keymaps = {}

function keymaps:set_all()
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
  keymap("<C-k>", "<CMD>cprev<CR>zz", "Go to prev item in the quickfix list and center cursor")
  keymap("<C-j>", "<CMD>cnext<CR>zz", "Go to next item in the quickfix list and center cursor")

  -- Quick load current file
  keymap("<leader><leader>", function() vim.cmd("so") end, "Shout out current file")


  -- Stay in visual mode when shifting in or out
  keymap("<", "<gv", "Stay in visual mode when indenting selection", "v")
  keymap(">", ">gv", "Stay in visual mode when indenting selection", "v")

  -- Open Lazy package manager
  keymap("<leader>L", "<CMD>Lazy<CR>", "Open Lazy")

  -- My own small hobby fun package
  keymap("<leader>tb", "<CMD>ToggleNextBool<CR>", "Toggle next boolean")
  keymap("<leader>tB", "<CMD>TogglePreviousBool<CR>", "Toggle previous boolean")

  -- Open current file position in Oil
  keymap("<leader>pv", "<CMD>Oil<CR>", "Open path to current buffer in Oil.nvim")

  -- Open neogit
  keymap("<leader>gg", "<CMD>Neogit<CR>", "Open Neogit for current project")

  -- Flash.nvim keymaps
  keymap("s", function() require("flash").jump() end, "Flash", { "n", "x", "o" })
  keymap("S", function() require("flash").treesitter() end, "Flash Treesitter", { "n", "x", "o" })
  keymap("r", function() require("flash").remote() end, "Remote Flash", "o")
  keymap("R", function() require("flash").treesitter_search() end, "Treesitter Search", { "o", "x" })
  keymap("<C-space>", function()
    require("flash").treesitter({
      actions = {
        ["<C-space>"] = "next",
        ["<BS>"] = "prev"
      },
      labels = ""
    })
  end, "Treesitter incremental selection using Flash", { "n", "x", "o" })


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
  keymap("<leader>ff", function() Snacks.picker.files() end, "Fuzzy (f)ind (f)iles")
  keymap("<leader>fg", function() Snacks.picker.git_files({ layout = { preset = "ivy" } }) end, "Fuzzy (g)it (f)iles")
  keymap("<leader>fw", function() Snacks.picker.grep_word({ layout = { preset = "ivy" } }) end,
    "(w)ord under cursor ripgrep")
  keymap("<leader>ft", function() Snacks.picker.grep({ layout = { preset = "ivy" } }) end, "Find Text Live")
  keymap("<leader>fh", function() Snacks.picker.help() end, "Find help")
  keymap("<leader>fa", function() Snacks.picker.resume() end, "Resume search")
  keymap("<leader>gf", function() Snacks.picker.git_log_file() end, "(g)it (f)ile history")
  keymap("<leader>gs", function() Snacks.picker.git_status() end, "(g)it status")
  keymap("<leader>gS", function() Snacks.picker.git_stash() end, "(g)it status")
  keymap("<leader>gd", function() Snacks.picker.git_diff() end, "(g)it status")
  keymap("<leader>gl", function() Snacks.picker.git_log() end, "(g)it log")
  keymap("<leader>fi", function() Snacks.picker.lines() end, "(f)ind line (i)nside file")
  keymap("<leader>fu", function() Snacks.picker.undo({ layout = { preset = "sidebar" } }) end, "(f)ind (u)ndo")
  keymap("<leader>fc", function() Snacks.picker.pick('files', { cwd = vim.fn.stdpath('config') }) end, "Find config file")
  keymap("<leader>pe", function() Snacks.picker.explorer() end, "(p)roject (e)xplore with Snacks")
  keymap("<leader>fm", function() Snacks.picker.marks({ layout = { preset = "ivy" } }) end, "Find marks")
  keymap("<leader>fr", function() Snacks.picker.recent({ layout = { preset = "ivy" } }) end, "Find recent")
  keymap("<leader>fb", function() Snacks.picker.dap_breakpoints() end, "Fin DAP Breakpoints")
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

  keymap("<leader>M", "<CMD>Mason<CR>", "Open Mason")

  -- Neogen keymaps, I've loved these for python
  keymap("<leader>nf", function() require("neogen").generate({ type = "func" }) end,
    "Neogen function docstring generation")
  keymap("<leader>nF", function() require("neogen").generate({ type = "file" }) end, "Neogen file docstring generation")
  keymap("<leader>nc", function() require("neogen").generate({ type = "class" }) end, "Neogen class docstring generation")
  keymap("<leader>nt", function() require("neogen").generate({ type = "type" }) end, "Neogen type docstring generation")
  keymap("<leader>ng", function() require("neogen").generate({}) end, "Neogen general docstring generation")

  -- DAP keymaps. Only just barely used these with a cruddy C++ project at a previous company
  keymap("<leader>dn", "<CMD>DapNew<CR>", "DAP New")
  keymap("<leader>db", function() require("dap").toggle_breakpoint() end, "DAP Breakpoint")
  keymap("<leader>dc", function() require("dap").continue() end, "DAP Continue")
  keymap("<leader>dC", function() require("dap").run_to_cursor() end, "DAP Run to Cursor")
  keymap("<leader>dr", function()
    local dap_view = require("dap-view")
    if require("dap-view.state").current_section == "repl" and vim.api.nvim_get_current_win() == require("dap-view.state").winnr then
      dap_view.close()
    else
      dap_view.open()
      if vim.bo.filetype == "python" then
        local parser = vim.treesitter.get_parser()
        if parser ~= nil then
          local tree = parser:parse()[1]
          local query = vim.treesitter.query.get(vim.bo.filetype, "polars_pandas_module")
          if query ~= nil then
            if vim.iter(query:iter_matches(tree:root(), vim.api.nvim_get_current_buf(), 0, -1)):next() and true or false then
              vim.api.nvim_win_set_height(require("dap-view.state").winnr, 23)
            end
          end
        end
      end
      dap_view.jump_to_view("repl")
      vim.api.nvim_set_current_win(require("dap-view.state").winnr)
    end
  end, "DAP REPL Toggle")
  keymap("<F10>", "<CMD>DapStepOver<CR>", " DAP Step Over")
  keymap("<leader>dj", "<CMD>DapStepOver<CR>", "DAP Step Over")
  keymap("<F11>", "<CMD>DapStepInto<CR>", "DAP Step Into")
  keymap("<leader>dl", "<CMD>DapStepInto<CR>", "DAP Step Into")
  keymap("<F12>", "<CMD>DapStepOut<CR>", "DAP Step Out")
  keymap("<leader>dh", "<CMD>DapStepOut<CR>", "DAP Step Out")
  keymap("<leader>dv", "<CMD>DapVirtualTextToggle<CR>", "Toggle (D)AP (V)irtual Text")
  keymap("<leader>du", function() require("dap-view").toggle() end, "Toggle dap view")
  keymap("<leader>dq", function() require("dap").terminate() end, "Dap Terminate")
  keymap("<leader>da", function()
    vim.notify("Rerunning last DAP conf", vim.log.levels.INFO)
    require("dap").run_last()
  end, "DAP rerun last")
  keymap("<leader>de", function()
    local mode = vim.api.nvim_get_mode().mode
    local stop = vim.fn.getpos(".")
    local start = vim.fn.getpos("v")
    local lines = vim.fn.getregion(start, stop, { type = mode })
    if lines == nil then
      return
    end
    local expression = table.concat(lines, "\n")
    require("dap.repl").execute(expression, { context = "repl" })
  end, "Execute selected text in DAP repl", "v")
  keymap("<leader>dE", "<CMD>DapEval<CR>", "Open Dap Eval buffer")
end

return keymaps
