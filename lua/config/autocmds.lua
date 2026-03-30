-- ══════════════════════════════════════════════════
-- Autocommands — comportamientos automáticos
-- ══════════════════════════════════════════════════
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ── Highlight on yank ─────────────────────────────
-- Feedback visual al copiar texto (flash amarillo)
local yank_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group    = yank_group,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- ── Resize splits al cambiar tamaño del terminal ──
autocmd("VimResized", {
  group    = augroup("ResizeSplits", { clear = true }),
  callback = function() vim.cmd("tabdo wincmd =") end,
})

-- ── Restaurar posición del cursor al reabrir ──────
autocmd("BufReadPost", {
  group    = augroup("RestoreCursor", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd('normal! g`"zz')
    end
  end,
})

-- ── Auto-close NvimTree si es el último buffer ────
autocmd("QuitPre", {
  group    = augroup("AutoCloseTree", { clear = true }),
  callback = function()
    local wins = vim.api.nvim_list_wins()
    local real_wins = vim.tbl_filter(function(w)
      local buf = vim.api.nvim_win_get_buf(w)
      return vim.bo[buf].filetype ~= "NvimTree"
    end, wins)
    if #real_wins == 0 then
      -- Cerrar NvimTree antes de salir para evitar E5565
      vim.cmd("NvimTreeClose")
    end
  end,
})

-- ── Eliminar trailing whitespace al guardar ───────
-- Solo en filetypes donde el formatter no lo maneja
autocmd("BufWritePre", {
  group   = augroup("TrimWhitespace", { clear = true }),
  pattern = { "*.lua", "*.go", "*.sh", "*.bash", "*.yaml", "*.yml", "*.toml" },
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- ── Filetypes: opciones específicas ───────────────
-- Markdown y text: wrap + spell
autocmd("FileType", {
  group   = augroup("FiletypeSettings", { clear = true }),
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap      = true
    vim.opt_local.spell     = true
    vim.opt_local.spelllang = "en,es"
  end,
})

-- Git commit: ancho de línea 72 chars (convención)
autocmd("FileType", {
  group   = augroup("GitCommitWidth", { clear = true }),
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.textwidth = 72
    vim.opt_local.colorcolumn = "73"
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#3c3836" })
  end,
})

-- ── Cerrar panels con q ────────────────────────────
-- Permite cerrar ventanas de ayuda, man, qf con solo q
autocmd("FileType", {
  group   = augroup("QuickClose", { clear = true }),
  pattern = {
    "help", "man", "qf", "lspinfo", "startuptime",
    "checkhealth", "query", "notify",
  },
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true })
  end,
})

-- ── Deshabilitar features en archivos grandes ─────
-- >500KB: sin syntax, LSP, ni treesitter para no congelar
autocmd("BufReadPre", {
  group    = augroup("BigFileSafety", { clear = true }),
  callback = function(args)
    local ok, stat = pcall(vim.uv.fs_stat, args.match)
    if ok and stat and stat.size > 500 * 1024 then
      vim.b.bigfile = true
      vim.opt_local.syntax      = "off"
      vim.opt_local.swapfile    = false
      vim.opt_local.undofile    = false
      vim.opt_local.foldmethod  = "manual"
      vim.schedule(function()
        vim.bo[args.buf].syntax = "off"
        vim.notify(
          "Big file (>" .. math.floor(stat.size / 1024) .. "KB) — features disabled",
          vim.log.levels.WARN
        )
      end)
    end
  end,
})
