{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    bat
    haskell-language-server
    nodePackages.typescript
    nodePackages.typescript-language-server
    ormolu
  ];

  programs.neovim = {
    enable = true;

    extraConfig =
      ''
      "No file clutter
      set nobackup
      set nowb
      set noswapfile

      "No stupid autoindent
      filetype indent off
      "But keep indentation from previous lines
      set autoindent
      set smartindent

      "Scroll before reaching end of page
      set scrolloff=5
      set encoding=utf-8

      "Leader key
      nnoremap <SPACE> <Nop>
      let mapleader = " "

      "Enable copy+paste from the clipboard
      vnoremap <leader>y "+y
      nnoremap <leader>Y "+yg_
      nnoremap <leader>y "+y
      nnoremap <leader>yy "+yy

      nnoremap <leader>p "+p
      nnoremap <leader>P "+P
      vnoremap <leader>p "+p
      vnoremap <leader>P "+P

      nmap <silent> <c-h> :wincmd h<cr>
      nmap <silent> <c-j> :wincmd j<cr>
      nmap <silent> <c-k> :wincmd k<cr>
      nmap <silent> <c-l> :wincmd l<cr>

      "Allow to incrment letters with Ctrl+A
      set nrformats=alpha

      "Enable the column for gitgutter and diagnostics by default
      set signcolumn=yes

      "Spaces instead of tabs
      set expandtab
      set smarttab
      set shiftwidth=2
      set softtabstop=2
      set tabstop=2
      
      "Navigate tabs with J and K
      nnoremap J :tabp<CR>
      nnoremap K :tabn<CR>
      '';

    plugins = with pkgs.vimPlugins; [
      { plugin = vim-colors-solarized;
        config =
          ''
          let g:solarized_termtrans = 1
          set background=dark
          colorscheme solarized
          '';
      }
      editorconfig-vim
      vim-gitgutter
      { plugin = rainbow;
        config =
          ''
          let g:rainbow_active = 1
          let g:rainbow_conf = {
            \ 'ctermfgs': ['darkblue', 'darkgreen', 'red', 'magenta', 'brown', 'lightgreen']
          \ }
          '';
      }
      vim-nix
      dhall-vim
      vim-airline
      { plugin = vim-airline-themes;
        config =
          ''
          let g:airline_theme = 'badwolf'
          let g:airline_powerline_fonts = 1
          '';
      }
      { plugin = nvim-lspconfig;
        type = "lua";
        config =
          ''
          local servers = { "tsserver", "hls", "dhall_lsp_server" }
          
          local nvim_lsp = require('lspconfig')
          
          -- after the language server attaches to the current buffer
          local on_attach = function(client, bufnr)
            local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
            local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

            -- Mappings.
            local opts = { noremap=true, silent=true }
            buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
            buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
            buf_set_keymap('n', '<leader>h', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
            buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
            buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
            buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
            buf_set_keymap('n', '<C-i>', '<cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>', opts)

            -- Code lens support
            if client.resolved_capabilities.code_lens then
              vim.api.nvim_command([[autocmd BufEnter,InsertLeave * silent! lua vim.lsp.codelens.refresh()]])
              buf_set_keymap('n', '<leader>l', '<cmd>lua vim.lsp.codelens.run()<CR>', opts)
              vim.lsp.codelens.refresh()
            end
          end

          -- Use a loop to conveniently call 'setup' on multiple servers and
          -- map buffer local keybindings when the language server attaches
          for _, lsp in ipairs(servers) do
            nvim_lsp[lsp].setup {
              on_attach = on_attach,
              flags = {
                debounce_text_changes = 150,
              }
            }
          end
          '';
      }
      { plugin = nvim-compe;
        type = "lua";
        config =
          ''
          vim.o.completeopt = "menuone,noselect"

          require('compe').setup {
            enabled = true;
            autocomplete = true;
            debug = false;
            min_length = 1;
            preselect = 'enable';
            throttle_time = 80;
            source_timeout = 200;
            incomplete_delay = 400;
            max_abbr_width = 100;
            max_kind_width = 100;
            max_menu_width = 100;
            documentation = true;  source = {
              path = true;
              buffer = true;
              calc = true;
              nvim_lsp = true;
              nvim_lua = true;
              vsnip = false;
              ultisnips = false;
              emoji = true;
            };
          }

          local t = function(str)
            return vim.api.nvim_replace_termcodes(str, true, true, true)
          end

          local check_back_space = function()
              local col = vim.fn.col('.') - 1
              return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
          end

          -- Use (s-)tab to:
          --- move to prev/next item in completion menuone
          --- jump to prev/next snippet's placeholder
          _G.tab_complete = function()
            if vim.fn.pumvisible() == 1 then
              return t "<C-n>"
            --elseif vim.fn['vsnip#available'](1) == 1 then
            --  return t "<Plug>(vsnip-expand-or-jump)"
            elseif check_back_space() then
              return t "<Tab>"
            else
              return vim.fn['compe#complete']()
            end
          end
          _G.s_tab_complete = function()
            if vim.fn.pumvisible() == 1 then
              return t "<C-p>"
            --elseif vim.fn['vsnip#jumpable'](-1) == 1 then
            --  return t "<Plug>(vsnip-jump-prev)"
            else
              -- If <S-Tab> is not working in your terminal, change it to <C-h>
              return t "<S-Tab>"
            end
          end

          vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
          vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
          vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
          vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
          '';
      }
      popup-nvim
      plenary-nvim
      { plugin = telescope-nvim;
        config =
          ''
          nnoremap <space>o <cmd>Telescope find_files<cr>
          nnoremap <space>t <cmd>tabnew<cr><cmd>Telescope find_files<cr>
          '';
      }
      #{ plugin = vim-ormolu;
      #  config = "let g:ormolu_options=[\"-o -XTypeApplications\"]";
      #}
      { plugin = vim-prettier;
        config = ''
          let g:prettier#autoformat_config_present = 1
          let g:prettier#autoformat_require_pragma = 0
          '';
      }
      { plugin = null-ls-nvim;
        type = "lua";
        config = ''
          local null_ls = require("null-ls")
          null_ls.setup({
            sources = {
              null_ls.builtins.diagnostics.shellcheck,
              null_ls.builtins.code_actions.shellcheck
            },
            on_attach = on_attach
          })
        '';
      }
      nvim-web-devicons
      {
        plugin = trouble-nvim;
        type = "lua";
        config = ''
          require("trouble").setup { }
          vim.api.nvim_set_keymap("n", "<leader>d", "<cmd>TroubleToggle document_diagnostics<cr>",
            {silent = true, noremap = true}
          )
          vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
            {silent = true, noremap = true}
          )
          vim.api.nvim_set_keymap("n", "<leader>r", "<cmd>Trouble lsp_references<cr>",
            {silent = true, noremap = true}
          )
        '';
      }
    ];
  };
}
