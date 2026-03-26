-- Deshabilitar providers irrelevantes (evita warnings en :checkhealth)
vim.g.loaded_perl_provider    = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_python3_provider = 0   -- quitar esta línea después de: sudo pacman -S python-pynvim

-- Node provider: neovim npm instalado en ~/.local
vim.g.node_host_prog = vim.fn.expand("~/.local/bin/neovim-node-host")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n" .. out, "ErrorMsg" } }, true, {})
    vim.cmd("qa!")
  end
end
vim.opt.rtp:prepend(lazypath)

require("config.options")
require("config.keymaps")

require("lazy").setup("plugins", {
  change_detection = { notify = false },
  ui = {
    border  = "single",
    backdrop = 100,
  },
  rocks = {
    enabled    = false,  -- deshabilita luarocks (no lo necesitamos)
    hererocks  = false,
  },
})
