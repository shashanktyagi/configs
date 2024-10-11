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

  {
    "norcalli/nvim-colorizer.lua"
  },

  {
    "shashanktyagi/jellybeans-nvim",
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
       vim.cmd "colorscheme jellybeans-nvim"
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

  { "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup {
        scope = { enabled = false },
      }
    end
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

      require("telescope").setup({
        defaults = {
          mappings = {
            -- Exit with single escape.
            i = {
              ["<Esc>"] = "close",
              ["<C-c>"] = false,
            },
          },
        }
      })

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>f', builtin.find_files)
      vim.keymap.set('n', '<leader>r', builtin.oldfiles)
      vim.keymap.set('n', '<leader>m', builtin.buffers)
      -- Requires ripgrep.
      vim.keymap.set('n', '<leader>ag', builtin.live_grep)
      -- Fuzzy search word under cursor.
      vim.keymap.set('n', '<leader>s',
        function()
          builtin.grep_string()
        end)

      -- Search current buffer.
      vim.keymap.set('n', '<leader>/',
       function()
        local builtin = require('telescope.builtin')
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 0,
          previewer = True,
        })
      end)
    end,
  },

  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    event = "BufReadPost",
    opts = {
      sync_install = false,
      ensure_installed = {
        "c",
        "cpp",
        "python",
        "bash",
        "dockerfile",
        "lua",
        "markdown",
        "markdown_inline",
        "regex",
        "vim",
        "yaml",
        "json",
        "rust",
        "toml",
      },
      highlight = { enable = true },
      indent = { enable = true, disable = { "python", "c" } },
      matchup = {
        enable = true,
      },
      endwise = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
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
          {silent = true, noremap = true}),
        view = {adaptive_size = true}
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
        "rust_analyzer",
      })

      require('lspconfig').clangd.setup {
        cmd = {
            "clangd",
            "--background-index",
        },
        filetypes = { "c", "cpp", "objc", "objcpp" },
      }

      require('lspconfig').pyright.setup {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "standard",
              autoSearchPaths = true,
              diagnosticMode = 'openFilesOnly',
              useLibraryCodeForTypes = false,
            },
          }
        }
      }

      lsp.on_attach(function(client, bufnr)
        local opts = {buffer = bufnr, remap = false}

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition({jump_type="split"}) end, opts)
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
        -- Switch between source and header.
        vim.keymap.set("n", "gx", ":ClangdSwitchSourceHeader<cr>")
        vim.diagnostic.config({
          virtual_text = false, -- Turn off inline diagnostics
        })

        -- Floating diagnostics.
        vim.cmd(
          "autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})"
        )

      end)
      lsp.setup()

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
          {
            name = "buffer",
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            },
          },
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
              ["<A-Tab>"] = cmp.mapping(function(fallback)
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
  },

  { -- Zoom a pane as a floating window.
    "folke/zen-mode.nvim",
    config = function()
      vim.keymap.set("n", "<leader>z", function()
        require("zen-mode").toggle ({
          window = {
            width = 0.50
          }
        })
      end)
    end
  },
  {
    "Vimjas/vim-python-pep8-indent"
  },
  {
    "junegunn/vim-easy-align"
  },
  {
    "bronson/vim-trailing-whitespace"
  },
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("aerial").setup({
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
            -- Jump forwards/backwards with '{' and '}'
            vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
            vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end,
      })
      -- You probably also want to set a keymap to toggle aerial
      vim.keymap.set("n", "<leader>aa", "<cmd>AerialToggle!<CR>")
    end
  },

}, {})

----------------------------- Pluging Settings --------------------------------

vim.api.nvim_exec([[
  let g:easy_align_delimiters = {
    \ '/': {
    \     'pattern':         '//\+\|/\*\|\*/',
    \     'delimiter_align': 'l',
    \     'ignore_groups':   ['!Comment']
    \ },
    \ }
]], false)
vim.keymap.set("v", "ga", ":EasyAlign")

