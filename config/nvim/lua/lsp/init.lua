--- Stolen from LazyVims way of setting keymaps and adapted to my needs
--- I don't set keymaps for LSP other than in the corresponding keymaps file
--- and I don't need lazyloading yet.
local M = {}

local servers = require("lsp.servers")
for server, settings in pairs(servers) do
  vim.lsp.config(server, settings)
end
---@alias CoreKeymapPreNaming { [1]: string, [2]: string|function, [3]: string, mode?: string|string[], extra_opts?: vim.keymap.set.Opts}
---@alias LSPKeymapSpec CoreKeymapPreNaming|{has?:string|string[], specific_client?:string , cond?:fun():boolean}

---@param method string|string[]
local function an_active_client_has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if an_active_client_has(buffer, m) then
        return true
      end
    end
    return false
  end
  method = method:find("/") and method or "textDocument/" .. method
  local clients = vim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client:supports_method(method) then
      return true
    end
  end
  return false
end

---Sets all the contained LSP related keymaps depending on cond and has checks
---@param lsp_keymaps LSPKeymapSpec[]
---@return nil
local function set_lsp_keymaps(lsp_keymaps, bufnr)
  for _, keys in pairs(lsp_keymaps) do
    local has = not keys.has or an_active_client_has(bufnr, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))
    local specific_client = not keys.specific_client or vim.lsp.get_clients({ name = keys.specific_client })

    if has and cond and specific_client then
      ---@type vim.keymap.set.Opts
      local opts = { desc = "LSP: " .. keys[3] }
      if keys.extra_opts then
        opts = vim.tbl_extend("keep", opts, keys.extra_opts)
      end
      opts.buffer = bufnr
      vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
    end
  end
end

--- Set up LSP keymaps and autocommands for the given buffer
--- Stolen and modified from MariaSolOs' dotfiles on github
--- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/lsp.lua
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  ---@type LSPKeymapSpec[]

  local lsp_keymaps = require("lsp.keymaps")
  set_lsp_keymaps(lsp_keymaps, bufnr)
  -- I only ever use inlay hints in Rust an a few other languages
  -- Toggler from Snacks is configured
  vim.g.inlay_hints = false

  vim.lsp.document_color.enable(true, bufnr)
  if an_active_client_has(bufnr, "documentSymbol") then
    require("nvim-navic").attach(client, bufnr)
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Configure LSP keymaps",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      vim.error("I don't think this should ever be able to happen!")
      return
    end

    on_attach(client, args.buf)
  end,
})

return M
