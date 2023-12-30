-- [[ Install and set custom color scheme ]]
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd [[colorscheme catppuccin-mocha]]
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
