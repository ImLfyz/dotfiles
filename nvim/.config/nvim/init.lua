		       ----- Base -----
vim.opt.number = true
vim.opt.swapfile = false
vim.opt.mouse = "a"
vim.opt.list = false
vim.opt.listchars = { trail = '·', space = '·' }
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
local function center_ascii_art()
  if vim.fn.argc() > 0 or vim.bo.filetype ~= "" then
    return
  end

  local art = [[
  ___________    _____       _____    ______________  
|   ________|   \    \     /    /   |__________    |
|  |             \    \   /    /              /   /
|  |              \    \ /    /              /   / 
|  |_____          \         /              /   /  
|   _____|          \       /              /   /   
|  |                 \     /              /   /    
|  |                  |   |              /   /     
|  |                  |   |             /   /      
|  |                  |   |            /   /       
|  |                  |   |           /   /        
|  |                  |   |          /   /_________
|__|                  |___|         |______________|
]]

  local lines = vim.split(art, "\n")
  local win_width = vim.api.nvim_win_get_width(0)
  local win_height = vim.api.nvim_win_get_height(0)
  local centered_lines = {}
  for _, line in ipairs(lines) do
    local padding = math.max(0, math.floor((win_width - #line) / 2))
    table.insert(centered_lines, string.rep(" ", padding) .. line)
  end

  local top_padding = math.max(0, math.floor((win_height - #centered_lines) / 2))
  local final_lines = {}

  for _ = 1, top_padding do
    table.insert(final_lines, "")
  end

  vim.list_extend(final_lines, centered_lines)

  vim.api.nvim_buf_set_lines(0, 0, -1, false, final_lines)
  vim.opt_local.list = false
  vim.bo.buftype = 'nofile'
  vim.bo.swapfile = false
  vim.bo.modifiable = false
  vim.cmd('set nomodified')
end

vim.api.nvim_create_autocmd("UIEnter", {
  callback = center_ascii_art
})

require('core.plugins')
vim.cmd("colorscheme nord")
vim.cmd("highlight Normal guibg=NONE")
vim.cmd("highlight NonText guibg=NONE")

		      ----- Plugins -----

			---Nvim-tree---
require('plugins.nvim-tree')
vim.cmd("nnoremap <C-n> :NvimTreeToggle<CR>")
vim.cmd("nnoremap <leader>n :NvimTreeFindFile<CR>")
vim.keymap.set('n', '<Left>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<Right>', '<C-w>l', { silent = true })

			---Treesitter---
require('plugins.treesitter')
vim.cmd("hi Normal ctermbg=NONE guibg=NONE")
vim.cmd("hi LineNr ctermbg=NONE guibg=NONE")
vim.cmd("hi SignColumn ctermbg=NONE guibg=NONE")
vim.cmd("hi EndOfBuffer ctermbg=NONE guibg=NONE")

		      ---Airline (Themes)---
vim.cmd("let g:airline_powerline_fonts = 0")

			---Bufferline---
vim.keymap.set('n', '<S-Left>', '<Cmd>BufferLineCyclePrev<CR>', { silent = true })
vim.keymap.set('n', '<S-Right>', '<Cmd>BufferLineCycleNext<CR>', { silent = true })
vim.keymap.set('n', '<S-BS>', '<Cmd>bdelete!<CR>', { silent = true })
require('plugins.bufferline')
vim.cmd([[ highlight BufferLineFill guibg=#212121 ]])
vim.cmd([[ highlight BufferLineBackground guibg=#000000 ]])
vim.cmd([[ highlight BufferLineCloseButtonSelected guibg=#000000 ]])
vim.cmd([[ highlight BufferLineModifiedSelected guibg=#000000 guifg=#ffffff ]])
vim.cmd([[ highlight BufferLineModified guibg=#000000 guifg=#ffffff ]])
vim.cmd([[ highlight BufferLineCloseButton guibg=#000000 ]])
vim.cmd([[ highlight BufferLineBuffer guifg=#212121 ]])
vim.cmd([[ highlight BufferLineBufferSelected guifg=#ffffff ]])
vim.cmd([[ highlight BufferLineSeparatorSelected guifg=#212121 guibg=#000000 ]])
vim.cmd([[ highlight BufferLineSeparator guifg=#212121 guibg=#000000 ]])

			---CMP+LSP---

require('plugins.cmp')
require('plugins.lsp')
vim.cmd([[ highlight Pmenu guibg=#000000 ]])
vim.cmd([[ highlight PmenuSel guibg=#1e1e2e ]])
vim.cmd([[ highlight NormalFloat guibg=#000000 ]])
vim.cmd([[ highlight FloatBorder guibg=#000000 guifg=#212121 ]])
