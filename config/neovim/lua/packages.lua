-- Plugin management
--------------------

-- Install packer if not already present
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '.. install_path)
end

require('packer').startup(function(use)
  -- Package management
  use 'wbthomason/packer.nvim'

  -- Package management
  use 'wbthomason/packer.nvim'

  -- Editing
  use 'ggandor/lightspeed.nvim'
  use 'tpope/vim-commentary'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'wincent/loupe'

  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-commentary'
  use 'jacoborus/tender.vim'
  use 'hoob3rt/lualine.nvim'
  use 'kristijanhusak/defx-git'
  use 'kristijanhusak/defx-icons'
  use { 'Shougo/defx.nvim', run = ':UpdateRemotePlugins' }
  use 'neovim/nvim-lspconfig'
  use 'tami5/lspsaga.nvim'
  use 'folke/lsp-colors.nvim'
  use 'L3MON4D3/LuaSnip'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/nvim-cmp'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'kyazdani42/nvim-web-devicons'
  use 'onsails/lspkind-nvim'
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'



  -- UI
  use {
    'projekt0n/github-nvim-theme',
    config = function()
      vim.o.background = "dark"
      require('github-theme').setup({
        theme_style = mode,
        keyword_style = 'NONE',
      })
    end
  }
  use 'nvim-lua/lsp-status.nvim'
  use {
    'nvim-lualine/lualine.nvim',
    after = 'github-nvim-theme',
    requires = 'lsp-status.nvim',
    config = function()
      -- Mode symbols not exposed as options, so modify internals
      local mode_map = {
        n  = '∙',
        i  = '|',
        ic  = '|',
        ix  = '|',
        v  = '→',
        V  = '↔',
        [''] = '↕',
        c = '$'
      }
      for k, v in pairs(mode_map) do
        require('lualine.utils.mode').map[k] = v
      end

      local lsp_status = require('lsp-status')
      lsp_status.config({
        indicator_info = 'i',
        indicator_hint = '?',
        indicator_ok = '',
        status_symbol = '',
      })
      lsp_status.register_progress()

      require('lualine').setup({
        options = {
          theme = 'github',
        },
        sections = {
          lualine_y = {"require('lsp-status').status()"}
        }
      })
    end
  }
  -- Git signs in the gutter
  use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function()
      require('gitsigns').setup()
    end
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function ()
      -- Start with indent guides turned off; toggle with <Leader>i
      vim.g.indent_blankline_enabled = false
    end
  }

  -- Find anything
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    after = 'which-key.nvim',
    config = function()
      require('which-key').register(
        {
          f = {
            name = 'find',
            f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", 'Find File' },
            h = { "<cmd>lua require('telescope.builtin').find_files({hidden = true})<cr>", 'Find Hidden File' },
            b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", 'Find Buffer' },
            g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", 'Find Text' },
          }
        },
        {
          prefix = '<leader>'
        }
      )
    end
  }

  -- Discover mappings
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup()
    end
  }

  -- Syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'bash',
          'cmake',
          'dockerfile',
          'dot',
          'fish',
          'go',
          'html',
          'javascript',
          'json',
          'latex',
          'lua',
          'make',
          'nix',
          'python',
          'regex',
          'rst',
          'rust',
          'toml',
          'typescript',
          'yaml',
        },
        indent = {enable = true},
        highlight = {enable = true},
      })
    end
  }

  -- Language servers
  use {
    'neovim/nvim-lspconfig',
    after = {'which-key.nvim', 'nvim-cmp', 'nvim-lightbulb', 'trouble.nvim'},
  }
  use({
    'jose-elias-alvarez/null-ls.nvim',
    requires = {'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig'},
    after = 'nvim-lspconfig',
    config = function()
      pkg = require('null-ls')
      pkg.setup({
        sources = {
          -- Diagnositcs
          pkg.builtins.diagnostics.checkmake,
          pkg.builtins.diagnostics.cue_fmt,
          pkg.builtins.diagnostics.flake8,
          pkg.builtins.diagnostics.golangci_lint,
          pkg.builtins.diagnostics.markdownlint,
          -- Formatting
          pkg.builtins.formatting.black,
          pkg.builtins.formatting.isort,
          pkg.builtins.formatting.gofumpt,
          pkg.builtins.formatting.markdownlint,
        }
      })
      require('language_servers')
    end
  })

  -- LSP UI
  use 'kyazdani42/nvim-web-devicons'
  use {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup({
        icons = false
      })
    end
  }
  use 'kosayoda/nvim-lightbulb'
  -- Completion
  use 'hrsh7th/nvim-compe'
end)

vim.cmd('autocmd BufRead,BufNewFile *.fish setfiletype fish')
vim.cmd('autocmd BufRead,BufNewFile *.nix setfiletype nix')

-- This is required to not have cue files marked as `cuesheet`
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.cue"},
  command = "set filetype=cue",
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.cue = {
  install_info = {
    url = "https://github.com/eonpatapon/tree-sitter-cue", -- local path or git repo
    files = {"src/parser.c", "src/scanner.c"},
    branch = "main"
  },
  filetype = "cue", -- if filetype does not agrees with parser name
}
