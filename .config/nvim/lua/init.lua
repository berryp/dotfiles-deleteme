-- This is required to not have cue files marked as `cuesheet`
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.cue"},
  command = "set filetype=cue",
})

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
local treesitter = require'nvim-treesitter.configs'

parser_config.cue = {
  install_info = {
    url = "https://github.com/eonpatapon/tree-sitter-cue", -- local path or git repo
    files = {"src/parser.c", "src/scanner.c"},
    branch = "main"
  },
  filetype = "cue", -- if filetype does not agrees with parser name
}

treesitter.setup {
  ensure_installed = {
    "bash",
    "cmake",
    "comment",
    "cue",
    "dockerfile",
    "dot",
    "fish",
    "go",
    "gomod",
    "hcl",
    "html",
    "json",
    "json5",
    "lua",
    "python",
    "typescript",
    "toml",
    "yaml",
  },
  
  highlight = {
    enable = true,
  },
}

