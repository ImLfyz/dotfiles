require("nvim-treesitter").setup {
  ensure_installed = { "python" },

  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
}

vim.cmd([[ highlight @keyword     	guifg=#d13a2a ]])
vim.cmd([[ highlight @function     	guifg=#d4c744 ]])
vim.cmd([[ highlight @function.builtin  guifg=#d4c744 ]])
vim.cmd([[ highlight @variable     	guifg=#7a5fd9 ]])
vim.cmd([[ highlight @variable.builtin  guifg=#7a5fd9 ]])
vim.cmd([[ highlight @constant     	guifg=#c93c7d ]])
vim.cmd([[ highlight @string 		guifg=#139c06 ]])
vim.cmd([[ highlight @constant.builtin  guifg=#c93c7d ]])
vim.cmd([[ highlight @type              guifg=#7d291e ]])
vim.cmd([[ highlight @number       	guifg=#3a7bcf ]])
vim.cmd([[ highlight @operator     	guifg=#c9783a ]])
vim.cmd([[ highlight @comment      	guifg=#575757 ]])
vim.cmd([[ highlight @parameter    	guifg=#7a5fd9 ]])
vim.cmd([[ highlight @property     	guifg=#a62a5c ]])
vim.cmd([[ highlight @module       	guifg=#ffffff ]])
