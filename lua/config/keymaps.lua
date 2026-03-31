-- ══════════════════════════════════════════════════
-- Keymaps — productividad máxima
-- ══════════════════════════════════════════════════
local map = vim.keymap.set

vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

-- ── Guardar / Salir ──────────────────────────────
map("n", "<leader>w",  "<cmd>w<cr>",    { desc = "Save" })
map("n", "<leader>q",  "<cmd>q<cr>",    { desc = "Quit" })
map("n", "<leader>Q",  "<cmd>qa!<cr>",  { desc = "Quit All" })

-- ── Ventanas ─────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Window Left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window Right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window Down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window Up" })
map("n", "<C-Up>",    "<cmd>resize +2<cr>",          { desc = "Height +" })
map("n", "<C-Down>",  "<cmd>resize -2<cr>",          { desc = "Height -" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Width -" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Width +" })

-- ── Buffers ──────────────────────────────────────
map("n", "<S-h>",      "<cmd>bprev<cr>",        { desc = "Prev Buffer" })
map("n", "<S-l>",      "<cmd>bnext<cr>",        { desc = "Next Buffer" })
map("n", "<leader>x",  "<cmd>bd<cr>",           { desc = "Close Buffer" })
map("n", "<leader>bx", "<cmd>bd<cr>",           { desc = "Close" })
map("n", "<leader>bw", "<cmd>w<cr><cmd>bd<cr>", { desc = "Save & Close" })
map("n", "<leader>bq", "<cmd>bd!<cr>",          { desc = "Close (no save)" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>",  { desc = "Close Others" })
map("n", "<leader>bs", function() require("snacks").scratch() end, { desc = "Scratch Buffer" })

-- ── Mover líneas en visual ───────────────────────
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- ── Scroll / Búsqueda centrada ───────────────────
map("n", "n",     "nzzzv")
map("n", "N",     "Nzzzv")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- ── Pegar sin perder registro ────────────────────
map("x", "<leader>p", '"_dP', { desc = "Paste (no yank)" })

-- ── Explorer ─────────────────────────────────────
map("n", "<leader>e",  "<cmd>NvimTreeToggle<cr>",  { desc = "File Explorer" })
map("n", "<leader>0",  "<cmd>Alpha<cr>",           { desc = "dashboard" })

-- ── Find / Telescope ─────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",           { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",            { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",              { desc = "Buffers" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",             { desc = "Recent Files" })
map("n", "<leader>fc", "<cmd>Telescope command_history<cr>",      { desc = "Command History" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Symbols" })
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>",                  { desc = "TODOs" })

-- ── Terminal / ToggleTerm ────────────────────────
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal size=15<cr>", { desc = "Terminal H" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical   size=60<cr>", { desc = "Terminal V" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",              { desc = "Terminal Float" })
map("n", "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<cr>",                   { desc = "LazyGit" })
map("t", "<Esc><Esc>", "<C-\\><C-n>",                                      { desc = "Exit Terminal" })

-- ── Search & Replace / Spectre ───────────────────
map("n", "<leader>sr", "<cmd>lua require('spectre').open()<cr>",                          { desc = "Search & Replace" })
map("n", "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", { desc = "Search Word" })
map("v", "<leader>sr", "<cmd>lua require('spectre').open_visual()<cr>",                   { desc = "Search Selection" })

-- ── AI / Copilot Chat ────────────────────────────
map("n", "<leader>ai", "<cmd>CopilotChatToggle<cr>",  { desc = "Chat Toggle" })
map("v", "<leader>ai", "<cmd>CopilotChatToggle<cr>",  { desc = "Chat Toggle" })
map("n", "<leader>ae", "<cmd>CopilotChatExplain<cr>", { desc = "Explain" })
map("v", "<leader>ae", "<cmd>CopilotChatExplain<cr>", { desc = "Explain" })
map("n", "<leader>af", "<cmd>CopilotChatFix<cr>",     { desc = "Fix" })
map("v", "<leader>af", "<cmd>CopilotChatFix<cr>",     { desc = "Fix" })
map("n", "<leader>ar", "<cmd>CopilotChatReview<cr>",  { desc = "Review" })
map("v", "<leader>ar", "<cmd>CopilotChatReview<cr>",  { desc = "Review" })

-- ── AI Local / Qwen (Ollama) ─────────────────────
-- Helper: open output in a bottom split (read-only scratch buffer)
local function ai_split(cmd)
  vim.cmd("botright 15new")
  vim.bo.buftype    = "nofile"
  vim.bo.bufhidden  = "wipe"
  vim.bo.modifiable = true
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "⏳ Thinking…" })
  vim.cmd("redraw")
  local result = vim.fn.systemlist(cmd)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, result)
  vim.bo.modifiable = false
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, desc = "Close" })
end

