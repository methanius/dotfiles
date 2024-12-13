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
}
