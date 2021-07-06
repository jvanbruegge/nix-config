{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    bat
    haskell-language-server
    nodePackages.typescript
    nodePackages.typescript-language-server
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
      vim-airline
      { plugin = vim-airline-themes;
        config =
          ''
          let g:airline_theme = 'badwolf'
          let g:airline_powerline_fonts = 1
          '';
      }
      { plugin = nvim-lspconfig;
        config =
          ''
          lua <<EOF
          require'lspconfig'.hls.setup{}
          require'lspconfig'.tsserver.setup{}
          EOF
          '';
      }
      { plugin = nvim-compe;
        config =
          ''
          lua <<EOF
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
              vsnip = true;
              ultisnips = true;
            };
          }
          EOF
          '';
      }
      popup-nvim
      plenary-nvim
      { plugin = telescope-nvim;
        config =
          ''
          nnoremap <leader>o <cmd>Telescope find_files<cr>
          nnoremap <leader>t <cmd>tabnew<cr><cmd>Telescope find_files<cr>
          '';
      }
    ];
  };
}