-- Helper: save visual selection to /tmp/qwen_ctx.txt
local function save_selection()
  vim.cmd("'<,'>w! /tmp/qwen_ctx.txt")
end

-- Helper: save current buffer to /tmp/qwen_ctx.txt
local function save_buffer()
  vim.cmd("w! /tmp/qwen_ctx.txt")
end

-- ── Qwen3 4b (quality) — <leader>aq* ─────────────
-- Generate code at cursor (4b)
map("n", "<leader>aqg", function()
  local prompt = vim.fn.input("󰚩 Qwen3 4b › ")
  if prompt == "" then return end
  vim.cmd("r !ai-code " .. vim.fn.shellescape(prompt))
end, { desc = "4b: Generate code" })

-- Replace selection with generated code (4b)
map("v", "<leader>aqg", function()
  local prompt = vim.fn.input("󰚩 Qwen3 4b › ")
  if prompt == "" then return end
  vim.cmd("'<,'>!ai-code " .. vim.fn.shellescape(prompt))
end, { desc = "4b: Replace selection" })

-- Explain selection (4b)
map("v", "<leader>aqe", function()
  save_selection()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --explain")
end, { desc = "4b: Explain selection" })

-- Explain current function/file (4b) — normal mode
map("n", "<leader>aqe", function()
  save_buffer()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --explain")
end, { desc = "4b: Explain file" })

-- Document selection — inserts doc block above (4b)
map("v", "<leader>aqd", function()
  save_selection()
  local start_line = vim.fn.line("'<")
  local doc = vim.fn.system("cat /tmp/qwen_ctx.txt | ai-code --doc")
  local lines = vim.split(doc, "\n")
  vim.api.nvim_buf_set_lines(0, start_line - 1, start_line - 1, false, lines)
end, { desc = "4b: Document selection" })

-- Document current file (4b) — normal mode, inserts at top
map("n", "<leader>aqd", function()
  save_buffer()
  local doc = vim.fn.system("cat /tmp/qwen_ctx.txt | ai-code --doc")
  local lines = vim.split(doc, "\n")
  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
end, { desc = "4b: Document file" })

-- Review selection (4b)
map("v", "<leader>aqr", function()
  save_selection()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --review")
end, { desc = "4b: Review selection" })

-- Review current file (4b) — normal mode
map("n", "<leader>aqr", function()
  save_buffer()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --review")
end, { desc = "4b: Review file" })

-- Ask anything about selection (4b)
map("v", "<leader>aqa", function()
  local prompt = vim.fn.input("󰚩 Ask › ")
  if prompt == "" then return end
  save_selection()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code " .. vim.fn.shellescape(prompt))
end, { desc = "4b: Ask about selection" })

-- Ask anything with file context (4b) — normal mode
map("n", "<leader>aqa", function()
  local prompt = vim.fn.input("󰚩 Ask (file ctx) › ")
  if prompt == "" then return end
  save_buffer()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code " .. vim.fn.shellescape(prompt))
end, { desc = "4b: Ask with file ctx" })

-- Fix selection with instruction (4b)
map("v", "<leader>aqf", function()
  local prompt = vim.fn.input("Fix: ")
  if prompt == "" then return end
  vim.cmd("'<,'>!ai-code --fix " .. vim.fn.shellescape(prompt))
end, { desc = "4b: Fix selection" })

