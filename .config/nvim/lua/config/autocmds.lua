-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Add to ~/.config/nvim/lua/config/autocmds.lua
local autocmd = vim.api.nvim_create_autocmd

-- Auto-reload files changed outside of Neovim
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      local bufnr = vim.api.nvim_get_current_buf()
      local modified = vim.api.nvim_buf_get_option(bufnr, "modified")

      if not modified then
        vim.cmd("checktime")
      end
    end
  end,
  desc = "Auto-reload buffers when files change externally",
})

-- Optional: Add notification when files have changed externally
autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
  end,
  desc = "Notification for reloaded buffers",
})
