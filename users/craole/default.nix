{
  my,
  pkgs,
  ...
}: let
  flakeRef = "${my.flakePath}#${my.hostName}";
  shellAliases = {
    ll = "eza -la --git";
    lt = "eza --tree --level=2";
    cat = "bat";
    top = "btop";
    lg = "lazygit";
    ld = "lazydocker";
    # NixOS shortcuts
    nr = "sudo nixos-rebuild switch --flake ${flakeRef}";
    nrb = "sudo nixos-rebuild boot --flake ${flakeRef}";
    nu = "nix flake update ${my.flakePath} && sudo nixos-rebuild switch --flake ${flakeRef}";
    gc = "sudo nix-collect-garbage -d";
  };
in {
  home.packages = with pkgs; [ cowsay ];

  # ── Git ──────────────────────────────────────────────────────────────────────

  programs = {
    home-manager.enable = true;
    delta = {
      enable = true;
      enableGitIntegration = true;
    };
    git = {
      enable = true;
      settings = {
        user = {
          name = my.user.fullName;
          email = my.user.email;
        };
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
    };

    # ── Zsh ──────────────────────────────────────────────────────────────────────

    zsh = {
      inherit shellAliases;
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history = {
        size = 10000;
        share = true;
      };
      initContent = ''eval "$(direnv hook zsh)"'';
    };

    # ── Starship prompt ───────────────────────────────────────────────────────────

    starship = {
      enable = true;
      settings = {
        format = "$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };
        nix_shell = {
          format = "[$symbol$state]($style) ";
          symbol = "❄️ ";
        };
      };
    };

    # ── Kitty terminal ────────────────────────────────────────────────────────────

    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 13;
      };
      settings = {
        background_opacity = "0.95";
        confirm_os_window_close = 0;
        enable_audio_bell = false;
      };
    };

    # ── direnv ────────────────────────────────────────────────────────────────────

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
