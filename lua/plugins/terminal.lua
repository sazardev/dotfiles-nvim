-- ══════════════════════════════════════════════════
-- Terminal — ToggleTerm + LazyGit integrado
-- ══════════════════════════════════════════════════
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event   = "VeryLazy",
    opts    = {
      size = function(term)
        if term.direction == "horizontal" then return 15
        elseif term.direction == "vertical" then return math.floor(vim.o.columns * 0.4)
        end
      end,
      open_mapping    = [[<C-\>]],
      hide_numbers    = true,
      shade_terminals = false,
      start_in_insert = true,
      persist_mode    = true,
      direction       = "float",
      float_opts      = { border = "single", winblend = 0 },
      highlights      = { FloatBorder = { guifg = "#504945" } },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit  = Terminal:new({
        cmd        = "lazygit",
        hidden     = true,
        direction  = "float",
        float_opts = { border = "single" },
        on_open    = function() vim.cmd("startinsert!") end,
      })
      _LAZYGIT_TOGGLE = function() lazygit:toggle() end
    end,
  },
}
