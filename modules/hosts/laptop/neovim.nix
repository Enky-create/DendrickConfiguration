{ self, inputs, ... }: {
  flake.nixosModules.neovim = { config, pkgs, ... }: {
    imports = [ inputs.nixvim.nixosModules.nixvim ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true; # EDITOR=nvim системно

      colorschemes.gruvbox.enable = true;

      globalOpts = {
        number = true;
        relativenumber = true;
        expandtab = true;
        shiftwidth = 4;
        tabstop = 4;
      };

      # --- Treesitter ---
      plugins.treesitter = {
        enable = true;
        settings.ensure_installed = [ "c_sharp" "lua" "vim" "vimdoc" "nix" "json" "xml" "yaml" ];
      };

      # --- LSP: omnisharp для C#/Unity ---
      plugins.lsp = {
        enable = true;
        servers.omnisharp = {
          enable = true;
          package = pkgs.omnisharp-roslyn;
          settings = {
            enableRoslynAnalyzers = true;
            enableImportCompletion = true;
            organizeImportsOnFormat = true;
            RoslynExtensionsOptions = {
              enableDecompilationSupport = true;
              enableAnalyzersSupport = true;
            };
          };
        };
      };

      # --- автодополнение ---
      plugins.cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };

      # --- навигация / поиск ---
      plugins.telescope.enable = true;
      plugins.which-key.enable = true;
      plugins.lualine.enable = true;

      # --- отладка (обычный .NET debugger) ---
      plugins.dap = {
        enable = true;
        adapters.executables.netcoredbg = {
          command = "${pkgs.netcoredbg}/bin/netcoredbg";
          args = [ "--interpreter=vscode" ];
        };
        configurations.cs = [
          {
            type = "netcoredbg";
            name = "Launch";
            request = "launch";
            program = "\${fileDirname}/bin/Debug/net9.0/\${fileBasenameNoExtension}.dll";
          }
        ];
      };

      extraPackages = [ pkgs.netcoredbg ];
        extraConfigLua = ''
          vim.g.mapleader = " "
          vim.g.maplocalleader = " "
        '';

    

    # Telescope — поиск файлов/текста
    plugins.telescope.keymaps = {
      "<leader>ff" = "find_files";
      "<leader>fg" = "live_grep";
      "<leader>fb" = "buffers";
      "<leader>fh" = "help_tags";
    };

    # LSP — работает только когда omnisharp реально подключился к буферу
    plugins.lsp.keymaps = {
      diagnostic = {
        "<leader>dd" = "open_float";
        "[d" = "goto_prev";
        "]d" = "goto_next";
      };
      lspBuf = {
        gd = "definition";
        gD = "declaration";
        gr = "references";
        gi = "implementation";
        K = "hover";
        "<leader>rn" = "rename";
        "<leader>ca" = "code_action";
      };
    };

    # Автодополнение в insert-режиме
    plugins.cmp.settings.mapping = {
      "<C-Space>" = "cmp.mapping.complete()";
      "<CR>" = "cmp.mapping.confirm({ select = true })";
      "<Tab>" = "cmp.mapping.select_next_item()";
      "<S-Tab>" = "cmp.mapping.select_prev_item()";
    };

    # DAP — отладка
    keymaps = [
      { mode = "n"; key = "<leader>e"; action = "<cmd>Ex<CR>"; options.desc = "Файловый браузер"; }
      { mode = "n"; key = "<leader>w"; action = "<cmd>w<CR>"; options.desc = "Сохранить"; }
      { mode = "n"; key = "<leader>q"; action = "<cmd>q<CR>"; options.desc = "Закрыть"; }
      { mode = "n"; key = "<F5>"; action.__raw = "function() require('dap').continue() end"; options.desc = "Debug: continue"; }
      { mode = "n"; key = "<F10>"; action.__raw = "function() require('dap').step_over() end"; }
      { mode = "n"; key = "<F11>"; action.__raw = "function() require('dap').step_into() end"; }
      { mode = "n"; key = "<leader>b"; action.__raw = "function() require('dap').toggle_breakpoint() end"; options.desc = "Toggle breakpoint"; }
    ];
    };
  };
}
