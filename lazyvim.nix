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
              colorscheme = "gruvbox",
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

        -- -- AMOLED Black background and visibility overrides
        -- vim.api.nvim_create_autocmd("ColorScheme", {
        --   pattern = "*",
        --   callback = function()
        --      local bg_groups = {
        --        "Normal",
        --        "NormalNC",
        --        "SignColumn",
        --        "MsgArea",
        --        "EndOfBuffer",
        --      }
        --      for _, group in ipairs(bg_groups) do
        --        vim.api.nvim_set_hl(0, group, { bg = "#000000" })
        --      end
        --
        --      -- Visibility overrides for ghost text and inlay hints
        --      local visibility_groups = {
        --        "CmpGhostText",
        --        "BlinkCmpGhostText",
        --        "CopilotSuggestion",
        --        "LspInlayHint",
        --      }
        --      for _, group in ipairs(visibility_groups) do
        --        vim.api.nvim_set_hl(0, group, { fg = "#bbbbbb", italic = true })
        --     end
        --   end,
        -- })


        return {
  "folke/snacks.nvim",
  opts = {
    words = {
      enabled = true,
    },
  },
}
      '';
    };
   };
}
