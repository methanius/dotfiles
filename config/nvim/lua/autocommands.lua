local FileGroup = vim.api.nvim_create_augroup("FileGroup", { clear = true })

-- All files
vim.api.nvim_create_autocmd(
  "FileType",
  { desc = "Open files at last edited position", group = FileGroup, pattern = "*", command = 'silent! normal! g`"zv' }
)

vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions[1].type == "move" then
      Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
    end
  end,
})

---@param filetype string
---@return boolean
local function is_installed(filetype)
  for lang in vim.iter(require("nvim-treesitter").get_installed()) do
    if filetype == lang then
      return true
    end
  end
  return false
end

local function is_available(filetype)
  for lang in vim.iter(require("nvim-treesitter").get_available()) do
    if filetype == lang then
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd(
  "FileType",
  {
    callback = function()
      if not is_available(vim.bo.filetype) then
        return
      end
      if not is_installed(vim.bo.filetype) then
        require("nvim-treesitter").install(vim.bo.filetype):await(
          function()
            vim.treesitter.start()
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end

        )
      else
        vim.treesitter.start()
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end
  })
