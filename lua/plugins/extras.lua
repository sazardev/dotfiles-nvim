-- ══════════════════════════════════════════════════
-- Extras: Harpoon · Undotree · Sessions · Rename
--         · Multi-cursor
-- ══════════════════════════════════════════════════
return {

  -- ── Snacks.nvim — utilidades folke ──────────────
  -- BigFile: deshabilita features en archivos >1MB
  -- Scratch: buffer temporal sin archivo  
  -- Notificaciones con historial (<Space>fn)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy     = false,
    opts     = {
      -- BigFile handler: ya lo tenemos en autocmds, snacks lo complementa
      bigfile  = { enabled = true, size = 1.5 * 1024 * 1024 },  -- 1.5 MB
      -- Scratch buffer temporal
      scratch  = { enabled = true },
      -- Notificaciones con historial
      notifier = {
        enabled = true,
        timeout = 3000,
        style   = "minimal",
      },
      -- Image preview en terminal Kitty
      image    = { enabled = true },
      -- Dashboard deshabilitado (usamos alpha)
      dashboard = { enabled = false },
      -- Input mejorado (reemplaza vim.ui.input)
      input    = { enabled = true },
    },
    keys = {
      { "<leader>fn", function() require("snacks").notifier.show_history() end, desc = "Notification History" },
      { "<leader>bs", function() require("snacks").scratch() end,              desc = "Scratch Buffer" },
    },
  },

  -- ── Better Escape — jk para salir de insert ─────
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts  = {
      timeout        = 150,    -- ms — sin lag perceptible
      default_mappings = false,
      mappings = {
        i = { j = { k = "<Esc>", j = "<Esc>" } },
        c = { j = { k = "<Esc>", j = "<Esc>" } },
      },
    },
  },

  -- ── Harpoon 2 — file bookmarks instantáneos ─────
  {
    "ThePrimeagen/harpoon",
    branch       = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        settings = {
          save_on_toggle   = true,
          sync_on_ui_close = true,
        },
      })

      -- Gruvbox highlights para el menú flotante
      vim.api.nvim_set_hl(0, "HarpoonWindow",       { bg = "#1d2021", fg = "#ebdbb2" })
      vim.api.nvim_set_hl(0, "HarpoonBorder",       { bg = "#1d2021", fg = "#d65d0e" })
      vim.api.nvim_set_hl(0, "HarpoonTitle",        { bg = "#1d2021", fg = "#d65d0e", bold = true })
      vim.api.nvim_set_hl(0, "HarpoonCurrentLine",  { bg = "#3c3836" })
    end,
  },

  -- ── Undotree — historial visual de undo ─────────
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = function()
      vim.g.undotree_WindowLayout       = 2     -- árbol + diff lado a lado
      vim.g.undotree_SplitWidth         = 35
      vim.g.undotree_DiffpanelHeight    = 12
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_ShortIndicators    = 1
    end,
  },

  -- ── Persistence — sesiones por proyecto ─────────
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts  = {
      dir     = vim.fn.stdpath("state") .. "/sessions/",
      options = { "buffers", "curdir", "tabpages", "winsize", "folds" },
    },
  },

  -- ── Inc-rename — rename con preview en vivo ─────
  {
    "smjonas/inc-rename.nvim",
    cmd    = "IncRename",
    config = function()
      require("inc_rename").setup({ input_buffer_type = "dressing" })
    end,
  },

  -- ── vim-visual-multi — múltiples cursores ────────
  {
    "mg979/vim-visual-multi",
    event = "BufReadPost",
    init  = function()
      -- Ctrl+N: seleccionar palabra bajo cursor / siguiente ocurrencia
      -- Ctrl+↑ / Ctrl+↓: añadir cursor arriba/abajo
      -- Tab: alternar cursor / extend mode
      -- Esc / q: salir
      vim.g.VM_maps = {
        ["Find Under"]         = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Add Cursor Down"]    = "<C-Down>",  -- reemplaza resize si prefieres
        ["Add Cursor Up"]      = "<C-Up>",
        ["Select All"]         = "<C-M-n>",
        ["Exit"]               = "<Esc>",
      }
      vim.g.VM_theme                  = "iceblue"
      vim.g.VM_highlight_matches      = "underline"
      vim.g.VM_show_warnings          = 0
    end,
  },
}
