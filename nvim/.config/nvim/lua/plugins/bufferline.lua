vim.opt.termguicolors = true
vim.opt.background = "dark"
require("bufferline").setup({
    options = {
      mode = "buffers",
      separator_style = "slant",
      always_show_bufferline = true,
      custom_filter = function(buf_number)
        local filetype = vim.bo[buf_number].filetype
        return filetype ~= "NvimTree"
      end,
      offsets = {
      {
          filetype = "NvimTree",
          text = " ",
          highlight = "BufferLineFill",
          text_align = "left"
      },
     }
    }
  })
