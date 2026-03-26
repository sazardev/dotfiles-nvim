-- ══════════════════════════════════════════════════
-- Opciones — Neovim con estética Gruvbox minimalista
-- ══════════════════════════════════════════════════
local opt = vim.opt

-- UI
opt.number         = true
opt.relativenumber = true
opt.signcolumn     = "yes"
opt.cursorline     = true
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = true
opt.linebreak      = true        -- corta en palabras, no en medio
opt.termguicolors  = true
opt.showmode       = false       -- lo muestra lualine
opt.laststatus     = 3           -- statusline global
opt.cmdheight      = 1
opt.pumheight      = 10
opt.conceallevel   = 0
opt.splitbelow     = true
opt.splitright     = true
opt.fillchars      = { eob = " " }  -- oculta ~ al final del buffer

-- Indentado
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.expandtab      = true
opt.smartindent    = true
opt.shiftround     = true

-- Search
opt.ignorecase     = true
opt.smartcase      = true
opt.hlsearch       = false
opt.incsearch      = true

-- Files
opt.undofile       = true
opt.swapfile       = false
opt.backup         = false
opt.updatetime     = 200
opt.timeoutlen     = 300

-- Clipboard
opt.clipboard      = "unnamedplus"

-- Mouse
opt.mouse          = "a"
