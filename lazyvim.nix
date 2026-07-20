{pkgs, ...}: {
  programs.lazyvim = {
    enable = true;

    extras = {
      # AI
      #  ai.copilot.enable = true;  

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
      # Theme Template: Moonfly
      colorscheme = ''
        return {
          { "morhetz/gruvbox", priority = 1000 },
          { "matsuuu/pinkmare", priority = 1000 },
          { "rockerBOO/boo-colorscheme-nvim", priority = 1000 },
          { "folke/tokyonight.nvim", priority = 1000 },
          {
            "LazyVim/LazyVim",
            opts = {
              colorscheme = "tokyonight",
            },
          },
        }
      '';

      # Animation Template: Customize mini.animate
      # # "mini-animate" = ''
      #   return {
      #     "mini-nvim/mini.animate",
      #     opts = function(_, opts)
      #       local animate = require("mini.animate")
      #       return vim.tbl_deep_extend("force", opts or {}, {
      #         resize = {
      #           timing = animate.gen_timing.linear({ duration = 10, unit = "total" }),
      #         },
      #         scroll = {
      #           timing = animate.gen_timing.linear({ duration = 20, unit = "total" }),
      #         }
      #       })
      #     end,
      #   }
      # '';

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
