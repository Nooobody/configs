
vim.g.mapleader = '-'

local set = vim.opt

set.clipboard = 'unnamed'

set.number = true

set.gdefault = true
set.scrolloff = 5
set.cursorline = true
set.foldcolumn = '1'
set.smartindent = false
set.expandtab = true
-- set.shiftwidth = 2
-- set.softtabstop = 2
set.ignorecase = true
set.wildignorecase = true
set.wildignore:append "**/node_modules/"
set.foldenable = false
set.termguicolors = true
set.swapfile = false
set.updatetime = 300

-- set.list = true
set.listchars = {
  tab = '▏ ',
  multispace = '▏ ',
  leadmultispace = '▏ ',
  trail = '~',
  extends = '>',
  precedes = '<'
}

-- Powershell options:
-- set.shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell"
-- set.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
-- set.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
-- set.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
-- set.shellquote = ""
-- set.shellxquote = ""

-- vim.keymap.set('n', '<Leader>ot', '<C-W>v<C-W>L:lcd %:p:h<CR>:terminal<CR>i')
-- vim.keymap.set('t', '<ESC>', [[<C-\><C-N>]])
vim.keymap.set('n', 'K', '<NOP>', { remap = true })

vim.keymap.set('n', 's', '<C-w>')

vim.keymap.set('n', '<Leader>ov', ':e ~/AppData/Local/nvim/init.lua<CR>')
vim.keymap.set('n', '<Leader>vr', ':so ~/AppData/Local/nvim/init.lua<CR>')
vim.keymap.set('n', '<Leader>tl', ':set list!<CR>')

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

vim.keymap.set('n', '<ESC>', ':noh<CR>', { silent = true })

vim.keymap.set('n', '<C-6>', '<C-^>', { silent = true })

vim.keymap.set('n', '<leader>fx', ':silent %!xmllint --encode UTF-8 --format -<CR>')

vim.keymap.set('n', '<leader>hi', function()
  vim.cmd [[ 
    echo synIDattr(synID(line('.'), col('.'), 1), 'name') . ' -> ' . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
  ]]
end)

vim.keymap.set('n', '<leader>pguid', function()
  vim.cmd [[
    e ~/Documents/Github/Netvisor.net/Webinterface/web.LocalDevelopment.config
  ]]
  vim.cmd [[ normal 12G$2F"lvi"h ]]
end)

vim.opt.path:remove "/usr/include"
vim.opt.path:append "**"

local aumisc = vim.api.nvim_create_augroup('Misc Commands', { clear = true })
vim.api.nvim_create_autocmd({'FocusGained', 'BufEnter'}, {
  group = aumisc,
  pattern = '*',
  command = 'checktime'
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = aumisc,
  pattern = "*",
  callback = function()
    -- vim.keymap.set('t', '<ESC>', [[<Cmd><Esc><CR>]])
    vim.keymap.set('t', '<C-q>', [[<Cmd>wincmd q<CR>]])
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]])
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]])
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]])
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]])
  end
})

vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = aumisc,
  pattern = '*',
  command = 'echohl WarningMsg | echo "File changed on disk. Buffer reloaded!" | echohl None'
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = aumisc,
  pattern = 'term://*',
  command = 'start!'
})

vim.keymap.set('n', '<leader>e', ':Oil --float<CR>', { silent = true })
vim.cmd[[:command! -nargs=1 Browse silent execute '!explorer' shellescape(<q-args>,1)]]

vim.api.nvim_create_autocmd('BufEnter', {
  group = aumisc,
  pattern = '*',
  callback = function()
    if vim.fn.expand('%') == "" and vim.bo.buftype == "" then
      vim.opt_local.buftype = 'nofile'
      vim.opt_local.bufhidden = 'hide'
    end
  end
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = aumisc,
  pattern = '*',
  callback = function()
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
    if ok and stats and (stats.size > 100000) then
      vim.b.large_buf = true
      vim.cmd("syntax clear")
      vim.cmd("IndentBlanklineDisable") -- disable indent-blankline.nvim
      vim.b.foldmethod = "manual"
      vim.b.spell = false
    else
      vim.b.large_buf = false
    end
  end
})

