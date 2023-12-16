-- [[ Configure neo-tree ]]

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
      vim.keymap.set('n', '<leader>e', ':Neotree filesystem toggle left<CR>', { desc = 'Open neo-tree' })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
