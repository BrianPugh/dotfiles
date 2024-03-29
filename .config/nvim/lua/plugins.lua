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

    -- MapX (More elegant keymapping and commands)
    use "b0o/mapx.nvim"

    -- Telescope (Fuzzy Finder)
    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }

    -- Airline (Status Bar)
    use "vim-airline/vim-airline"

    -- Syntax highlighting
    use 'sheerun/vim-polyglot'

    -- Git Stuff
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'

    -- CoC (Conquer of Completion)
    use { 'neoclide/coc.nvim', branch='release' }
    use 'rafcamlet/coc-nvim-lua'
    use 'honza/vim-snippets'

    -- Rst
    use 'Rykka/riv.vim'
    --use 'Rykka/InstantRst'

    -- Other stuff
    use {"lukas-reineke/indent-blankline.nvim", commit='9637670896b68805430e2f72cf5d16be5b97a22a'}
end)
require'mapx'.setup{ global = true }


-- Telescope
local actions = require("telescope.actions")
require('telescope').setup {}
nnoremap(';', 'isdirectory(\'.git\') ? \':lua require("telescope.builtin").git_files()<CR>\' : \':lua require("telescope.builtin").find_files()<CR>\'', {"silent", "expr"}
  )
nnoremap('<leader>;', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], "silent")
nnoremap('\'', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], "silent")

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

-- GitGutter
vim.signcolumn = "number"

-- CoC  (see plugins/coc.vim)

-- Rst