vim.g.did_load_filetypes = 1

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- My plugins here

  use 'nvim-lua/plenary.nvim'
  use 'kyazdani42/nvim-web-devicons'

  use 'andymass/vim-matchup'

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'RRethy/nvim-treesitter-textsubjects'
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'nvim-treesitter/playground'

  use 'neovim/nvim-lspconfig'
  use 'ray-x/lsp_signature.nvim'

  use { 'weilbith/nvim-code-action-menu' }
  use 'kosayoda/nvim-lightbulb'

  use 'kana/vim-textobj-user'
  use 'kana/vim-textobj-entire'

  use 'lukas-reineke/indent-blankline.nvim'

  use 'feline-nvim/feline.nvim'

  use { 'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end }

  use 'dyng/ctrlsf.vim'

  use 'nathom/filetype.nvim'

  use 'akinsho/toggleterm.nvim'

  use 'NvChad/nvim-colorizer.lua'

  use { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup() end }
  use 'karb94/neoscroll.nvim' 

  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'pwntester/octo.nvim'

  use { 
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'BurntSushi/ripgrep' },
      { 'sharkdp/fd' },
      { 'nvim-telescope/telescope-fzf-native.nvim' }
    }
  }

  use 'NMAC427/guess-indent.nvim'

  use 'dbakker/vim-projectroot'

  use 'christoomey/vim-sort-motion'
  use 'numToStr/Comment.nvim' 

  use 'gbprod/substitute.nvim'

  use 'brenoprata10/nvim-highlight-colors'
  use 'ray-x/aurora'
  use 'LunarVim/horizon.nvim'
  use { "catppuccin/nvim", as = "catppuccin" }

  use 'booperlv/nvim-gomove'

  use 'mattn/emmet-vim'
  use 'windwp/nvim-ts-autotag'
  use "windwp/nvim-autopairs"
  use 'Wansmer/sibling-swap.nvim'

  use 'andrewradev/linediff.vim'
  use 'Wansmer/treesj'

  use 'JoosepAlviste/nvim-ts-context-commentstring'

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-buffer'
  use 'dmitmel/cmp-cmdline-history'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-nvim-lsp-document-symbol'
  use 'folke/trouble.nvim'

  use 'mrcjkb/rustaceanvim'

  use 'Hoffs/omnisharp-extended-lsp.nvim'

  use 'kevinhwang91/nvim-hlslens'

  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'

  use 'stevearc/oil.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

require("octo").setup()

local kopts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })

require('statusline')

require('treesj').setup({})
require('guess-indent').setup({})
require('hlslens').setup()

require('oil').setup({
  keymaps = {
    ["<C-l>"] = "actions.select",
    ["<C-h>"] = "actions.parent",
    ["q"] = "actions.close"
  }
})

require('colorizer').setup()

require('toggleterm').setup({
  shade_terminals = true,
})
vim.keymap.set('n', '<Leader>ot', ':ToggleTerm size=80 direction=vertical dir=git_dir<CR>')

function lazygit_toggle()
  local lazygit = require('toggleterm.Terminal').Terminal:new({ 
    cmd = 'lazygit', 
    hidden = true, 
    dir = 'git_dir',
    direction = 'float',

    on_open = function(term)
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-h>", "", { noremap = true })
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-j>", "", { noremap = true })
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-k>", "", { noremap = true })
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-l>", "", { noremap = true })
    end
  })
  lazygit:toggle()
end

