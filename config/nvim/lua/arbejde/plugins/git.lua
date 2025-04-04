return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    keys = {
      {
        "<leader>gg",
        mode = "n",
        "<Cmd>Neogit<cr>",
        desc = "Open Neogit for current project",
      },
    },
    cmd = {
      "Neogit"
    },
  },
}
