return {
  "mbbill/undotree",
  lazy = false, -- Setting this explicitly, as the keys property sets it to true implicitly
  keys = {
    {
      "<leader>tu",
      vim.cmd.UndotreeToggle,
      desc = "Toggle undotree",
    },
  },
}
