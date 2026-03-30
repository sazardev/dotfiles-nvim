-- ══════════════════════════════════════════════════
-- Git: Neogit (Magit-like) + Diffview
-- Leader: <Space>G
-- ══════════════════════════════════════════════════
return {

  -- ── Neogit — full git UI ────────────────────────
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd  = "Neogit",
    opts = {
      graph_style = "unicode",
      integrations = {
        telescope = true,
        diffview  = true,
      },
      signs = {
        hunk        = { "", "" },
        item        = { "", "" },
        section     = { "", "" },
      },
    },
    config = function(_, opts)
      require("neogit").setup(opts)

      -- Gruvbox palette
      vim.api.nvim_set_hl(0, "NeogitBranch",                 { fg = "#83a598", bold = true })
      vim.api.nvim_set_hl(0, "NeogitRemote",                 { fg = "#8ec07c", bold = true })
      vim.api.nvim_set_hl(0, "NeogitHunkHeader",             { fg = "#d65d0e", bg = "#282828", bold = true })
      vim.api.nvim_set_hl(0, "NeogitHunkHeaderHighlight",    { fg = "#fe8019", bg = "#3c3836", bold = true })
      vim.api.nvim_set_hl(0, "NeogitDiffAdd",                { fg = "#b8bb26", bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "NeogitDiffDelete",             { fg = "#fb4934", bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight",       { fg = "#b8bb26", bg = "#282828" })
      vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight",    { fg = "#fb4934", bg = "#282828" })
      vim.api.nvim_set_hl(0, "NeogitStagedChangesRegion",    { bg = "#282828" })
      vim.api.nvim_set_hl(0, "NeogitUnstagedChangesRegion",  { bg = "#282828" })
      vim.api.nvim_set_hl(0, "NeogitCursorLine",             { bg = "#3c3836" })
      vim.api.nvim_set_hl(0, "NeogitObjectId",               { fg = "#928374" })
      vim.api.nvim_set_hl(0, "NeogitCommitViewHeader",       { fg = "#fabd2f", bold = true })
    end,
  },

  -- ── Diffview — diff & file history ─────────────
  {
    "sindrets/diffview.nvim",
    cmd          = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        view = {
          default      = { layout = "diff2_horizontal" },
          file_history = { layout = "diff2_horizontal" },
        },
      })

      -- Gruvbox palette
      vim.api.nvim_set_hl(0, "DiffviewNormal",             { bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "DiffviewCursorLine",         { bg = "#3c3836" })
      vim.api.nvim_set_hl(0, "DiffviewFilePanelTitle",     { fg = "#d65d0e", bold = true })
      vim.api.nvim_set_hl(0, "DiffviewFilePanelCounter",   { fg = "#fabd2f" })
      vim.api.nvim_set_hl(0, "DiffviewFilePanelFileName",  { fg = "#ebdbb2" })
      vim.api.nvim_set_hl(0, "DiffviewFilePanelRootPath",  { fg = "#928374" })
      vim.api.nvim_set_hl(0, "DiffAdd",                    { bg = "#1e2b1a" })
      vim.api.nvim_set_hl(0, "DiffChange",                 { bg = "#2b2500" })
      vim.api.nvim_set_hl(0, "DiffDelete",                 { bg = "#2e1a1a" })
      vim.api.nvim_set_hl(0, "DiffText",                   { bg = "#3b3000", bold = true })
    end,
  },
}
