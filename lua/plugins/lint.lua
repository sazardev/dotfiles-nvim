-- ══════════════════════════════════════════════════
-- nvim-lint — linting async (complementa al LSP)
-- Herramientas: golangci-lint (Go), eslint_d (JS/TS)
-- ══════════════════════════════════════════════════
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        go         = { "golangcilint" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      -- golangci-lint: configuración para que sea rápido
      lint.linters.golangcilint = {
        cmd     = "golangci-lint",
        stdin   = false,
        args    = {
          "run",
          "--out-format", "json",
          "--issues-exit-code=0",
          "--timeout=30s",
        },
        stream  = "stdout",
        ignore_exitcode = true,
        parser  = require("lint.linters.golangcilint").parser,
      }

      -- Lint al guardar y al leer (no en cada keystroke)
      local lint_augroup = vim.api.nvim_create_augroup("NvimLint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group    = lint_augroup,
        callback = function()
          -- No lintear en archivos grandes
          if vim.b.bigfile then return end
          lint.try_lint()
        end,
      })
    end,
  },
}
