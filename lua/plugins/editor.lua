-- ══════════════════════════════════════════════════
-- Editor — Telescope · Gitsigns · Which-key
--          Spectre · Flash · Trouble · Illuminate
--          Autopairs · Comment · Mini.surround
--          Neotest
-- ══════════════════════════════════════════════════
return {
  -- ── Telescope ──────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    cmd  = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = {
      defaults = {
        prompt_prefix    = "  ",
        selection_caret  = " ",
        sorting_strategy = "ascending",
        layout_config    = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
          width = 0.87, height = 0.80,
        },
        file_ignore_patterns = { "node_modules", ".git/", "target/", "__pycache__", ".dart_tool/" },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)

      -- Gruvbox palette completa para Telescope
      local bg     = "#1d2021"
      local bg2    = "#282828"
      local bg3    = "#3c3836"
      local fg     = "#ebdbb2"
      local fg_dim = "#a89984"
      local orange = "#d65d0e"
      local yellow = "#fabd2f"

      local hl = function(name, val) vim.api.nvim_set_hl(0, name, val) end

      hl("TelescopeNormal",          { bg = bg,  fg = fg })
      hl("TelescopePreviewNormal",   { bg = bg2, fg = fg })
      hl("TelescopeResultsNormal",   { bg = bg,  fg = fg })
      hl("TelescopePromptNormal",    { bg = bg2, fg = fg })
      hl("TelescopeBorder",          { bg = bg,  fg = bg3 })
      hl("TelescopePreviewBorder",   { bg = bg2, fg = bg3 })
      hl("TelescopeResultsBorder",   { bg = bg,  fg = bg3 })
      hl("TelescopePromptBorder",    { bg = bg2, fg = orange })
      hl("TelescopeTitle",           { bg = bg,  fg = fg_dim })
      hl("TelescopePreviewTitle",    { bg = bg2, fg = fg_dim })
      hl("TelescopeResultsTitle",    { bg = bg,  fg = fg_dim })
      hl("TelescopePromptTitle",     { bg = bg2, fg = orange, bold = true })
      hl("TelescopeSelection",       { bg = bg3, fg = fg, bold = true })
      hl("TelescopeSelectionCaret",  { bg = bg3, fg = orange, bold = true })
      hl("TelescopeMultiSelection",  { bg = bg3, fg = yellow })
      hl("TelescopeMatching",        { fg = yellow, bold = true })
      hl("TelescopePromptPrefix",    { bg = bg2, fg = orange, bold = true })
      hl("TelescopePromptCounter",   { bg = bg2, fg = fg_dim })
    end,
  },

  -- ── Autopairs ──────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts  = { check_ts = true },
  },

  -- ── Comment ────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    opts  = {},
  },

  -- ── Gitsigns — indicadores git en gutter ───────
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    opts  = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs  = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]h", gs.next_hunk,    "Next Hunk")
        map("n", "[h", gs.prev_hunk,    "Prev Hunk")
        map("n", "<leader>hs", gs.stage_hunk,   "Stage Hunk")
        map("n", "<leader>hr", gs.reset_hunk,   "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>hb", gs.blame_line,   "Blame Line")
        map("n", "<leader>hd", gs.diffthis,     "Diff This")
      end,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
      vim.api.nvim_set_hl(0, "GitSignsAdd",    { fg = "#b8bb26" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#fabd2f" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#fb4934" })
    end,
  },

  -- ── Which-key — grupos de atajos flat Gruvbox ──
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {
      win = {
        border  = "none",
        padding = { 1, 2 },
        wo      = { winblend = 0 },
      },
      layout    = { spacing = 5 },
      icons     = { separator = "→", group = "", breadcrumb = "›" },
      show_help = false,
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Colores Gruvbox flat (mismo bg que terminal)
      vim.api.nvim_set_hl(0, "WhichKey",          { fg = "#d65d0e", bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "WhichKeyDesc",      { fg = "#ebdbb2", bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "WhichKeyGroup",     { fg = "#83a598", bg = "#1d2021", bold = true })
      vim.api.nvim_set_hl(0, "WhichKeyNormal",    { bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "WhichKeyFloat",     { bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "WhichKeyBorder",    { fg = "#3c3836", bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "WhichKeySeparator", { fg = "#504945", bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "WhichKeyValue",     { fg = "#928374", bg = "#1d2021" })

      wk.add({
        { "<leader>a", group = "ai" },
        { "<leader>b", group = "buffer" },
        { "<leader>D", group = "debug" },
        { "<leader>d", group = "diagnostics" },
        { "<leader>f", group = "find" },
        { "<leader>F", group = "flutter" },
        { "<leader>G", group = "git" },
        { "<leader>g", group = "go" },
        { "<leader>H", group = "harpoon" },
        { "<leader>h", group = "git hunks" },
        { "<leader>l", group = "lsp / format" },
        { "<leader>r", group = "rename" },
        { "<leader>s", group = "search / replace" },
        { "<leader>S", group = "sessions" },
        { "<leader>T", group = "tests" },
        { "<leader>t", group = "terminal" },
        { "<leader>U", group = "ui toggles" },
        { "<leader>0", desc = "dashboard" },
      })
    end,
  },

  -- ── Spectre — search & replace global ──────────
  {
    "nvim-pack/nvim-spectre",
    cmd          = "Spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = {
      open_cmd       = "noswapfile vnew",
      color_devicons = true,
      highlight      = {
        ui      = "String",
        search  = "DiffChange",
        replace = "DiffDelete",
      },
    },
  },

  -- ── Mini surround — sa/sd/sr ─────────────────────
  {
    "echasnovski/mini.surround",
    event = "BufReadPost",
    opts  = {},
  },

  -- ── Flash — jump con etiquetas ─────────────────
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts  = {},
    keys  = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
    },
  },

  -- ── Trouble — panel de diagnósticos ────────────
  {
    "folke/trouble.nvim",
    cmd          = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts         = {},
    keys         = {
      { "<leader>dd", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics" },
      { "<leader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
    },
  },

  -- ── Todo Comments ───────────────────────────────
  {
    "folke/todo-comments.nvim",
    event        = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = {
      signs     = true,
      highlight = { multiline = false },
    },
  },

  -- ── Vim Illuminate — resalta ocurrencias ────────
  {
    "RRethy/vim-illuminate",
    event  = "BufReadPost",
    config = function()
      require("illuminate").configure({
        delay              = 200,
        filetypes_denylist = { "NvimTree", "Trouble", "lazy", "alpha" },
      })
      vim.api.nvim_set_hl(0, "IlluminatedWordText",  { bg = "#3c3836" })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead",  { bg = "#3c3836" })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#3c3836" })
    end,
  },

  -- ── Neotest — test runner (Go + Jest) ──────────
  {
    "nvim-neotest/neotest",
    cmd  = { "Neotest" },
    keys = { "<leader>Tt", "<leader>Tf", "<leader>Ts", "<leader>To" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-jest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go")({ experimental = { test_table = true } }),
          require("neotest-jest")({
            jestCommand    = "npx jest",
            jestConfigFile = "jest.config.ts",
            env            = { CI = "true" },
            cwd            = function() return vim.fn.getcwd() end,
          }),
        },
        output  = { open_on_run = true },
        summary = { open = "botright vsplit | vertical resize 40" },
        icons   = {
          running = "⟳", passed = "✓", failed = "✗", skipped = "○", unknown = "?",
        },
      })
    end,
  },
}
