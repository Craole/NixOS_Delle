{ pkgs, ... }:

{
  home = {
    username   = "craole";
    homeDirectory = "/home/craole";
    stateVersion = "25.11";

    packages = with pkgs; [
      # anything user-specific that doesn't belong system-wide
    ];
  };

  # ── Git ──────────────────────────────────────────────────────────────────────

  programs.git = {
    enable      = true;
    userName    = "Craole";
    userEmail   = ""; # fill in your email
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase        = true;
      push.autoSetupRemote = true;
    };
  };

  # ── Zsh ──────────────────────────────────────────────────────────────────────

  programs.zsh = {
    enable            = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size  = 10000;
      share = true;
    };
    shellAliases = {
      ll  = "eza -la --git";
      lt  = "eza --tree --level=2";
      cat = "bat";
      top = "btop";
      lg  = "lazygit";
      ld  = "lazydocker";
      # NixOS shortcuts
      nr  = "sudo nixos-rebuild switch --flake /etc/nixos#delle";
      nrb = "sudo nixos-rebuild boot --flake /etc/nixos#delle";
      nu  = "nix flake update /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos#delle";
      gc  = "sudo nix-collect-garbage -d";
    };
    initExtra = ''
      eval "$(direnv hook zsh)"
    '';
  };

  # ── Starship prompt ───────────────────────────────────────────────────────────

  programs.starship = {
    enable   = true;
    settings = {
      format = "$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol   = "[❯](bold red)";
      };
      nix_shell = {
        format = "[$symbol$state]($style) ";
        symbol = "❄️ ";
      };
    };
  };

  # ── Kitty terminal ────────────────────────────────────────────────────────────

  programs.kitty = {
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
    theme = "Tokyo Night";
  };

  # ── direnv ────────────────────────────────────────────────────────────────────

  programs.direnv = {
    enable            = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;
}
