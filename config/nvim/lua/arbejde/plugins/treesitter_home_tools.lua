return {
  {
    "methanius/treesitter_home_tools.nvim",
    -- dir = "~/project/treesitter_home_tools.nvim",
    -- dev = true,
    config = function()
      local TSHTools = require("treesitter_home_tools")
      TSHTools.setup({ enable_toggle_boolean = true })
      vim.keymap.set("n", "<leader>tb", function()
        TSHTools.toggle_next_bool()
      end, {
        desc = "Toggle next boolean using Treesitter",
      })
      vim.keymap.set("n", "<leader>tB", function()
        TSHTools.toggle_previous_bool()
      end, {
        desc = "Toggle previous boolean using Treesitter",
      })
    end,
  },
}
