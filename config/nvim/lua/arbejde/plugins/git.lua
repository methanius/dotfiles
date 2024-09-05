return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true,
    keys = {
      {
        "<leader>gg",
        mode = "n",
        function()
          require("neogit").open()
        end,
        desc = "Open Neogit for current project",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function()
        vim.keymap.set("n", "<leader>hp", require("gitsigns").preview_hunk, { desc = "Preview git hunk" })
        vim.keymap.set("n", "<leader>hs", require("gitsigns").stage_hunk, { desc = "Stage git hunk" })
        vim.keymap.set("n", "<leader>hr", require("gitsigns").reset_hunk, { desc = "Reset git hunk" })
        vim.keymap.set("v", "<leader>hs", function()
          require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage git hunk" })
        vim.keymap.set("v", "<leader>hr", function()
          require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset git hunk" })
        vim.keymap.set("n", "<leader>hS", require("gitsigns").stage_buffer, { desc = "Stage buffer to git" })
        vim.keymap.set("n", "<leader>hu", require("gitsigns").undo_stage_hunk, { desc = "Undo stage git hunk" })
        vim.keymap.set("n", "<leader>hR", require("gitsigns").reset_buffer, { desc = "Git reset entire buffer" })
        vim.keymap.set("n", "<leader>hp", require("gitsigns").preview_hunk, { desc = "Preview git hunk" })
        vim.keymap.set("n", "<leader>gb", function()
          require("gitsigns").blame_line({ full = true })
        end, { desc = "Git blame line" })
        vim.keymap.set(
          "n",
          "<leader>tlb",
          require("gitsigns").toggle_current_line_blame,
          { desc = "Toggle git blame line" }
        )
        vim.keymap.set("n", "<leader>hd", require("gitsigns").diffthis, { desc = "Git diff this" })
        vim.keymap.set("n", "<leader>hD", function()
          require("gitsigns").diffthis("~")
        end, { desc = "Git diff all" })
        vim.keymap.set("n", "<leader>td", require("gitsigns").toggle_deleted, { desc = "Gitsigns toggle deleted" })
      end,
    },
  },
}
