return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("harpoon"):setup()
    end,
    keys = {
      {
        "<leader>a",
        mode = { "n" },
        function()
          require("harpoon"):list():add()
        end,
        desc = "Append current file to Harpoon list",
      },
      {
        "<M-j>",
        mode = { "n" },
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon go to 1",
      },
      {
        "<M-k>",
        mode = { "n" },
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon go to 2",
      },
      {
        "<M-l>",
        mode = { "n" },
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon go to 3",
      },
      {
        "<M-;>",
        mode = { "n" },
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon go to 4",
      },
      {
        "<M-e>",
        mode = { "n" },
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon go to 4",
      },
    },
  },
}