vim.keymap.set('n', '<Leader>og', function() lazygit_toggle() end, { noremap = true, silent = true })
-- local lf
-- lf = require('toggleterm.Terminal').Terminal:new({ 
--   cmd = 'lf', 
--   hidden = true, 
--   dir = 'git_dir',
--   direction = 'float'
-- })
--
-- function lf_toggle()
--   lf:toggle()
-- end
--
-- vim.keymap.set('n', '<Leader>olf', function() lf_toggle() end, { noremap = true, silent = true })

local aspxFilesFn = function()
  vim.bo.filetype = "vb"
  vim.bo.bomb = true
end

require('filetype').setup({
  overrides = {
    literal = {
      ["nv-styles.css"] = ''
    },
    function_extensions = {
      ["aspx"] = aspxFilesFn,
      ["asp"] = aspxFilesFn,
      ["vb"] = aspxFilesFn
    }
  }
})

require('nvim-lightbulb').setup({
  autocmd = {
    enabled = true
  }
})

vim.keymap.set('n', '<leader>ca', '<cmd>CodeActionMenu<cr>')

require("trouble").setup({
  mode = "document_diagnostics",
  auto_close = true
})
vim.keymap.set('n', '<leader>xx', "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })

local dap = require('dap')
local dapui = require('dapui')
dapui.setup()
dap.set_log_level('TRACE')
vim.keymap.set('n', '<leader>dbui', dapui.toggle)
vim.keymap.set('n', '<leader>dbbp', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>dbc', dap.continue)
vim.keymap.set('n', '<leader>dbso', dap.step_over)
vim.keymap.set('n', '<leader>dbsi', dap.step_into)

dap.adapters.chrome = {
  type = 'executable',
  command = 'node',
  args = { 'C:/Users/eveliina.keski-rahko/Documents/vscode-chrome-debug/out/src/chromeDebug.js' }
}

local dapconf = {
  name = "Debug (Attach) - Remote",
  type = "chrome",
  request = "attach",
  program = "${file}",
  cwd = "${workspaceFolder}\\frontend\\src",
  sourceMaps = true,
  trace = true,
  protocol = "inspector",
  port = 9222,
  webRoot = "${workspaceFolder}\\frontend\\src",
  sourceMapPathOverrides = {
    ["webpack:///./*"] = "${workspaceFolder}/frontend/src/*"
  }
}

dap.configurations.typescriptreact = { dapconf }
dap.configurations.typescript = { dapconf }
dap.configurations.javascriptreact = { dapconf }
dap.configurations.javascript = { dapconf }

require('Comment').setup({
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
})

require('sibling-swap').setup()

require('gomove').setup({
  map_defaults = false
})
vim.keymap.set('x', '<S-k>', '<Plug>GoVMLineUp' , {})
vim.keymap.set('x', '<S-j>', '<Plug>GoVMLineDown', {})
vim.keymap.set('x', '<S-l>', '<Plug>GoVMLineRight' , {})
vim.keymap.set('x', '<S-h>', '<Plug>GoVMLineLeft', {})
-- vim.keymap.set('x', '<C-k>', '<Plug>GoVDLineUp' , {})
-- vim.keymap.set('x', '<C-j>', '<Plug>GoVDLineDown', {})

require('nvim-autopairs').setup()

vim.keymap.set('n', '<leader>gb', ':Git blame<CR>')
vim.keymap.set({ 'n', 'x' }, '<leader>gh', ':GBrowse<CR>')
vim.keymap.set('n', '<leader>gr', ':Gread<CR>')

vim.keymap.set('i', '<C-e>', '<Plug>(emmet-expand-abbr)', { silent = true })

local fileTypesToIgnore = {
  'help',
  '',
  'toggleterm',
  'oil',
  'git',
  'octo_panel',
  'fugitiveblame'
}

function string.starts(String, Start)
   return string.sub(String, 1, string.len(Start)) == Start
end

local projectau = vim.api.nvim_create_augroup('ProjectAU', {clear = true})
vim.api.nvim_create_autocmd('BufEnter', {
  group = projectau,
  pattern = '*',
  callback = function()
    for k,v in ipairs(fileTypesToIgnore) do
      if string.lower(vim.bo.filetype) == v then
        return
      end
    end

    local fileName = vim.api.nvim_buf_get_name(0)
    if string.starts(fileName, 'octo://') then
      return
    end

    vim.cmd [[ProjectRootCD]]
  end
})

local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local previewers = require("telescope.previewers")

local new_maker = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > 100000 then
      return
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

require('telescope').setup({
  defaults = {
    path_display = { 'truncate' },
    buffer_previewer_maker = new_maker,
    file_ignore_patterns = { "node_modules" },
    mappings = {
      i = {
        ['<esc>'] = actions.close,
        ['<C-u>'] = false,
      }
    }
  }
})

vim.keymap.set('n', '<leader>;', builtin.resume)
vim.keymap.set('n', '<leader>cs', function() builtin.colorscheme({ enable_preview = true }) end)
vim.keymap.set('n', '<leader>tsl', builtin.builtin)
vim.keymap.set('n', '<leader>tst', builtin.treesitter)
vim.keymap.set('n', '<leader>glb', builtin.git_branches)
vim.keymap.set('n', '<leader>gls', builtin.git_stash)
vim.keymap.set('n', '<leader>fz', function() builtin.find_files({ no_ignore = true, no_ignore_parent = true }) end)
vim.keymap.set('n', '<leader>fb', function() builtin.buffers({ sort_lastused = true, ignore_current_buffer = true, sort_mru = true }) end)
vim.keymap.set('n', '<leader>fl', builtin.live_grep)
vim.keymap.set('n', '<leader>fgp', function() builtin.find_files({ cwd = '~/Documents/Github' }) end)
vim.keymap.set('n', '<leader>fgsp', function() builtin.find_files({ cwd = '~/Documents/Github', no_ignore = true, no_ignore_parent = true }) end)
vim.keymap.set('n', '<leader>gs', builtin.git_status)

require('indent_blankline').setup({
  show_current_context = true,
  show_current_context_start = true
})

require('treesitter-context').setup()
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'javascript', 'typescript', 'json', 'c_sharp', 'css', 'dockerfile', 'dot', 'html', 'rust', 'python', 'lua', 'vim', 'query', 'c', 'cpp' },
  playground = {
    enable = true
  },
  highlight = {
    enable = true,
    disable = function()
      return vim.b.large_buf
    end
  },
  indent = {
    enable = true
  },
  textsubjects = {
    enable = true,
    prev_selection = ",",
    keymaps = {
      ['.'] = 'textsubjects-smart',
      [';'] = 'textsubjects-container-outer',
      ['i;'] = 'textsubjects-container-inner'
    }
  },
  autotag = {
    enable = true
  },
  context_commentstring ={
    enable = true,
    enable_automd = false,
  }
}

