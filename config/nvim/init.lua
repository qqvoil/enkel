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
  },
  
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "markdown", "markdown_inline" },
            highlight = { enable = true },
        })
    end,
    },

{
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.icons",
    },
    ft = { "markdown" },
    opts = {
      anti_conceal = { enabled = false },
      sign = { enabled = false },
      heading = {
        sign = false,
        width = "block",
        left_pad = 1,
        right_pad = 2,
        icons = { "▎ ", "▎ ", "", "", "", "" },
      },
      bullet = {
        icons = { "•", "◦", "▪", "▫" },
      },
      code = {
        style = "normal",
        border = "thin",
        left_pad = 1,
        right_pad = 1,
      },
      win_options = {
        conceallevel = { default = vim.o.conceallevel, rendered = 3 },
        wrap = { default = false, rendered = true },
        linebreak = { default = false, rendered = true },
        number = { default = true, rendered = false },
        relativenumber = { default = true, rendered = false },
        cursorline = { default = true, rendered = false },
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- Чёткая монохромная иерархия вместо одинаковых серых полос
      vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = "#ffffff", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#262626" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = "#e5e5e5", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#1c1c1c" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = "#cccccc", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = "#a8a8a8", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = "#808080" })
      vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#161616" })
      vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { fg = "#e0e0e0", bg = "#222222" })
    end,
    keys = {
      {
        "<leader>mr",
        "<cmd>RenderMarkdown toggle<cr>",
        desc = "Toggle Markdown Reader",
        ft = "markdown",
      },
    },
  },
}

require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
