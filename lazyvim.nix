{pkgs, ...}: {
  programs.lazyvim = {
    enable = true;

    extras = {
      # AI
      ai.copilot.enable = true;  

      # Languages
      lang.nix.enable = true;
      lang.python = {
        enable = true;
        installDependencies = true; # Install ruff
        installRuntimeDependencies = true; # Install python3
      };
      lang.typescript = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };

      # UI & Aesthetics
      ui.mini-animate.enable = true; # Smooth animations
      editor.neo-tree.enable = true; # File explorer
      coding.mini-surround.enable = true; # Surround actions
      coding.blink.enable = true; # Enable blink.cmp completion engine
    };

    # Custom Plugin Configurations (Templates)
    plugins = {
      # Curated Theme Bundle & Themery Live-Preview Theme Switcher
      colorscheme = ''
        return {
          -- 1. User Favorites & Primary Themes
          { "matsuuu/pinkmare", lazy = false, priority = 1000 },
          { "connorwyatt/themes.nvim", lazy = true },
          {
            "catppuccin/nvim",
            name = "catppuccin",
            lazy = true,
            opts = {
              integrations = {
                indent_blankline = { enabled = false },
                ibl = { enabled = true },
              },
            },
          },
          { "rose-pine/neovim", name = "rose-pine", lazy = true },
          { "scottmckendry/cyberdream.nvim", lazy = true },

          -- 2. Modern Aesthetic & Popular Community Neovim Themes (Lazy-loaded)
          { "folke/tokyonight.nvim", lazy = true },
          { "rebelot/kanagawa.nvim", lazy = true },
          { "EdenEast/nightfox.nvim", lazy = true },
          { "nyoom-engineering/oxocarbon.nvim", lazy = true, build = false },
          { "craftzdog/solarized-osaka.nvim", lazy = true },
          { "sainnhe/sonokai", lazy = true },
          { "sainnhe/gruvbox-material", lazy = true },
          { "sainnhe/everforest", lazy = true },
          { "olivercederborg/poimandres.nvim", lazy = true },
          { "maxmx03/dracula.nvim", lazy = true },
          { "ellisonleao/gruvbox.nvim", lazy = false, priority = 1000 },
          { "navarasu/onedark.nvim", lazy = true },
          { "shaunsingh/nord.nvim", lazy = true },
          { "projekt0n/github-nvim-theme", lazy = true },
          { "marko-cerovac/material.nvim", lazy = true },
          { "uloco/bluloco.nvim", lazy = true },
          { "slugbyte/lackluster.nvim", lazy = true },
          { "ribru17/bamboo.nvim", lazy = true },
          { "tiagovla/tokyodark.nvim", lazy = true },
          { "AlexvZyl/nordic.nvim", lazy = true },
          { "Shatur/neovim-ayu", lazy = true },
          { "kvrohit/mellow.nvim", lazy = true },
          { "savq/melange-nvim", lazy = true },
          { "vague2k/vague.nvim", lazy = true },

          -- 3. Themery plugin for persistent theme saving and live preview
          {
            "zaldih/themery.nvim",
            lazy = false,
            priority = 1000,
            cmd = "Themery",
            keys = {
              { "<leader>th", "<cmd>Themery<cr>", desc = "Theme Browser (Themery)" },
              { "<leader>ut", "<cmd>Themery<cr>", desc = "Theme Browser (Themery)" },
            },
            opts = {
              livePreview = true,
              themes = {
                { name = "Gruvbox (Default)", colorscheme = "gruvbox" },
                { name = "Pinkmare (Favorite)", colorscheme = "pinkmare" },
                { name = "Catppuccin Mocha", colorscheme = "catppuccin-mocha" },
                { name = "Catppuccin Macchiato", colorscheme = "catppuccin-macchiato" },
                { name = "Catppuccin Frappe", colorscheme = "catppuccin-frappe" },
                { name = "Rosé Pine", colorscheme = "rose-pine" },
                { name = "Rosé Pine Moon", colorscheme = "rose-pine-moon" },
                { name = "Cyberdream (Neon)", colorscheme = "cyberdream" },
                { name = "Tokyo Night", colorscheme = "tokyonight-night" },
                { name = "Tokyo Night Storm", colorscheme = "tokyonight-storm" },
                { name = "Tokyo Night Moon", colorscheme = "tokyonight-moon" },
                { name = "Kanagawa Wave", colorscheme = "kanagawa-wave" },
                { name = "Kanagawa Dragon", colorscheme = "kanagawa-dragon" },
                { name = "Sakura Night", colorscheme = "sakura-night" },
                { name = "Sakura Dusk", colorscheme = "sakura-dusk" },
                { name = "Nightfox", colorscheme = "nightfox" },
                { name = "Duskfox", colorscheme = "duskfox" },
                { name = "Nordfox", colorscheme = "nordfox" },
                { name = "Terafox", colorscheme = "terafox" },
                { name = "Carbonfox", colorscheme = "carbonfox" },
                { name = "Oxocarbon", colorscheme = "oxocarbon" },
                { name = "Solarized Osaka", colorscheme = "solarized-osaka" },
                { name = "Sonokai", colorscheme = "sonokai" },
                { name = "Gruvbox Material", colorscheme = "gruvbox-material" },
                { name = "Everforest", colorscheme = "everforest" },
                { name = "Poimandres", colorscheme = "poimandres" },
                { name = "Dracula", colorscheme = "dracula" },
                { name = "OneDark", colorscheme = "onedark" },
                { name = "Nord", colorscheme = "nord" },
                { name = "Nordic", colorscheme = "nordic" },
                { name = "GitHub Dark", colorscheme = "github_dark" },
                { name = "GitHub Dark Dimmed", colorscheme = "github_dark_dimmed" },
                { name = "Material", colorscheme = "material" },
                { name = "Bluloco Dark", colorscheme = "bluloco-dark" },
                { name = "Lackluster", colorscheme = "lackluster" },
                { name = "Bamboo", colorscheme = "bamboo" },
                { name = "TokyoDark", colorscheme = "tokyodark" },
                { name = "Ayu Dark", colorscheme = "ayu-dark" },
                { name = "Ayu Mirage", colorscheme = "ayu-mirage" },
                { name = "Mellow", colorscheme = "mellow" },
                { name = "Melange", colorscheme = "melange" },
                { name = "Vague", colorscheme = "vague" },
              },
            },
          },

          -- 4. Lazy.nvim options & Default theme fallback
          {
            "folke/lazy.nvim",
            opts = {
              rocks = {
                enabled = false,
              },
            },
          },
          {
            "LazyVim/LazyVim",
            opts = {
               colorscheme = "gruvbox",
            },
          },
        }
      '';

      "neoscroll.nvim" = ''
        return {
          "karb94/neoscroll.nvim",
          opts = {},
        }
      '';
      "tiny-glimmer.nvim" = ''
        return {
          "mawkler/tiny-glimmer.nvim",
          opts = {},
        }
      '';
      "smear-cursor.nvim" = ''
        return {
          "sphamba/smear-cursor.nvim",
          opts = {},
        }
      '';
      "snacks.nvim" = ''
        return {
          "folke/snacks.nvim",
          opts = {
            words = {
              enabled = false,
            },
          },
        }
      '';
      "nvim-lspconfig" = ''
        return {
          "neovim/nvim-lspconfig",
          opts = {
            inlay_hints = {
              enabled = false,
            },
            servers = {
              pyright = {
                settings = {
                  python = {
                    analysis = {
                      diagnosticMode = "openFilesOnly",
                      typeCheckingMode = "basic",
                    },
                  },
                },
              },
              basedpyright = {
                settings = {
                  basedpyright = {
                    analysis = {
                      diagnosticMode = "openFilesOnly",
                      typeCheckingMode = "basic",
                    },
                  },
                },
              },
            },
          },
        }
      '';

    };

    extraPackages = with pkgs; [
      nixd # Nix LSP
      alejandra # Nix formatter
      statix # Nix linter
      deadnix # Nix dead code cleaner
      pyright # Python LSP
      ruff # Python linter/formatter
      typescript-language-server
      vtsls # Enhanced TypeScript LSP
      prettierd # Fast formatter for various languages
      nodejs
    ];

    config = {
      options = ''
        vim.opt.termguicolors = true
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
        vim.g.autoformat = true
        vim.opt.background = "dark"
        vim.opt.hlsearch = false
        vim.g.ai_cmp = false
        vim.opt.guifont = "SF Mono:h12"

        -- Theme visibility overrides
        vim.api.nvim_create_autocmd("ColorScheme", {
          pattern = "*",
          callback = function()

             -- Visibility overrides for ghost text and inlay hints
             local visibility_groups = {
               "CmpGhostText",
               "BlinkCmpGhostText",
               "CopilotSuggestion",
               "LspInlayHint",
             }
             for _, group in ipairs(visibility_groups) do
               vim.api.nvim_set_hl(0, group, { fg = "#bbbbbb", italic = true })
             end

             -- Make split borders more visible (using Tokyonight purple)
             local border_groups = {
               "WinSeparator",
               "VertSplit",
             }
             for _, group in ipairs(border_groups) do
               vim.api.nvim_set_hl(0, group, { fg = "#bb9af7", bold = true })
             end

          end,
        })
      '';

      keymaps = ''
        -- Visual mode direct surround mappings (VS Code style)
        local surround_mappings = {
          ["("] = ")",
          [")"] = ")",
          ["["] = "]",
          ["]"] = "]",
          ["{"] = "}",
          ["}"] = "}",
          ['"'] = '"',
          ["'"] = "'",
          ["`"] = "`",
        }

        for lhs, rhs in pairs(surround_mappings) do
          vim.keymap.set("x", lhs, "gsa" .. rhs, { remap = true, desc = "Surround with " .. lhs })
        end
     '';
    };
  };
}