---------------------------- General Configuration ----------------------------
-- Set highlight on search
vim.opt.hlsearch = true

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Timeouts
vim.opt.timeout = true
vim.opt.timeoutlen = 3000
vim.opt.ttimeoutlen = 100
vim.opt.undofile = true


-- A buffer becomes hidden when it is abandoned
vim.opt.hid = true

-- Minimum number of lines to show below/above the current cursor location.
vim.opt.scrolloff = 5

-- Indenting
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.updatetime = 100
vim.opt.cindent = true

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

-- No swap file
vim.opt.swapfile = false

-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup(
"YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

function delete_hidden_buffers()
  local tpbl = {}
  for i=1, vim.fn.tabpagenr('$') do
    local tabpagebuflist = vim.fn.tabpagebuflist(i)
    for _, bufnr in ipairs(tabpagebuflist) do
      table.insert(tpbl, bufnr)
    end
  end
  local deleted = false
  for bufnr=1, vim.fn.bufnr('$') do
    if vim.api.nvim_buf_is_valid(bufnr) and not vim.tbl_contains(tpbl, bufnr) then
      local ok, err = pcall(function()
        vim.cmd('silent bwipeout ' .. bufnr)
      end)
      if not ok then
        print("Error deleting buffer " .. bufnr .. ": " .. err)
      else
        deleted = true
      end
    end
  end
  if not deleted then
    print("No hidden buffers to delete")
  end
end
vim.cmd('command! DeleteHiddenBuffers lua delete_hidden_buffers()')

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
-- Quit a buffer.
vim.keymap.set("n", "<leader>q", "<c-w>q")
-- Vertical editing.
vim.keymap.set("n", "<leader>v", "<c-v>")
-- Exchange buffers.
vim.keymap.set("n", "<leader>x", "<c-w>x")
-- Return to remove highlight.
vim.keymap.set("n", "<leader><cr>", ":noh<cr><esc>")
-- vim.keymap.set("n", "*", "*``")
-- Copy to system clipboard.
vim.keymap.set("v", "<C-c>", '"+y');
-- Python breakpoint
vim.keymap.set("n", "<leader>b", "oimport ipdb;ipdb.set_trace()<esc>");

vim.keymap.set("t", "<esc>", "<c-\\><c-n>");
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "<C-u>", "5j5<C-e>")
vim.keymap.set("n", "<C-d>", "5k5<C-y>")
vim.keymap.set("n", "<leader>o", "<c-o>")
vim.keymap.set("n", "<leader>i", "<c-i>")
vim.keymap.set("n", "<leader>6", "<c-6>")

if vim.fn.has("gui_gtk") == 1 or vim.fn.has("gui_gtk2") == 1 or vim.fn.has("gui_gnome") == 1 or vim.fn.has("unix") == 1 then
  -- relative path (src/foo.txt)
  vim.api.nvim_set_keymap('n', '<leader>cf', ':let @+=expand("%")<CR>', { noremap = true, silent = true })

  -- absolute path (/something/src/foo.txt)
  vim.api.nvim_set_keymap('n', '<leader>cF', ':let @+=expand("%:p")<CR>', { noremap = true, silent = true })
end

-- Search but don't move the cursor.
function smart_star()
  -- Save current position
  local original_pos = vim.api.nvim_win_get_cursor(0)

  -- Perform the search
  vim.cmd('normal! *')

  -- Check if cursor position changed after the search
  local new_pos = vim.api.nvim_win_get_cursor(0)
  if original_pos[1] == new_pos[1] and original_pos[2] == new_pos[2] then
    -- If cursor hasn't moved, there was no other occurrence
    vim.api.nvim_echo({{"No other occurrences found", "WarningMsg"}}, false, {})
  else
    -- If it moved, jump back to the original position
    vim.cmd('normal! ``')
  end
end

-- Set the keymap to use the new function
vim.keymap.set('n', '*', smart_star)

