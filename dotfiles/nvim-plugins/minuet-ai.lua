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
