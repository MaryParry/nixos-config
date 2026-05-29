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
      ui.noice.enable = true; # Better UI for messages, cmdline, and popupmenu
      editor.neo-tree.enable = true; # File explorer
      coding.mini-surround.enable = true; # Surround actions

      # Themes (LazyVim extras)
      colorscheme.tokyonight.enable = true;
    };

    extraPackages = with pkgs; [
      nixd # Nix LSP
      alejandra # Nix formatter
      pyright # Python LSP
      ruff # Python linter/formatter
      nodePackages.typescript-language-server
      vtsls # Enhanced TypeScript LSP
      prettierd # Fast formatter for various languages
    ];

    # Declarative configuration "the nix way"
    config = {
      options = ''
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
        vim.g.autoformat = true
      '';
    };

    # If you want to use a specific theme that matches your "Noctalia" setup, 
    # you can define it here. For example, if you have a lua file for it:
    # plugins.colorscheme = ''
    #   return {
    #     "folke/tokyonight.nvim",
    #     opts = { style = "moon" },
    #   }
    # '';
  };
}
