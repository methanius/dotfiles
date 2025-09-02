--- Stolen from LazyVims way of setting keymaps and adapted to my needs
---
--- I don't set keymaps for LSP other than in the corresponding keymaps file
--- and I don't need lazyloading yet.
local M = {}

local servers = require("lsp.servers")
for server_name, settings in pairs(servers) do
  vim.lsp.config(server_name, settings)
  vim.lsp.enable(server_name)
end
---@alias CoreKeymapPreNaming { [1]: string, [2]: string|function, [3]: string, mode?: string|string[], extra_opts?: vim.keymap.set.Opts}
---@alias LSPKeymapSpec CoreKeymapPreNaming|{has?:string|string[], specific_client?:string , cond?:fun():boolean}

---@param method string|string[]
local function an_active_client_has(buffer, method)
  if type(method) == "table" then
    return vim.iter(method):all(function(m) return an_active_client_has(buffer, m) end)
  end
  local clients = vim.lsp.get_clients({ bufnr = buffer })
  return vim.iter(clients):any(function(client) return client:supports_method(method) end)
end

---Sets all the contained LSP related keymaps depending on cond and has checks
---@param lsp_keymaps LSPKeymapSpec[]
---@return nil
local function set_lsp_keymaps(lsp_keymaps, bufnr)
  for _, keys in pairs(lsp_keymaps) do
    local has = not keys.has or an_active_client_has(bufnr, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))
    local specific_client = not keys.specific_client or
        not vim.tbl_isempty(vim.lsp.get_clients({ name = keys.specific_client }))

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
  --
  -- I only ever use inlay hints in Rust an a few other languages
  -- Toggler from Snacks is configured
  vim.g.inlay_hints = false

  vim.lsp.document_color.enable(true, bufnr)

  vim.lsp.on_type_formatting.enable(true)

  if client.name == "clangd" then
    require("clangd_extensions")
  end
  if client.name == "ruff" then
    client.server_capabilities.hoverProvider = false
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

    if an_active_client_has(args.buf, "codeLens") then
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = args.buf,
        callback = vim.lsp.codelens.refresh,
      })
    end
  end,
})

return M