-- ── Qwen3 0.6b (fast) — <leader>as* ──────────────
-- Quick generate at cursor (0.6b)
map("n", "<leader>asg", function()
  local prompt = vim.fn.input("⚡ Qwen3 0.6b › ")
  if prompt == "" then return end
  vim.cmd("r !ai-code --fast " .. vim.fn.shellescape(prompt))
end, { desc = "0.6b: Generate (fast)" })

-- Replace selection (0.6b)
map("v", "<leader>asg", function()
  local prompt = vim.fn.input("⚡ Qwen3 0.6b › ")
  if prompt == "" then return end
  vim.cmd("'<,'>!ai-code --fast " .. vim.fn.shellescape(prompt))
end, { desc = "0.6b: Replace (fast)" })

-- Explain selection (0.6b)
map("v", "<leader>ase", function()
  save_selection()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --fast --explain")
end, { desc = "0.6b: Explain selection" })

-- Explain current file (0.6b) — normal mode
map("n", "<leader>ase", function()
  save_buffer()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --fast --explain")
end, { desc = "0.6b: Explain file" })

-- Document selection (0.6b)
map("v", "<leader>asd", function()
  save_selection()
  local start_line = vim.fn.line("'<")
  local doc = vim.fn.system("cat /tmp/qwen_ctx.txt | ai-code --fast --doc")
  local lines = vim.split(doc, "\n")
  vim.api.nvim_buf_set_lines(0, start_line - 1, start_line - 1, false, lines)
end, { desc = "0.6b: Document selection" })

-- Document current file (0.6b) — normal mode, inserts at top
map("n", "<leader>asd", function()
  save_buffer()
  local doc = vim.fn.system("cat /tmp/qwen_ctx.txt | ai-code --fast --doc")
  local lines = vim.split(doc, "\n")
  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
end, { desc = "0.6b: Document file" })

-- Translate selection to English (0.6b)
map("v", "<leader>ast", function()
  save_selection()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --fast --translate")
end, { desc = "0.6b: Translate → English" })

-- Summarize selection (0.6b)
map("v", "<leader>ass", function()
  save_selection()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --fast --summarize")
end, { desc = "0.6b: Summarize selection" })

-- Summarize current file (0.6b) — normal mode
map("n", "<leader>ass", function()
  save_buffer()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --fast --summarize")
end, { desc = "0.6b: Summarize file" })

-- Review selection (0.6b)
map("v", "<leader>asr", function()
  save_selection()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --fast --review")
end, { desc = "0.6b: Review selection" })

-- Review current file (0.6b) — normal mode
map("n", "<leader>asr", function()
  save_buffer()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --fast --review")
end, { desc = "0.6b: Review file" })

-- Ask about selection (0.6b) — visual mode
map("v", "<leader>asa", function()
  local prompt = vim.fn.input("⚡ Ask › ")
  if prompt == "" then return end
  save_selection()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --fast " .. vim.fn.shellescape(prompt))
end, { desc = "0.6b: Ask about selection" })

-- Ask with file context (0.6b) — normal mode
map("n", "<leader>asa", function()
  local prompt = vim.fn.input("⚡ Ask (file ctx) › ")
  if prompt == "" then return end
  save_buffer()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --fast " .. vim.fn.shellescape(prompt))
end, { desc = "0.6b: Ask with file ctx" })

-- Explain function under cursor (0.6b) — uses treesitter to extract nearest function
map("n", "<leader>asf", function()
  local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
  local fn_text, insert_row
  if ok then
    local node = ts_utils.get_node_at_cursor()
    while node do
      local t = node:type()
      if t:find("function") or t:find("method") or t:find("func_decl") or t == "function_definition" then
        break
      end
      node = node:parent()
    end
    if node then
      local sr, _, er, _ = node:range()
      local lines = vim.api.nvim_buf_get_lines(0, sr, er + 1, false)
      fn_text = table.concat(lines, "\n")
      insert_row = sr
    end
  end
  if not fn_text then
    -- fallback: current paragraph
    vim.cmd("normal! {")
    local s = vim.fn.line(".")
    vim.cmd("normal! }")
    local e = vim.fn.line(".")
    local lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false)
    fn_text = table.concat(lines, "\n")
    insert_row = s - 1
  end
  local tmp = "/tmp/qwen_fn.txt"
  local f = io.open(tmp, "w")
  if f then f:write(fn_text) f:close() end
  ai_split("cat " .. tmp .. " | ai-code --fast --funcexplain")
