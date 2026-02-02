-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Toggle clangd preprocessor define under cursor between =1 and =0
vim.api.nvim_create_user_command("ClangdToggle", function()
  local word = vim.fn.expand("<cword>")
  local clangd_path = vim.fn.getcwd() .. "/.clangd"

  -- Read existing file
  local defines = {}
  local file = io.open(clangd_path, "r")
  if file then
    for line in file:lines() do
      local name, val = line:match("-D(%w+)=(%d+)")
      if name then
        defines[name] = tonumber(val)
      end
    end
    file:close()
  end

  -- Toggle the macro
  defines[word] = (defines[word] == 1) and 0 or 1

  -- Write back
  file = io.open(clangd_path, "w")
  if file then
    file:write("CompileFlags:\n  Add:\n")
    for name, val in pairs(defines) do
      file:write(string.format("    - -D%s=%d\n", name, val))
    end
    file:close()
    vim.cmd("LspRestart")
    print(word .. "=" .. defines[word])
  end
end, {})

vim.keymap.set("n", "<leader>ct", "<cmd>ClangdToggle<cr>", { desc = "Toggle clangd define" })
