local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
   {
     "nvim-tree/nvim-tree.lua",
     version = "*",
     lazy = false,
     dependencies = {
       "nvim-tree/nvim-web-devicons",
     },
     config = function()
       require("nvim-tree").setup {}
     end,
   },
   {
       "nvim-treesitter/nvim-treesitter",
       build = ":TSUpdate",
       config = function()
         require("nvim-treesitter").setup({
           highlight = { enable = true },
           indent = { enable = true }
         })
         vim.cmd [[ autocmd FileType * setlocal syntax= ]]
       end
   },
   {'vim-airline/vim-airline'},
   {'vim-airline/vim-airline-themes'},
   {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
   },
   {"shaunsingh/nord.nvim"},
   {'williamboman/mason.nvim'},
   {'williamboman/mason-lspconfig.nvim'},
   {'neovim/nvim-lspconfig'},
   {'hrsh7th/cmp-nvim-lsp'}, 
   {'hrsh7th/cmp-buffer'}, 
   {'hrsh7th/cmp-path'},
   {'hrsh7th/cmp-cmdline'}, 
   {'hrsh7th/nvim-cmp'}, 
   {'lewis6991/gitsigns.nvim'},
  }
})
