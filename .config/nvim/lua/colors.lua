vim.cmd[[highlight TabLine guibg=#000000]] -- Unselected Tabes
vim.cmd[[highlight TabLineSel guibg=#303030]]  -- Selected Tabe
vim.cmd[[highlight Visual guibg=#555555]]  -- Highlighted Text (used in Telescope)

vim.cmd[[highlight Pmenu guibg=#112C85]]  -- linked to floating dialogues

-- Gutter Stuff
vim.cmd[[highlight SignColumn guibg=#303030]] -- gutter
vim.cmd[[highlight GitGutterDelete guifg=#FF0000 guibg=#303030 gui=bold cterm=bold]] -- 
vim.cmd[[highlight GitGutterChange guifg=#0000FF guibg=#303030 gui=bold cterm=bold]] -- 
vim.cmd[[highlight GitGutterAdd guifg=#00FF00 guibg=#303030 cterm=bold]] -- 

-- CoC
vim.cmd[[highlight CocUnusedHighlight guibg=#505050]] -- 
