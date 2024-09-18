return {
  {
    "folke/trouble.nvim",
    opts = function()
      vim.api.nvim_create_autocmd("QuickFixCmdPost", {
        callback = function()
          vim.cmd([[Trouble qflist open]])
        end,
      })

      local opts = {}

      return opts
    end,
    cmd = "Trouble",
    keys = {
      {
        "<leader>tt",
        function()
          require("trouble").toggle()
        end,
        desc = "Toggle Trouble list",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "[t",
        function()
          require("trouble").prev({ skip_groups = true, jump = true, })
        end,
        desc = "Go to prev item in the trouble list",
        mode = "n",
      },
      {
        "]t",
        function()
          ---@diagnostic disable-next-line: missing-fields
          require("trouble").next({ skip_groups = true, jump = true })
        end,
        desc = "Go to next item in the trouble list",
        mode = "n",
      },
    },
  },
}