vim.cmd.colorscheme 'catppuccin-mocha'
vim.cmd [[let g:terminal_color_8 = '#dc143c']] -- Terminal Error

vim.g.ctrlsf_ignore_dir = { 'node_modules' }
vim.g.ctrlsf_position = "right"

vim.keymap.set('n', '<leader>fp', ':CtrlSF ')
vim.keymap.set('n', '<leader>fc', '<Plug>CtrlSFCwordExec')

local t = {}
t['<C-j>'] = {'scroll', {'vim.wo.scroll', 'true', '50' }}
t['<C-k>'] = {'scroll', {'-vim.wo.scroll', 'true', '50' }}
t['<C-f>'] = {'scroll', {'vim.api.nvim_win_get_height(0)', 'true', '50' }}
t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '50' }}

require('neoscroll').setup({ easing_function = 'quadratic' })
require('neoscroll.config').set_mappings(t)
local lsp_sig = require('lsp_signature')

local ts_utils = require('nvim-treesitter.ts_utils')
local function has_value(tab, val)
  for index, value in ipairs(tab) do
    if value == val then
      return true
    end
  end
  return false
end

local enumLSP = {
  ['tsserver'] = 1,
  ['csharp_ls'] = 2,
  ['rustaceanvim'] = 3
}

local on_attach = function(lsp)
  local keymaps = function(bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n' ,'<leader>K', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  end

  local jsxFloat = function(augroup)
    local jsx = {
      'jsx_element',
      'jsx_attribute',
      'jsx_text',
      'jsx_expression',
      'jsx_opening_element',
      'jsx_closing_element'
    }

    vim.api.nvim_create_autocmd('CursorHoldI', {
      group = augroup,
      pattern = '*',
      callback = function()
        local node = ts_utils.get_node_at_cursor()
        if not node then
          return
        end

        local name = node:type()
        if has_value(jsx, name) then
          lsp_sig.toggle_float_win()
        end
      end
    })
  end

  return function(client, bufnr)

    local augroup = vim.api.nvim_create_augroup('LSP_au', { clear = true })
    vim.api.nvim_create_autocmd('CursorHold', {
      group = augroup,
      pattern = '*',
      callback = function()
        vim.diagnostic.open_float(nil, { focus = false, focusable = false })
      end
    })

    keymaps(bufnr)

    if lsp == enumLSP.tsserver then
      jsxFloat(augroup)
    end

    lsp_sig.on_attach({}, bufnr)
  end
end

local lsp_flags = {
  debounce_text_changes = 150,
}

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = false
})

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('[%s)}]') == nil
end

