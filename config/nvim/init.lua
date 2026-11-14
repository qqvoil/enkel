vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {}
local plugins = {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
        },
        color_overrides = {
          mocha = {
            rosewater = "#c2bebe",
            flamingo  = "#bebebe",
            pink      = "#a09ca0",
            mauve     = "#827f82",
            red       = "#837f7f",
            maroon    = "#7e7a7a",
            peach     = "#8e8a84",
            yellow    = "#82817e",
            green     = "#7e827f",
            teal      = "#7f8282",
            sky       = "#9c9fa0",
            sapphire  = "#94989e",
            blue      = "#7e8083",
            lavender  = "#9b9da1",
            text      = "#d6d6d6",
            subtext1  = "#b8b8b8",
            subtext0  = "#9e9e9e",
            overlay2  = "#808080",
            overlay1  = "#666666",
            overlay0  = "#4d4d4d",
            surface2  = "#333333",
            surface1  = "#262626",
            surface0  = "#1a1a1a",
            base      = "#111111",
            mantle    = "#0c0c0c",
            crust     = "#080808",
          },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end
  }
}

require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
