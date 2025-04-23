return {
  "mbbill/undotree",
  cmd = {
    "UndotreeToggle",
    "UndotreeFocus",
    "UndotreeHide",
    "UndotreePersistUndo",
    "UndotreeShow",
  },
  keys = {
    {
      "<leader>tu",
      vim.cmd.UndotreeToggle,
      desc = "Toggle undotree",
    },
  },
}