local cmp = require('cmp')
local luasnip = require('luasnip')

local function cmp_confirm(fallback)
  if cmp.visible() and cmp.get_active_entry() then
    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
  else
    fallback()
  end
end

cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping({ 
      i = cmp_confirm,
      s = cmp.mapping.confirm({ select = true }),
      c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
    }),
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnpi.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  }),
  experimental = {
    ghost_text = true
  },
  sources = cmp.config.sources({
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    -- { name = 'nvim_lsp_signature_help' },
    { name = 'buffer' },
    { name = 'luasnip' }
  })
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline({
    ["<CR>"] = cmp.mapping({
      i = cmp_confirm,
      s = cmp.mapping.confirm({ select = false }),
      c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
    })
  }),
  sources = cmp.config.sources({
    { name = 'buffer' },
    { name = 'nvim_lsp_document_symbol' },
    { name = 'cmdline_history' }
  })
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline({
    ["<CR>"] = cmp.mapping({
      i = cmp_confirm,
      s = cmp.mapping.confirm({ select = false }),
      c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
    })
  }),
  sources = cmp.config.sources({
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }, {
      name = 'cmdline_history'
    }
  })
})

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

lspconfig.tsserver.setup({
  on_attach = on_attach(enumLSP.tsserver),
  handlers = handlers,
  flags = lsp_flags,
  capabilities = capabilities,
})

local pid = vim.fn.getpid()
local omnisharp_exe = 'C:\\Users\\eveliina.keski-rahko\\omnisharp\\OmniSharp.exe'
lspconfig.omnisharp.setup({
  on_attach = on_attach(enumLSP.csharp_ls),
  handlers = {
    ["textDocument/definition"] = require('omnisharp_extended').handler
  },
  cmd = { omnisharp_exe },
  flags = lsp_flags,
  filetypes = { "cs", "vb", "aspx" },
  enable_ms_build_load_projects_on_demand = true,
  analyze_open_documents_only = true,
  enable_roslyn_analyzers = true,
  capabilities = capabilities,
})

vim.g.rustaceanvim = {
  server = {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      on_attach(enumLSP.rustaceanvim)(client, bufnr)
      vim.keymap.set("n", "<C-space>", function() vim.cmd.RustLsp({ "hover", "actions" }) end, { buffer = bufnr })
      vim.keymap.set("n", "<leader>rr", function() vim.cmd("RustRun") end, { buffer = bufnr })
    end
  }
}
