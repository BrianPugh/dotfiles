HOME = os.getenv("HOME")

-- basic settings
vim.o.encoding = "utf-8"
vim.o.backspace = "indent,eol,start" -- backspace works on every char in insert mode
vim.o.completeopt = 'menuone,noselect'
vim.o.history = 1000
vim.o.startofline = true
vim.o.mouse = 'a'  -- Enable mouse
vim.o.pastetoggle='<F2>'  -- F2 to toggle paste mode

-- Clipboard
vim.o.clipboard = vim.o.clipboard .. 'unnamed'
vim.cmd([[set go+=a]])

-- Delete line without yanking
nnoremap('<leader>d', [["_d]])
xnoremap('<leader>d', [["_d]])

-- Tabs
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Sidebar
vim.o.number = true -- line number on the left
vim.o.numberwidth = 3 -- always reserve 3 spaces for line number
vim.o.signcolumn = 'yes' -- keep 1 column for coc.vim  check
vim.o.modelines = 0
vim.o.showcmd = true -- display command in bottom bar

-- Backup files
vim.o.backup = true -- use backup files
vim.o.writebackup = false
vim.o.swapfile = false -- do not use swap file
vim.o.undodir = HOME .. '/.vim/tmp/undo//'     -- undo files
vim.o.backupdir = HOME .. '/.vim/tmp/backup//' -- backups
vim.o.directory = '/.vim/tmp/swap//'   -- swap files

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Tabes and splits
nnoremap('t', ":tabe<CR>")

nnoremap('h', "<C-W>h")
nnoremap('j', "<C-W>j")
nnoremap('k', "<C-W>k")
nnoremap('l', "<C-W>l")

nnoremap('<C-h>', ":tabp<CR>")
nnoremap('<C-h>', ":tabp<CR>")
nnoremap('<C-l>', ":tabn<CR>")


-- File-specific
vim.cmd([[
  au FileType python                  set ts=4 sw=4
  au BufRead,BufNewFile *.md          set ft=mkd tw=80 syntax=markdown
  au BufRead,BufNewFile *.ppmd        set ft=mkd tw=80 syntax=markdown
  au BufRead,BufNewFile *.markdown    set ft=mkd tw=80 syntax=markdown
  au BufRead,BufNewFile *.slimbars    set syntax=slim
]])