end, { desc = "0.6b: Explain function" })

-- Explain selection as function (0.6b) — visual mode
map("v", "<leader>asf", function()
  save_selection()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --fast --funcexplain")
end, { desc = "0.6b: Explain selection as fn" })

-- Identify file architecture/purpose (0.6b) — normal mode
map("n", "<leader>asi", function()
  save_buffer()
  ai_split("cat /tmp/qwen_ctx.txt | ai-code --fast --identify")
end, { desc = "0.6b: Identify file purpose" })

-- What is this symbol? (word under cursor) — 0.6b quick lookup
map("n", "<leader>asw", function()
  local word = vim.fn.expand("<cword>")
  local ft   = vim.bo.filetype
  if word == "" then return end
  local prompt = "In " .. ft .. ", what is `" .. word .. "`? One sentence answer."
  ai_split("ai-code --fast --local " .. vim.fn.shellescape(prompt))
end, { desc = "0.6b: What is this symbol?" })

-- Quick question — factual, anti-hallucination (0.6b)
map("n", "<leader>asq", function()
  local prompt = vim.fn.input("⚡ Ask › ")
  if prompt == "" then return end
  ai_split("ai-code --fast --local " .. vim.fn.shellescape(prompt))
end, { desc = "0.6b: Quick question" })

-- ── Go (lenguaje) ────────────────────────────────
map("n", "<leader>gr", "<cmd>GoRun<cr>",          { desc = "Go Run" })
map("n", "<leader>gb", "<cmd>GoBuild<cr>",         { desc = "Go Build" })
map("n", "<leader>gt", "<cmd>GoTest<cr>",          { desc = "Go Test" })
map("n", "<leader>gT", "<cmd>GoTestFunc<cr>",      { desc = "Go Test Func" })
map("n", "<leader>gi", "<cmd>GoImports<cr>",       { desc = "Go Imports" })
map("n", "<leader>ga", "<cmd>GoAddTag<cr>",        { desc = "Go Add Tags" })
map("n", "<leader>gR", "<cmd>GoRemoveTags<cr>",    { desc = "Go Remove Tags" })
map("n", "<leader>ge", "<cmd>GoIfErr<cr>",         { desc = "Go If Err" })
map("n", "<leader>gf", "<cmd>GoFillStruct<cr>",    { desc = "Go Fill Struct" })
map("n", "<leader>gF", "<cmd>GoFillSwitch<cr>",    { desc = "Go Fill Switch" })
map("n", "<leader>gI", "<cmd>GoImpl<cr>",          { desc = "Go Impl Interface" })
map("n", "<leader>gA", "<cmd>GoAlt<cr>",           { desc = "Go Alt (test ↔ src)" })
map("n", "<leader>gg", "<cmd>GoGenerate<cr>",      { desc = "Go Generate" })
map("n", "<leader>gm", "<cmd>GoMod tidy<cr>",      { desc = "Go Mod Tidy" })
map("n", "<leader>gc", "<cmd>GoCoverage<cr>",      { desc = "Go Coverage" })

