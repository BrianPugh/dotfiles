-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Toggle clangd preprocessor define under cursor between =1 and =0
-- Preserves other sections and non -D flags in .clangd
vim.api.nvim_create_user_command("ClangdToggle", function()
  local word = vim.fn.expand("<cword>")
  local clangd_path = vim.fn.getcwd() .. "/.clangd"

  -- Read existing file and parse structure
  local lines = {}
  local defines = {}
  local other_add_flags = {}
  local in_compile_flags = false
  local in_add_section = false
  local compile_flags_indent = nil
  local add_indent = nil

  local file = io.open(clangd_path, "r")
  if file then
    for line in file:lines() do
      local trimmed = line:match("^%s*(.-)%s*$")
      local indent = #(line:match("^(%s*)") or "")

      -- Track section transitions
      if trimmed == "CompileFlags:" then
        in_compile_flags = true
        compile_flags_indent = indent
        in_add_section = false
        table.insert(lines, { type = "compile_flags_header", content = line })
      elseif in_compile_flags and trimmed == "Add:" then
        in_add_section = true
        add_indent = indent
        table.insert(lines, { type = "add_header", content = line })
      elseif in_add_section and indent > add_indent then
        -- Inside Add section - check if it's a -D macro
        local name, val = line:match("-D(%w+)=(%d+)")
        if name then
          defines[name] = tonumber(val)
          -- Don't store in lines, we'll regenerate these
        else
          -- Non -D flag, preserve it
          table.insert(other_add_flags, line)
        end
      elseif trimmed:match("^%w+:$") and not trimmed:match("^-") then
        -- New top-level section (not a YAML list item)
        in_compile_flags = trimmed == "CompileFlags:"
        in_add_section = false
        table.insert(lines, { type = "other", content = line })
      elseif in_compile_flags and indent <= compile_flags_indent and trimmed ~= "" then
        -- Exited CompileFlags section
        in_compile_flags = false
        in_add_section = false
        table.insert(lines, { type = "other", content = line })
      elseif in_add_section and indent <= add_indent and trimmed ~= "" then
        -- Exited Add section but still in CompileFlags
        in_add_section = false
        table.insert(lines, { type = "other", content = line })
      else
        table.insert(lines, { type = "other", content = line })
      end
    end
    file:close()
  end

  -- Toggle the macro
  defines[word] = (defines[word] == 1) and 0 or 1

  -- Write back preserving structure
  file = io.open(clangd_path, "w")
  if file then
    local wrote_compile_flags = false
    local wrote_add = false

    for _, entry in ipairs(lines) do
      file:write(entry.content .. "\n")

      if entry.type == "add_header" then
        -- Write all -D macros after Add: header
        for name, val in pairs(defines) do
          file:write(string.format("    - -D%s=%d\n", name, val))
        end
        -- Write preserved non -D flags
        for _, flag_line in ipairs(other_add_flags) do
          file:write(flag_line .. "\n")
        end
        wrote_add = true
        wrote_compile_flags = true
      elseif entry.type == "compile_flags_header" then
        wrote_compile_flags = true
      end
    end

    -- If no CompileFlags section existed, create one
    if not wrote_compile_flags then
      file:write("CompileFlags:\n")
      file:write("  Add:\n")
      for name, val in pairs(defines) do
        file:write(string.format("    - -D%s=%d\n", name, val))
      end
    elseif not wrote_add then
      -- CompileFlags existed but no Add section - need to insert it
      -- For simplicity, append at end (user may need to reorganize)
      file:write("  Add:\n")
      for name, val in pairs(defines) do
        file:write(string.format("    - -D%s=%d\n", name, val))
      end
    end

    file:close()
    vim.cmd("LspRestart")
    print(word .. "=" .. defines[word])
  end
end, {})

vim.keymap.set("n", "<leader>ct", "<cmd>ClangdToggle<cr>", { desc = "Toggle clangd define" })
