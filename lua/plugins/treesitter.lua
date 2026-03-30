-- ══════════════════════════════════════════════════
-- Treesitter — syntax, context, textobjects
-- ══════════════════════════════════════════════════
return {
  -- ── Treesitter — syntax inteligente ────────────
  {
    "nvim-treesitter/nvim-treesitter",
    build        = ":TSUpdate",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = {
      ensure_installed = {
        "lua", "python", "javascript", "typescript", "tsx",
        "go", "gomod", "gosum", "gowork",
        "bash", "json", "jsonc", "yaml", "toml", "markdown", "markdown_inline",
        "html", "css", "astro",
        "dart", "java",
        "dockerfile", "terraform", "hcl",
        "proto", "sql",
        "regex", "vim", "vimdoc",
      },
      highlight    = { enable = true },
      indent       = { enable = true },
      auto_install = true,

      textobjects = {
        select = {
          enable    = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "outer function" },
            ["if"] = { query = "@function.inner", desc = "inner function" },
            ["ac"] = { query = "@class.outer",    desc = "outer class/struct" },
            ["ic"] = { query = "@class.inner",    desc = "inner class/struct" },
            ["aa"] = { query = "@parameter.outer", desc = "outer param" },
            ["ia"] = { query = "@parameter.inner", desc = "inner param" },
            ["ab"] = { query = "@block.outer",    desc = "outer block" },
            ["ib"] = { query = "@block.inner",    desc = "inner block" },
          },
        },
        move = {
          enable    = true,
          set_jumps = true,
          goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end       = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end   = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
        swap = {
          enable        = true,
          swap_next     = { ["<leader>sp"] = "@parameter.inner" },
          swap_previous = { ["<leader>sP"] = "@parameter.inner" },
        },
      },
    },
  },

  -- ── Treesitter Context — muestra scope actual ──
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts  = { max_lines = 3, trim_scope = "outer" },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      vim.api.nvim_set_hl(0, "TreesitterContext",           { bg = "#282828" })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#7c6f64", bg = "#282828" })
    end,
  },
}