-- ── Git / Neogit ─────────────────────────────────
map("n", "<leader>G",  "<cmd>Neogit<cr>",                    { desc = "Git Status" })
map("n", "<leader>Gc", "<cmd>Neogit commit<cr>",             { desc = "Commit" })
map("n", "<leader>Gp", "<cmd>Neogit push<cr>",               { desc = "Push" })
map("n", "<leader>GP", "<cmd>Neogit pull<cr>",               { desc = "Pull" })
map("n", "<leader>Gb", "<cmd>Neogit branch<cr>",             { desc = "Branch" })
map("n", "<leader>Gl", "<cmd>Neogit log<cr>",                { desc = "Log" })
map("n", "<leader>Gd", "<cmd>DiffviewOpen<cr>",              { desc = "Diff (working tree)" })
map("n", "<leader>GD", "<cmd>DiffviewOpen HEAD~1<cr>",       { desc = "Diff HEAD~1" })
map("n", "<leader>Gf", "<cmd>DiffviewFileHistory %<cr>",     { desc = "File History" })
map("n", "<leader>GF", "<cmd>DiffviewFileHistory<cr>",       { desc = "Repo History" })
map("n", "<leader>Gx", "<cmd>DiffviewClose<cr>",             { desc = "Close Diff" })
map("n", "<leader>GA", function()
  vim.ui.input({ prompt = "Commit message: " }, function(msg)
    if msg and msg ~= "" then
      vim.fn.system("git add -A")
      vim.fn.system("git commit -m " .. vim.fn.shellescape(msg))
      vim.notify("✓ Committed: " .. msg, vim.log.levels.INFO)
    end
  end)
end, { desc = "Add All & Commit" })

-- Undo last commit (soft — keeps changes staged, like VS Code "Undo Last Commit")
map("n", "<leader>Gu", function()
  local out = vim.fn.system("git reset --soft HEAD~1 2>&1")
  vim.notify(out ~= "" and out or "✓ Undo last commit (changes kept staged)", vim.log.levels.INFO)
end, { desc = "Undo Last Commit" })

-- Fetch all remotes
map("n", "<leader>Ge", function()
  vim.notify("⟳ Fetching...", vim.log.levels.INFO)
  local out = vim.fn.system("git fetch --all --prune 2>&1")
  vim.notify(out ~= "" and out or "✓ Fetch complete", vim.log.levels.INFO)
end, { desc = "Fetch" })

-- Stash push (with optional message)
map("n", "<leader>Gs", function()
  vim.ui.input({ prompt = "Stash message (optional): " }, function(msg)
    local cmd = msg and msg ~= "" and ("git stash push -m " .. vim.fn.shellescape(msg)) or "git stash push"
    local out = vim.fn.system(cmd .. " 2>&1")
    vim.notify(out ~= "" and out or "✓ Stashed", vim.log.levels.INFO)
  end)
end, { desc = "Stash Push" })

-- Stash pop
map("n", "<leader>GS", function()
  local out = vim.fn.system("git stash pop 2>&1")
  vim.notify(out ~= "" and out or "✓ Stash popped", vim.log.levels.INFO)
end, { desc = "Stash Pop" })

-- Switch / checkout branch (picker from local branches)
map("n", "<leader>Gk", function()
  local branches = vim.fn.systemlist("git branch --format='%(refname:short)' 2>/dev/null")
  if vim.tbl_isempty(branches) then
    vim.notify("No branches found", vim.log.levels.WARN) return
  end
  vim.ui.select(branches, { prompt = "Switch to branch:" }, function(branch)
    if not branch then return end
    local out = vim.fn.system("git checkout " .. vim.fn.shellescape(branch) .. " 2>&1")
    vim.notify(out ~= "" and out or "✓ Switched to " .. branch, vim.log.levels.INFO)
  end)
end, { desc = "Switch Branch" })

-- Create new branch
map("n", "<leader>Gn", function()
  vim.ui.input({ prompt = "New branch name: " }, function(name)
    if not name or name == "" then return end
    local out = vim.fn.system("git checkout -b " .. vim.fn.shellescape(name) .. " 2>&1")
    vim.notify(out ~= "" and out or "✓ Created & switched to " .. name, vim.log.levels.INFO)
  end)
end, { desc = "New Branch" })

