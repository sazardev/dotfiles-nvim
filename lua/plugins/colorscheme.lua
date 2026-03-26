-- ══════════════════════════════════════════════════
-- Tema: Gruvbox Dark (oficial morhetz)
-- ══════════════════════════════════════════════════
return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings   = false,
          emphasis  = false,
          comments  = false,
          operators = false,
          folds     = false,
        },
        strikethrough = true,
        invert_selection  = false,
        invert_signs      = false,
        invert_tabline    = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "hard",   -- "hard" | "soft" | ""
        palette_overrides = {},
        overrides = {
          -- Fondo identico al terminal (kitty #1d2021)
          Normal          = { bg = "#1d2021" },
          NormalNC        = { bg = "#1d2021" },
          SignColumn      = { bg = "#1d2021" },
          LineNr          = { bg = "#1d2021" },
          CursorLineNr    = { bg = "#1d2021" },
          FoldColumn      = { bg = "#1d2021" },
          EndOfBuffer     = { bg = "#1d2021", fg = "#1d2021" },
          NvimTreeNormal  = { bg = "#1d2021" },
          NvimTreeEndOfBuffer = { bg = "#1d2021", fg = "#1d2021" },
        },
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.cmd("colorscheme gruvbox")
      vim.o.background = "dark"
    end,
  },
}
