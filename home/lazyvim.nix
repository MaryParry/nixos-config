{pkgs, ...}: {
  programs.lazyvim = {
    enable = true;

    extras = {
      #AI
      #      ai.copilot.enable = true;   ### Disabled cause copilot sucks, todo: implement a better local llm for nvim

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
          { "matsuuu/pinkmare", lazy = true },
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
          { "robertmeta/nofrils", lazy = true },
          { "andreasvc/vim-256noir", lazy = true },
          { "vim-scripts/true-monochrome", lazy = true },
          { "ailrk/vim-monochrome-waifu", lazy = true },

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
                { name = "Nofrils Dark", colorscheme = "nofrils-dark" },
                { name = "Nofrils Light", colorscheme = "nofrils-light" },
                { name = "Nofrils Sepia", colorscheme = "nofrils-sepia" },
                { name = "Nofrils Acme", colorscheme = "nofrils-acme" },
                { name = "256 Noir", colorscheme = "256_noir" },
                { name = "True Monochrome", colorscheme = "true-monochrome" },
                { name = "Monochrome Waifu", colorscheme = "vim-monochrome-waifu" },
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
            dashboard = {
              enabled = true,
              preset = {
                header = [[
        ╔═══════════════════════════════════════════════════════════════════════════════════╗
        ║  ██████╗   ██████╗   ██╗  ███╗   ███╗  ███╗   ███╗    ██╗   ██╗  ██╗  ███╗   ███╗ ║
        ║ ██╔════╝   ██╔══██╗  ██║  ████╗ ████║  ████╗ ████║    ██║   ██║  ██║  ████╗ ████║ ║
        ║ ██║  ███╗  ██████╔╝  ██║  ██╔████╔██║  ██╔████╔██║    ██║   ██║  ██║  ██╔████╔██║ ║
        ║ ██║   ██║  ██╔══██╗  ██║  ██║╚██╔╝██║  ██║╚██╔╝██║    ╚██╗ ██╔╝  ██║  ██║╚██╔╝██║ ║
        ║ ╚██████╔╝  ██║  ██║  ██║  ██║ ╚═╝ ██║  ██║ ╚═╝ ██║     ╚████╔╝   ██║  ██║ ╚═╝ ██║ ║
        ║  ╚═════╝   ╚═╝  ╚═╝  ╚═╝  ╚═╝     ╚═╝  ╚═╝     ╚═╝      ╚═══╝    ╚═╝  ╚═╝     ╚═╝ ║
        ╚═══════════════════════════════════════════════════════════════════════════════════╝
                ]],
              },
              formats = {
                footer = { "%s", align = "center" },
                header = { "%s", align = "center" },
              },
            },
            indent = {
              enabled = true,
              animate = {
                enabled = false,
              },
              scope = {
                enabled = false,
              },
              indent = {
                hl = {
                  "SnacksIndent1",
                  "SnacksIndent2",
                  "SnacksIndent3",
                  "SnacksIndent4",
                  "SnacksIndent5",
                  "SnacksIndent6",
                  "SnacksIndent7",
                },
              },
            },
            picker = {
              prompt = "> ",
              ui_select = true,
              formatters = {
                file = {
                  filename_first = true,
                  truncate = 100,
                },
              },
              layouts = {
                default = {
                  preview = false,
                  layout = {
                    box = "horizontal",
                    width = 0.99,
                    height = 0.99,
                    {
                      box = "vertical",
                      border = "bold",
                      title = "{source} {live}",
                      title_pos = "center",
                      { win = "input", height = 1, border = "bottom" },
                      { win = "list", border = "none" },
                    },
                    { win = "preview", title = "{preview}", border = "bold", width = 0.5 },
                  },
                },
              },
            },
            notifier = {
              enabled = true,
              timeout = 2000,
              style = "compact",
            },
          },
        }
      '';
      "bufferline" = ''
        return {
          "akinsho/bufferline.nvim",
          enabled = false,
        }
      '';
      "lualine" = ''
        local colors = {
          gruvBlue = "#83a598",
          gruvGreen = "#8ec07c",
          gruvPink = "#d3869b",
          gruvYellow = "#d8a657",
          gruvRed = "#FF4A4A",
          gruvWhite = "#fff4d2",
          gruvBlack = "#1d1d1d",
          gruvGray = "#393939",
          gruvDark = "#292929",
        }

        local gruv_material = {
          normal = {
            a = { bg = colors.gruvDark, fg = colors.gruvWhite, gui = "bold" },
            b = { bg = colors.gruvGray, fg = colors.gruvWhite, gui = "bold" },
            c = { bg = colors.gruvBlue, fg = colors.gruvBlack, gui = "bold" },
          },
          insert = {
            a = { bg = colors.gruvBlue, fg = colors.gruvBlack, gui = "bold" },
            c = { bg = colors.gruvPink, fg = colors.gruvBlack, gui = "bold" },
          },
          visual = {
            a = { bg = colors.gruvPink, fg = colors.gruvBlack, gui = "bold" },
            c = { bg = colors.gruvDark, fg = colors.gruvWhite, gui = "bold" },
          },
          command = {
            a = { bg = colors.gruvGreen, fg = colors.gruvBlack, gui = "bold" },
            c = { bg = colors.gruvBlack, fg = colors.gruvWhite, gui = "bold" },
          },
          terminal = {
            a = { bg = colors.gruvRed, fg = colors.gruvBlack, gui = "bold" },
            c = { bg = colors.gruvBlack, fg = colors.gruvWhite, gui = "bold" },
          },
          replace = {
            a = { bg = colors.gruvBlue, fg = colors.gruvBlack, gui = "bold" },
            c = { bg = colors.gruvPink, fg = colors.gruvBlack, gui = "bold" },
          },
          inactive = {
            a = { bg = colors.gruvGreen, fg = colors.gruvBlack, gui = "bold" },
            c = { bg = colors.gruvBlack, fg = colors.gruvWhite, gui = "bold" },
          },
        }

        return {
          "nvim-lualine/lualine.nvim",
          opts = {
            options = {
              theme = gruv_material,
              component_separators = { left = "|", right = "|" },
              section_separators = { left = "", right = "" },
              disabled_filetypes = { "snacks_dashboard" },
            },
            sections = {
              lualine_a = {
                "mode",
              },
              lualine_b = {
                "branch",
                "diff",
                "diagnostics",
                {
                  "buffers",
                  buffers_color = {
                    active = { bg = colors.gruvYellow, fg = colors.gruvBlack, gui = "bold" },
                    inactive = { bg = colors.gruvGray, fg = colors.gruvWhite, gui = "italic" },
                  },
                  symbols = {
                    modified = " ●",
                    alternate_file = "",
                    directory = "",
                  },
                  mode = 2,
                },
              },
              lualine_c = {
                {
                  "filename",
                  file_status = true,
                  path = 3,
                },
              },
              lualine_x = {
                "filesize",
              },
              lualine_y = {
                "searchcount",
                "selectioncount",
                "lsp_status",
                "filetype",
              },
              lualine_z = {
                "encoding",
                "location",
              },
            },
          },
          config = function(_, opts)
            require("lualine").setup(opts)
            vim.opt.laststatus = 3
          end,
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
                flags = {
                  debounce_text_changes = 500,
                },
                settings = {
                  python = {
                    analysis = {
                      autoSearchPaths = true,
                      diagnosticMode = "openFilesOnly",
                      typeCheckingMode = "off",
                      useLibraryCodeForTypes = false,
                      autoImportCompletions = false,
                      indexing = false,
                    },
                  },
                },
              },
              basedpyright = {
                flags = {
                  debounce_text_changes = 500,
                },
                settings = {
                  basedpyright = {
                    analysis = {
                      autoSearchPaths = true,
                      diagnosticMode = "openFilesOnly",
                      typeCheckingMode = "off",
                      useLibraryCodeForTypes = false,
                      autoImportCompletions = false,
                      indexing = false,
                    },
                  },
                },
              },
            },
          },
        }
      '';

      "neocord.nvim" = ''
        return {
          "IogaMaster/neocord",
          event = "VeryLazy",
          opts = {
            logo = "auto",
            logo_tooltip = "Neovim",
            main_image = "language",
            log_level = nil,
            debounce_timeout = 5,
            blacklist = {},
            file_assets = {},
            show_time = true,
            global_timer = false,
            auto_update = true,

            -- Rich Presence text options
            editing_text = "Editing %s",
            file_explorer_text = "Browsing %s",
            git_commit_text = "Committing changes",
            plugin_manager_text = "Managing plugins",
            reading_text = "Reading %s",
            workspace_text = "Working on %s",
            line_number_text = "Line %s out of %s",
            terminal_text = "Using Terminal",
          },
          config = function(_, opts)
            -- 1. Fix get_gui_info crash in terminal/headless (chan.client is nil)
            local ok_utils, utils = pcall(require, "neocord.utils")
            if ok_utils then
              utils.get_gui_info = function()
                local ok_chan, chan = pcall(vim.api.nvim_get_chan_info, 1)
                if ok_chan and chan and chan.client and chan.client.type == "ui" then
                  return chan.client.name
                end
                return nil
              end
            end

            local neocord = require("neocord")

            -- 2. Dynamic multi-socket scanner (discord-ipc-0 to discord-ipc-9 across runtime dirs)
            local function find_discord_socket()
              local uid = (vim.loop.getuid and vim.loop.getuid()) or 1000
              local dirs = {
                os.getenv("XDG_RUNTIME_DIR"),
                "/run/user/" .. uid,
                os.getenv("TMPDIR"),
                "/tmp",
              }
              for _, dir in ipairs(dirs) do
                if dir and vim.fn.isdirectory(dir) == 1 then
                  for i = 0, 9 do
                    local sock = dir:gsub("/+$", "") .. "/discord-ipc-" .. i
                    if vim.loop.fs_stat(sock) then
                      return sock
                    end
                  end
                end
              end
              return (os.getenv("XDG_RUNTIME_DIR") or ("/run/user/" .. uid)) .. "/discord-ipc-0"
            end

            neocord.get_discord_socket_path = function()
              return find_discord_socket()
            end

            -- 3. Auto-reconnect on pipe close / pipe error when Discord restarts
            local ok_discord, Discord = pcall(require, "lib.discord")
            if ok_discord then
              local orig_connect = Discord.connect
              Discord.connect = function(self, on_connect)
                local sock = find_discord_socket()
                if sock then
                  self.ipc_socket = sock
                end
                if not self.pipe or self.pipe:is_closing() or not self.pipe:is_active() then
                  self.pipe = vim.loop.new_pipe(false)
                end
                orig_connect(self, on_connect)
              end

              local orig_read = Discord.read_message
              Discord.read_message = function(self, nonce, on_response, err, chunk)
                if (not chunk and not err) or (err and type(err) == "string" and err:find("EPIPE")) then
                  neocord.is_connected = false
                  neocord.is_authorized = false
                end
                return orig_read(self, nonce, on_response, err, chunk)
              end
            end

            neocord.setup(opts)

            -- Initial update when buffer is ready
            vim.defer_fn(function()
              pcall(function() neocord:update() end)
            end, 800)
          end,
        }
      '';

      "minuet-ai.nvim" = ''
        return {
          {
            "milanglacier/minuet-ai.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            opts = {
              provider = "openai_fim_compatible",
              n_completions = 1,
              context_window = 2048,
              debounce = 300,
              throttle = 1000,
              request_timeout = 12,
              notify = "warn",
              virtualtext = {
                auto_trigger_ft = { "*" },
                auto_trigger_ignore_ft = {
                  "gitcommit",
                  "gitrebase",
                  "TelescopePrompt",
                  "neo-tree",
                  "lazy",
                  "snacks_picker_input",
                },
                show_on_completion_menu = true,
                keymap = {
                  accept = "<A-y>",
                  accept_line = "<A-l>",
                  prev = "<A-[>",
                  next = "<A-]>",
                  dismiss = "<A-e>",
                },
              },
              provider_options = {
                openai_fim_compatible = {
                  model = "qwen2.5-coder:1.5b",
                  end_point = "http://127.0.0.1:11434/v1/completions",
                  api_key = "TERM",
                  name = "Ollama",
                  stream = true,
                  optional = {
                    max_tokens = 56,
                    top_p = 0.9,
                    keep_alive = "1h",
                  },
                },
              },
            },
          },
          {
            "saghen/blink.cmp",
            optional = true,
            opts = function(_, opts)
              opts.appearance = opts.appearance or {}
              opts.appearance.nerd_font_variant = "mono"
              opts.completion = opts.completion or {}
              opts.completion.menu = opts.completion.menu or {}
              opts.completion.menu.border = "bold"
              opts.completion.menu.scrollbar = false
              opts.completion.documentation = opts.completion.documentation or {}
              opts.completion.documentation.window = opts.completion.documentation.window or {}
              opts.completion.documentation.window.border = "bold"

              opts.sources = opts.sources or {}
              opts.sources.default = opts.sources.default or { "lsp", "path", "snippets", "buffer" }
              if not vim.tbl_contains(opts.sources.default, "minuet") then
                table.insert(opts.sources.default, "minuet")
              end
              opts.sources.providers = opts.sources.providers or {}
              opts.sources.providers.minuet = {
                name = "minuet",
                module = "minuet.blink",
                score_offset = 8,
              }
              opts.keymap = opts.keymap or {}
              opts.keymap["<Tab>"] = {
                function(cmp)
                  if cmp.is_visible() then
                    return cmp.accept()
                  end
                  local minuet_ok, minuet_vt = pcall(require, "minuet.virtualtext")
                  if minuet_ok and minuet_vt.action.is_visible() then
                    minuet_vt.action.accept()
                    return true
                  end
                end,
                "snippet_forward",
                "fallback",
              }
            end,
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
        vim.opt.guifont = "IosevkaTerm Nerd Font Mono:h12"

        -- Swaystation options & stylistics
        vim.opt.winborder = "bold"
        vim.opt.fillchars = { eob = " ", msgsep = "-" }
        vim.opt.cmdheight = 0
        vim.opt.pumheight = 10
        vim.opt.conceallevel = 0
        vim.opt.showtabline = 0
        vim.opt.relativenumber = true
        vim.opt.cursorline = true
        vim.opt.signcolumn = "yes"
        vim.opt.showmode = false
        vim.opt.laststatus = 3

        -- Swaystation LSP diagnostic stylistics
        vim.diagnostic.config({
          virtual_text = false,
          underline = true,
          update_in_insert = false,
          severity_sort = true,
          float = {
            border = "bold",
            source = true,
          },
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = "󰅚",
              [vim.diagnostic.severity.WARN] = "󰀪",
              [vim.diagnostic.severity.INFO] = "󰋽",
              [vim.diagnostic.severity.HINT] = "󰌶",
            },
            numhl = {
              [vim.diagnostic.severity.ERROR] = "ErrorMsg",
              [vim.diagnostic.severity.WARN] = "WarningMsg",
            },
          },
        })

        -- Disable commenting next line on newline
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "*",
          callback = function()
            vim.opt_local.formatoptions:remove({ "r", "o" })
          end,
        })

        -- Linebreak for markdown
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "markdown" },
          callback = function()
            vim.opt.linebreak = true
          end,
        })

        -- Hide cursor in SnacksDashboardOpened
        vim.api.nvim_create_autocmd("User", {
          pattern = "SnacksDashboardOpened",
          callback = function()
            vim.cmd([[hi Cursor blend=100]])
            vim.cmd("set guicursor+=a:Cursor/lCursor")
          end,
        })

        -- Unhide cursor in SnacksDashboardClosed
        vim.api.nvim_create_autocmd("User", {
          pattern = "SnacksDashboardClosed",
          callback = function()
            vim.cmd([[hi Cursor blend=0]])
            vim.cmd("set guicursor+=a:Cursor/lCursor")
          end,
        })

        -- Theme visibility overrides & Swaystation highlights
        vim.api.nvim_create_autocmd("ColorScheme", {
          pattern = "*",
          callback = function()
             local hl = vim.api.nvim_set_hl

             -- Visibility overrides for ghost text and inlay hints
             local visibility_groups = {
               "CmpGhostText",
               "BlinkCmpGhostText",
               "CopilotSuggestion",
               "LspInlayHint",
               "MinuetVirtualText",
             }
             for _, group in ipairs(visibility_groups) do
               hl(0, group, { fg = "#bbbbbb", italic = true })
             end

             -- Make split borders more visible with transparent bg (Swaystation style)
             local border_groups = {
               "WinSeparator",
               "VertSplit",
             }
             for _, group in ipairs(border_groups) do
               hl(0, group, { fg = "#bb9af7", bg = "NONE", bold = true })
             end

             -- Swaystation floating borders and popups
             hl(0, "FloatBorder", { link = "Normal" })
             hl(0, "LspInfoBorder", { link = "Normal" })
             hl(0, "NormalFloat", { link = "Normal" })
             hl(0, "Pmenu", { link = "Normal" })
             hl(0, "PmenuSel", { link = "Search" })

             -- Blink CMP menu styling
             hl(0, "BlinkCmpMenu", { link = "Normal" })
             hl(0, "BlinkCmpMenuBorder", { link = "Normal" })
             hl(0, "BlinkCmpMenuSelection", { link = "Search" })
             hl(0, "BlinkCmpLabelMatch", { link = "Search" })

             -- Snacks dashboard highlights
             hl(0, "SnacksDashboardHeader", { fg = "#d8a657" })
             hl(0, "SnacksDashboardDesc", { fg = "#83a598" })
             hl(0, "SnacksDashboardFooter", { fg = "#d8a657" })

             -- Snacks indentline palette
             hl(0, "SnacksIndent1", { fg = "#ea6962" })
             hl(0, "SnacksIndent2", { fg = "#d8a657" })
             hl(0, "SnacksIndent3", { fg = "#458588" })
             hl(0, "SnacksIndent4", { fg = "#8ec07c" })
             hl(0, "SnacksIndent5", { fg = "#d3869b" })
             hl(0, "SnacksIndent6", { fg = "#e78a4e" })
             hl(0, "SnacksIndent7", { fg = "#83a598" })

             -- Snacks picker directory
             hl(0, "SnacksPickerDir", { fg = "#928374" })

             -- Match EndOfBuffer and tree backgrounds with the active Normal background
             local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
             if normal and normal.bg then
               local bg = string.format("#%06x", normal.bg)
               hl(0, "EndOfBuffer", { fg = bg, bg = bg })
               hl(0, "NeoTreeNormal", { fg = normal.fg and string.format("#%06x", normal.fg) or nil, bg = bg })
               hl(0, "NeoTreeNormalNC", { fg = normal.fg and string.format("#%06x", normal.fg) or nil, bg = bg })
               hl(0, "NeoTreeEndOfBuffer", { fg = bg, bg = bg })
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

        -- Minuet AI inline suggestion keymaps
        vim.keymap.set("i", "<A-a>", function()
          local ok, vt = pcall(require, "minuet.virtualtext")
          if ok and vt.action.is_visible() then
            vt.action.accept()
          end
        end, { desc = "Minuet accept inline suggestion" })
     '';
    };
  };
}