-- Delete branch (local, picker)
map("n", "<leader>Gq", function()
  local current = vim.fn.system("git branch --show-current"):gsub("\n", "")
  local branches = vim.fn.systemlist("git branch --format='%(refname:short)' 2>/dev/null")
  branches = vim.tbl_filter(function(b) return b ~= current end, branches)
  if vim.tbl_isempty(branches) then
    vim.notify("No other branches to delete", vim.log.levels.WARN) return
  end
  vim.ui.select(branches, { prompt = "Delete branch:" }, function(branch)
    if not branch then return end
    local out = vim.fn.system("git branch -d " .. vim.fn.shellescape(branch) .. " 2>&1")
    vim.notify(out, vim.log.levels.INFO)
  end)
end, { desc = "Delete Branch" })

-- Stage current file
map("n", "<leader>Gw", function()
  local file = vim.fn.expand("%")
  local out = vim.fn.system("git add " .. vim.fn.shellescape(file) .. " 2>&1")
  vim.notify(out ~= "" and out or "✓ Staged: " .. file, vim.log.levels.INFO)
end, { desc = "Stage Current File" })

-- Unstage all (git restore --staged .)
map("n", "<leader>GU", function()
  local out = vim.fn.system("git restore --staged . 2>&1")
  vim.notify(out ~= "" and out or "✓ All changes unstaged", vim.log.levels.INFO)
end, { desc = "Unstage All" })

-- Discard all working tree changes (like VS Code "Discard All Changes")
map("n", "<leader>GX", function()
  vim.ui.input({ prompt = "Discard ALL changes? Type 'yes' to confirm: " }, function(ans)
    if ans ~= "yes" then vim.notify("Cancelled", vim.log.levels.WARN) return end
    local out = vim.fn.system("git restore . 2>&1")
    vim.notify(out ~= "" and out or "✓ All changes discarded", vim.log.levels.INFO)
  end)
end, { desc = "Discard All Changes" })

-- Merge branch into current (picker)
map("n", "<leader>Gm", function()
  local current = vim.fn.system("git branch --show-current"):gsub("\n", "")
  local branches = vim.fn.systemlist("git branch --format='%(refname:short)' 2>/dev/null")
  branches = vim.tbl_filter(function(b) return b ~= current end, branches)
  if vim.tbl_isempty(branches) then
    vim.notify("No other branches to merge", vim.log.levels.WARN) return
  end
  vim.ui.select(branches, { prompt = "Merge into " .. current .. ":" }, function(branch)
    if not branch then return end
    local out = vim.fn.system("git merge " .. vim.fn.shellescape(branch) .. " 2>&1")
    vim.notify(out, vim.log.levels.INFO)
  end)
end, { desc = "Merge Branch" })

-- Push with --set-upstream if needed (force-friendly)
map("n", "<leader>GE", function()
  local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
  vim.notify("⟳ Pushing " .. branch .. "...", vim.log.levels.INFO)
  local out = vim.fn.system("git push --set-upstream origin " .. vim.fn.shellescape(branch) .. " 2>&1")
  vim.notify(out, vim.log.levels.INFO)
end, { desc = "Push (set upstream)" })

-- Show current branch name
map("n", "<leader>Gi", function()
  local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
  local status = vim.fn.system("git status --short"):gsub("\n$", "")
  vim.notify("Branch: " .. branch .. "\n" .. status, vim.log.levels.INFO)
end, { desc = "Status Info" })

-- ── Debug / DAP ──────────────────────────────────
map("n", "<leader>Db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", { desc = "Toggle Breakpoint" })
map("n", "<leader>Dc", "<cmd>lua require('dap').continue()<cr>",          { desc = "Continue" })
map("n", "<leader>Di", "<cmd>lua require('dap').step_into()<cr>",         { desc = "Step Into" })
map("n", "<leader>Do", "<cmd>lua require('dap').step_over()<cr>",         { desc = "Step Over" })
map("n", "<leader>Du", "<cmd>lua require('dapui').toggle()<cr>",          { desc = "DAP UI" })
map("n", "<leader>Dt", "<cmd>lua require('dap').terminate()<cr>",         { desc = "Terminate" })

