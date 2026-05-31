{pkgs, ...}: {
  programs.lazyvim = {
    enable = true;

    extras = {
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
          { "bluz71/vim-moonfly-colors", name = "moonfly", priority = 1000 },
          {
            "LazyVim/LazyVim",
            opts = {
              colorscheme = "moonfly",
            },
          },
        }
      '';

      # Animation Template: Customize mini.animate
      "mini-animate" = ''
        return {
          "echasnovski/mini.animate",
          opts = function(_, opts)
            local animate = require("mini.animate")
            return vim.tbl_deep_extend("force", opts or {}, {
              resize = {
                timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
              },
              scroll = {
                timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
              }
            })
          end,
        }
      '';

      # AI: CodeCompanion with Ollama
      codecompanion = ''
        return {
          "olimorris/codecompanion.nvim",
          dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
          },
          opts = {
            strategies = {
              chat = { adapter = "ollama" },
              inline = { adapter = "ollama" },
            },
            adapters = {
              ollama = function()
                return require("codecompanion.adapters").extend("ollama", {
                  schema = {
                    model = {
                      default = "qwen2.5-coder:3b",
                    },
                    num_ctx = {
                      default = 8192,
                    },
                  },
                })
              end,
            },
          },
          keys = {
            { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat", mode = { "n", "v" } },
            { "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "AI Inline", mode = { "n", "v" } },
            { "ga", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to AI Chat", mode = "v" },
          },
        }
      '';

      # AI: Minuet for Ghost Text (Copilot-style)
      minuet = ''
        return {
          "milanglacier/minuet-ai.nvim",
          dependencies = { "nvim-lua/plenary.nvim" },
          lazy = false, -- Force load
          opts = {
            provider = "openai_fim_compatible",
            provider_options = {
              openai_fim_compatible = {
                model = "qwen2.5-coder:3b",
                end_point = "http://127.0.0.1:11434/v1/completions",
                api_key = function() return "ollama" end, 
                name = "ollama", 
                stream = true,
                optional = {
                  max_tokens = 256,
                  stop = { "\n" },
                },
              },
            },
            virtualtext = {
              enabled = true,
              auto_trigger_ft = { "*" },
              keymap = {
                accept = "<C-y>",
                next = "<A-n>",
                prev = "<A-p>",
                dismiss = "<A-e>",
              },
            },
          },
        }
      '';

      # Integration with blink.cmp
      "blink-cmp" = ''
        return {
          "saghen/blink.cmp",
          opts = function(_, opts)
            opts.sources = opts.sources or {}
            opts.sources.default = vim.list_extend(opts.sources.default or {}, { "minuet" })
            opts.sources.providers = opts.sources.providers or {}
            opts.sources.providers.minuet = {
              name = "minuet",
              module = "minuet.blink",
              score_offset = 8,
            }
            return opts
          end,
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
    ];

    # Declarative configuration "the nix way"
    config = {
      options = ''
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
        vim.g.autoformat = true
        vim.opt.background = "dark"
      '';
    };
  };
}
