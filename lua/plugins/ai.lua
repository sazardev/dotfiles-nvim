-- ══════════════════════════════════════════════════
-- AI — GitHub Copilot (inline) + CopilotChat
-- ══════════════════════════════════════════════════
return {
  -- ── GitHub Copilot — sugerencias inline ─────────
  {
    "github/copilot.vim",
    cmd   = "Copilot",
    event = "InsertEnter",
  },

  -- ── CopilotChat — chat con contexto ─────────────
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event        = "VeryLazy",
    dependencies = { "github/copilot.vim", "nvim-lua/plenary.nvim" },
    opts = {
      window = {
        layout = "float",
        width  = 0.45,
        height = 0.85,
        border = "single",
      },
      show_help        = false,
      auto_insert_mode = false,
      mappings = {
        reset = { normal = "<C-x>", insert = "<C-x>" },
      },
    },
  },
}