-- ── Tests / Neotest ──────────────────────────────
map("n", "<leader>Tt", "<cmd>lua require('neotest').run.run()<cr>",                   { desc = "Run Nearest" })
map("n", "<leader>Tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", { desc = "Run File" })
map("n", "<leader>Ts", "<cmd>lua require('neotest').summary.toggle()<cr>",            { desc = "Summary" })
map("n", "<leader>To", "<cmd>lua require('neotest').output_panel.toggle()<cr>",       { desc = "Output" })

-- ── Harpoon ──────────────────────────────────────
map("n", "<leader>Ha", function() require("harpoon"):list():add() end,                           { desc = "Add File" })
map("n", "<leader>H",  function() local h = require("harpoon"); h.ui:toggle_quick_menu(h:list()) end, { desc = "Harpoon Menu" })
map("n", "<leader>H1", function() require("harpoon"):list():select(1) end,                       { desc = "File 1" })
map("n", "<leader>H2", function() require("harpoon"):list():select(2) end,                       { desc = "File 2" })
map("n", "<leader>H3", function() require("harpoon"):list():select(3) end,                       { desc = "File 3" })
map("n", "<leader>H4", function() require("harpoon"):list():select(4) end,                       { desc = "File 4" })
map("n", "<leader>Hn", function() require("harpoon"):list():next() end,                          { desc = "Next Harpoon" })
map("n", "<leader>Hp", function() require("harpoon"):list():prev() end,                          { desc = "Prev Harpoon" })

-- ── Undotree ──────────────────────────────────────
map("n", "<leader>u",  "<cmd>UndotreeToggle<cr>", { desc = "Undo Tree" })

-- ── Sessions / Persistence ────────────────────────
map("n", "<leader>Ss", function() require("persistence").save() end,              { desc = "Save Session" })
map("n", "<leader>Sr", function() require("persistence").load() end,              { desc = "Restore Session (cwd)" })
map("n", "<leader>Sl", function() require("persistence").load({ last = true }) end, { desc = "Load Last Session" })
map("n", "<leader>Sd", function() require("persistence").stop() end,              { desc = "Don't Save on Exit" })

-- ── UI Toggles ────────────────────────────────────
map("n", "<leader>Ui", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Inlay Hints" })

map("n", "<leader>Uf", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify("Format on save: " .. (vim.g.autoformat and "ON" or "OFF"), vim.log.levels.INFO)
end, { desc = "Format on Save" })

map("n", "<leader>Ub", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "Git Blame" })

map("n", "<leader>Uw", function()
  vim.o.wrap = not vim.o.wrap
  vim.notify("Word wrap: " .. (vim.o.wrap and "ON" or "OFF"), vim.log.levels.INFO)
end, { desc = "Word Wrap" })

map("n", "<leader>Un", function()
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Relative Numbers" })

map("n", "<leader>Uc", function()
  vim.o.conceallevel = vim.o.conceallevel == 0 and 2 or 0
end, { desc = "Conceal Level" })

-- ── LSP ──────────────────────────────────────────
map("n", "gd",         vim.lsp.buf.definition,      { desc = "Go to Definition" })
map("n", "gD",         vim.lsp.buf.declaration,      { desc = "Declaration" })
map("n", "gi",         vim.lsp.buf.implementation,   { desc = "Implementation" })
map("n", "gy",         vim.lsp.buf.type_definition,  { desc = "Type Definition" })
map("n", "gr",         vim.lsp.buf.references,       { desc = "References" })
map("n", "K",          vim.lsp.buf.hover,            { desc = "Hover Docs" })
map("i", "<C-s>",      vim.lsp.buf.signature_help,   { desc = "Signature Help" })
map("n", "<leader>ca", vim.lsp.buf.code_action,      { desc = "Code Action" })
map("n", "<leader>lf", function() require("conform").format({ async = true, lsp_fallback = true }) end, { desc = "Format File" })
map("n", "<leader>ls", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace Symbols" })
map("n", "[d",         vim.diagnostic.goto_prev,     { desc = "Prev Diagnostic" })
map("n", "]d",         vim.diagnostic.goto_next,     { desc = "Next Diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float,    { desc = "Line Diagnostics" })

-- Inc-rename (live preview en cmdline)
map("n", "<leader>rn", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Rename" })
