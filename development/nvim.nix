{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    bat
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.bash-language-server
    nixd
    ormolu
    gcc
    shellcheck
  ];

  programs.neovim = {
    enable = true;

    extraLuaPackages = ps: [ ps.magick ];
    extraPackages = with pkgs; [ imagemagick ];

    extraLuaConfig = ''
      local k = vim.keycode
      vim.g.mapleader = k('<space>')

      vim.o.swapfile = false
      vim.o.nrformats = "bin,hex,alpha"
      vim.o.signcolumn = "yes"

      vim.o.expandtab = true
      vim.o.smarttab = true
      vim.o.shiftwidth = 2
      vim.o.softtabstop = 2
      vim.o.tabstop = 2

      -- No stupid autoindent
      vim.cmd('filetype indent off')
      vim.o.autoindent = true
      vim.o.smartindent = true

      vim.o.scrolloff = 5

      -- Enable copy + paste from the clipboard
      vim.keymap.set('v', '<leader>y', '"+y')
      vim.keymap.set('n', '<leader>y', '"+yy')
      vim.keymap.set('n', '<leader>p', '"+p')
      vim.keymap.set('n', '<leader>P', '"+P')

      -- Navigate tabs
      vim.keymap.set('n', 'J', vim.cmd.tabp)
      vim.keymap.set('n', 'K', vim.cmd.tabn)

      -- Splits
      vim.o.splitright = true
      vim.keymap.set('n', '<C-3>', vim.cmd.vsplit)
      vim.keymap.set('n', 'A', '<C-W>h')
      vim.keymap.set('n', 'D', '<C-W>l')

      -- Show file in window title
      vim.opt.title = true
    '';

    plugins = with pkgs.vimPlugins; [
      { plugin = nvim-treesitter.withPlugins (p: with p; [
          c java yaml xml wgsl_bevy vim typescript tsx toml ssh_config sql scss
          rust rst ron regex python nix markdown markdown_inline make lua latex
          json javascript html haskell gitignore gitcommit gitattributes vimdoc
          dockerfile diff css cpp bibtex bash
        ]);
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup({
            auto_install = false;
            highlight = {
              enable = true,
            }
          })
        '';
      }
      /*{ plugin = pkgs.vimUtils.buildVimPlugin rec {
          pname = "profile.nvim";
          version = "2025-03-05";
          src = pkgs.fetchFromGitHub {
            owner = "stevearc";
            repo = pname;
            rev = "30433d7513f0d14665c1cfcea501c90f8a63e003";
            hash = "sha256-2Mk6VbC+K/WhTWF+yHyDhQKJhTi2rpo8VJsnO7ofHXs=";
          };
        };
        type = "lua";
        config = ''
          local should_profile = os.getenv("NVIM_PROFILE")
          if should_profile then
            require("profile").instrument_autocmds()
            if should_profile:lower():match("^start") then
              require("profile").start("*")
            else
              require("profile").instrument("*")
            end
          end

          local function toggle_profile()
            local prof = require("profile")
            if prof.is_recording() then
              prof.stop()
              vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
                if filename then
                  prof.export(filename)
                  vim.notify(string.format("Wrote %s", filename))
                end
              end)
            else
              prof.start("*")
            end
          end
          vim.keymap.set("", "<f1>", toggle_profile)
        '';
      }*/
      { plugin = tokyonight-nvim;
        type = "lua";
        config = ''
          require('tokyonight').setup({
            style = 'moon',
          })
          vim.cmd.colorscheme('tokyonight')
        '';
      }
      nvim-web-devicons
      telescope-fzf-native-nvim
      plenary-nvim
      { plugin = telescope-nvim;
        type = "lua";
        config = ''
          local telescope = require('telescope')
          local find_cmd = { 'rg', '--files', '--hidden', '--glob', '!**/.git' }

          telescope.setup({
            pickers = {
              find_files = {
                find_command = find_cmd,
              },
            },
          })
          telescope.load_extension('fzf')

          local builtin = require('telescope.builtin')
          local actions = require('telescope.actions')
          vim.keymap.set('n', '<leader>o', builtin.find_files)
          vim.keymap.set('n', '<leader>t', function()
            builtin.find_files({
              attach_mappings = function(_, map)
                map({ 'i', 'n' }, '<CR>', actions.select_tab)
                return true
              end,
            })
          end)
        '';
      }
      /*{ plugin = image-nvim;
        type = "lua";
        config = ''
          require("image").setup({
            html = {
              enabled = true,
            },
            css = {
              enabled = true,
            },
          })
        '';
      }*/
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      lspkind-nvim
      { plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp = require('cmp')
          local lspkind = require('lspkind')

          local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
          end

          cmp.setup({
            snippet = {
              expand = function(args)
                vim.snippet.expand(args.body)
              end,
            },
            window = {
              documentation = {
                max_width = 100,
              },
            },
            formatting = {
              format = lspkind.cmp_format({
                mode = 'symbol_text',
                maxwidth = 50,
                menu = ({
                  buffer = '[Buffer]',
                  nvim_lsp = '[LSP]',
                  path = '[Path]',
                })
              }),
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              -- Smart tab completion
              ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { 'i', 's' }),
              ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                else
                  fallback()
                end
              end, { 'i', 's' }),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'buffer' },
              { name = 'path' },
            }),
          })
        '';
      }
      { plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          local gitsigns = require('gitsigns')

          gitsigns.setup({
            on_attach = function(bufnr)
              local opts = { buffer = bufnr }
              vim.keymap.set('n', '<leader>b', gitsigns.toggle_current_line_blame, opts)
            end
          })
        '';
      }
      trouble-nvim
      { plugin = fidget-nvim;
        type = "lua";
        config = ''
          require('fidget').setup({
            progress = {
              display = {
                done_ttl = 2,
              },
            },
          })
        '';
      }
      { plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup({
            sections = {
              lualine_x = { 'filetype', function()
                local clients = vim.lsp.get_active_clients()
                if next(clients) == nil then
                  return 'LSP \u{f0159}'
                end
                return 'LSP \u{f05e0}'
              end },
            },
          })
        '';
      }
      { plugin = whitespace-nvim;
        type = "lua";
        config = ''
          local whitespace = require('whitespace-nvim')
          whitespace.setup()
          vim.keymap.set('n', 'tr', whitespace.trim)
        '';
      }
      /* { plugin = aw-watcher-nvim.overrideAttrs (_: {
          patches = [ (pkgs.fetchpatch {
            url = "https://github.com/lowitea/aw-watcher.nvim/pull/8.patch";
            hash = "sha256-XBkSr2AAbSkJpE6tg2XVPAfGnNJ6dCdxRIMrBHaa1T8=";
          }) ];
      });
        type = "lua";
        config = ''
          local watcher = require('aw_watcher')
          watcher.setup({})
        '';
      } */
      { plugin = pkgs.vimUtils.buildVimPlugin rec {
          pname = "isabelle-syn.nvim";
          version = "2024-05-15";
          src = pkgs.fetchFromGitHub {
            owner = "Treeniks";
            repo = pname;
            rev = "114b06dc34edf1707be7249b5a3815733e68d4c9";
            hash = "sha256-f04jyExUwos9w89IeKbRdRMtWIsQYe0McAUoijq7mCA=";
          };
        };
      }
      /*{ plugin = pkgs.vimUtils.buildVimPlugin rec {
          pname = "isabelle-lsp.nvim";
          version = "2024-07-20";
          src = pkgs.fetchFromGitHub {
            owner = "Treeniks";
            repo = pname;
            rev = "206cca02a9b95925f362cea35b1fba2a24dff37b";
            hash = "sha256-mbiUvthEQHQvmNGZtFccasiQ0ksFP0XpZzzK79m14UU=";
          };
          postUnpack = ''
            substituteInPlace source/lua/isabelle-lsp.lua \
              --replace-fail "~/Documents/isabelle/isabelle-lsp.log'," "~/.local/state/isabelle-lsp.log', '-l', 'Prelim'"
          '';
        };
        type = "lua";
        config = ''
          require('isabelle-lsp').setup({})
        '';
      }*/
      { plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local lspconfig = require('lspconfig')
          local trouble = require('trouble')

          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

          local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr }
            vim.keymap.set('n', '<c-i>', vim.lsp.buf.format, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', '<leader>q', vim.lsp.buf.code_action, opts)

            vim.keymap.set('n', '<leader>d', function()
              trouble.toggle('diagnostics')
            end, opts)
            vim.keymap.set('n', '<leader>r', function()
              trouble.toggle('lsp_references')
            end, opts)

            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
          end

          local servers = { 'rust_analyzer', 'bashls', 'ts_ls' }
          for _, lsp in ipairs(servers) do
            lspconfig[lsp].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end

          -- lspconfig.isabelle.setup({})

          lspconfig.hls.setup({
            filetypes = { 'haskell', 'lhaskell', 'cabal' },
            capabilities = capabilities,
            on_attach = on_attach,
          })
          lspconfig.nixd.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              nixd = {
                diagnostic = {
                  suppress = { 'sema-escaping-with' },
                },
              },
            },
          })
        '';
      }
    ];
  };
}
