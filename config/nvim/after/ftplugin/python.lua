vim.opt_local.shiftwidth = 4
vim.keymap.set(
  { "n", "i" },
  "<F5>",
  "<Cmd>w <bar> exec '!python '.shellescape('%')<CR>",
  { desc = "Save and run Python file" }
)

local function activate_venv()
  local venv_path = vim.fn.getcwd() .. "/.venv"
  if vim.fn.isdirectory(venv_path) == 1 then
    vim.env.virtual_env = venv_path
    vim.env.path = venv_path .. "/bin:" .. vim.env.PATH
    vim.g.python_venv = venv_path
    vim.notify("Activated Python virtual environment: " .. venv_path, vim.log.levels.INFO)
  end
end

if not vim.g.python_activated then
  activate_venv()
  vim.g.python_activated = true
end
