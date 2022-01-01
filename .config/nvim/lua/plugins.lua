-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]]

local use = require('packer').use
require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Package manager

    -- Mapx (More elegant keymapping and commands)
    use "b0o/mapx.nvim"

    -- Telescope (Fuzzy Finder)
    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use 'nvim-telescope/telescope-fzy-native.nvim'

    -- Airline (Status Bar)
    use "vim-airline/vim-airline"

    -- Syntax checking
    use 'dense-analysis/ale'
    use 'sheerun/vim-polyglot'

    -- Git Stuff
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'

    -- Other stuff
    use "lukas-reineke/indent-blankline.nvim"
end)
require'mapx'.setup{ global = true }


-- Telescope
local actions = require("telescope.actions")
require('telescope').setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        prompt_prefix = '>',
    mappings = {
      i = {
          ["<esc>"] = actions.close,
      },
    },
  },
  extensions = {
      fzy_native = {
          override_generic_sorter = false,
          override_file_sorter = true,
      }
  }
}
require('telescope').load_extension('fzy_native')
nnoremap(';', 'isdirectory(\'.git\') ? \':lua require("telescope.builtin").git_files()<CR>\' : \':lua require("telescope.builtin").find_files()<CR>\'', {"silent", "expr"}
  )
nnoremap('<leader>;', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], "silent")
nnoremap('<leader>g', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], "silent")

-- ALE
vim.g.ale_fix_on_save = 1
vim.g.ale_linters = {
  python={'flake8', 'pylint'},
}
vim.g.ale_fixers = {
  python={'black'},
}

-- Indent-Blankline
vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

vim.opt.list = true

require("indent_blankline").setup {
    space_char_blankline = " ",
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
    },
}

-- Python
vim.g.python_highlight_all = 1

-- GitGutter
vim.signcolumn = true
