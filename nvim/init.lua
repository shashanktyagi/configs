------------------------ Setting required for plugins -------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = ' '
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

---------------------------- Plugins ------------------------------------------
-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  { -- Theme
    "savq/melange-nvim",
    config = function()
       vim.cmd "colorscheme melange"
    end,
  },

  { -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    config = function()
	    require('lualine').setup {
        options = {
          theme = 'auto'
        }
      }
    end,
  },

  { -- Add indentation guides.
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual block (linewise comment)
  -- "gb" to comment visual block (blockwise comment)
  { 'numToStr/Comment.nvim', opts = {} },

  { -- Fuzzy finder
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim'  },
    config = function()
      pcall(require('telescope').load_extension, 'fzf')

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<c-p>', builtin.git_files)
      vim.keymap.set('n', '<leader>m', builtin.buffers)
      vim.keymap.set('n', '<leader>r', builtin.oldfiles)
      -- Requires ripgrep.
      vim.keymap.set('n', '<leader>ag', builtin.live_grep)
      -- Fuzzy search word under cursor.
      vim.keymap.set('n', '<leader>s', function()
          builtin.grep_string()
        end)

      -- Search current buffer.
      vim.keymap.set('n', '<leader>/',
       function()
        local builtin = require('telescope.builtin')
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end)
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "vim",
          "lua",
          "python",
          "c",
          "json",
        },

        highlight = {
          enable = true,
          use_languagetree = true,
        },

        indent = { enable = true },
      })
    end,
  },

  { -- File Tree.
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<cr>",
          {silent = true, noremap = true})
      }
    end,
  },

  { -- VIM TMUX navigation.
    "alexghergh/nvim-tmux-navigation",
    config = function()
      local nvim_tmux_nav = require('nvim-tmux-navigation')
      nvim_tmux_nav.setup{
        disable_when_zoomed = true
      }
      vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
    end,
  },

  {  -- LSP and Autocompletion
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {                                      -- Language server manager
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-path'}, 
      {'hrsh7th/cmp-buffer'}, 
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
      local lsp = require('lsp-zero')
      lsp.preset("recommended")
      lsp.ensure_installed({
        "clangd",
        "pyright",
      })
      lsp.on_attach(function(client, bufnr)
        local opts = {buffer = bufnr, remap = false}

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
        -- Switch between source and header.
        vim.keymap.set("n", "gx", ":ClangdSwitchSourceHeader<cr>")
      end)
      lsp.setup()
      vim.diagnostic.config({
          virtual_text = true
      })

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0,
            line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")
      cmp.setup({
        sources = {
            {name = "nvim_lsp"},
            {name = "path" },
            {name = "buffer"},
        },
        mapping = {
              -- Tab to cycle forward through the autocompletion.
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { "i", "s" }),
              -- Shift-Tab to cycle backward through the autocompletion.
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  else
                    fallback()
                  end
              end, { "i", "s" }),

              -- Jump to the placeholder forwards.
              ["<C-j>"] = cmp.mapping(function(fallback)
                if luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                else
                  fallback()
                end
              end, { "i", "s" }),

              -- Jump to the placeholder backwards.
              ["<C-k>"] = cmp.mapping(function(fallback)
                  if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                  else
                    fallback()
                  end
              end, { "i", "s" }),
            },
      })


    end,
  },

  { -- Bufferline
    'akinsho/bufferline.nvim',
    version = "v3.*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = true
  },

  { -- Auto pairs () {} []
    "windwp/nvim-autopairs",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      -- setup cmp for autopairs
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  { -- Vim session manager.
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/"},
    }
  end
  },

  { -- GIT stuff.
    "tpope/vim-fugitive",
  },
  {
    "tpope/vim-rhubarb"
  }
}, {})

---------------------------- General Configuration ----------------------------
-- Set highlight on search
vim.o.hlsearch = true

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.timeoutlen = 400
vim.opt.undofile = true

-- Indenting
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.updatetime = 250

-- Line numbers
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.numberwidth = 2

-- Always show current position
vim.opt.ruler = true

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append "<>[]hl"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cpoptions = vim.opt.cpoptions + "$"
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true

----------------------------------- Mappings ----------------------------------

-- Save a buffer.
vim.keymap.set("n", "<leader>w", ":w<cr>")
-- Move visual selection.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- Select just pasted code block.
vim.keymap.set("n", "gp", "'[v']")
-- Indent code.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- Zoom vim pane.
vim.keymap.set("n", "<leader>z", "<c-w>_ | <c-w>|")
-- Make all panes of equal size.
vim.keymap.set("n", "<leader>zz", "<c-w>=")
-- Quit a buffer.
vim.keymap.set("n", "<leader>q", "<c-w>q")
-- Vertical editing.
vim.keymap.set("n", "<leader>v", "<c-v>")
-- Exchange buffers.
vim.keymap.set("n", "<leader>x", "<c-w>x")
-- Return to remove highlight.
vim.keymap.set("n", "<cr>", ":noh<cr><esc>")
-- Search but don't move the cursor.
vim.keymap.set("n", "*", "*``")
-- Copy to system clipboard.
vim.keymap.set("v", "<c-c>", '"+y');
