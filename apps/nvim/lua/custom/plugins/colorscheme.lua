-- [[ Install and set custom color scheme ]]
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd [[colorscheme tokyonight-night]]
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
  },
}

-- vim: ts=2 sts=2 sw=2 et
