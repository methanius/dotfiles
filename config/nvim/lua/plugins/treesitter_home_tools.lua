return {
  {
    "methanius/treesitter_home_tools.nvim",
    opts = {
      enable_toggle_boolean = true,
      create_usercommands = true,
    },
    cmd = {
      "ToggleNextBool",
      "TogglePreviousBool"
    },
    keys = {
      {
        "<leader>tb",
        "<Cmd>ToggleNextBool<Cr>",
        desc = "Toggle next boolean using Treesitter",
      },
      {
        "<leader>tB",
        "<Cmd>TogglePreviousBool<Cr>",
        desc = "Toggle previous boolean using Treesitter",
      }
    },
  },
}
