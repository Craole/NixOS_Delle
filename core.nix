{ pkgs, ... }:

{
  # ── Nix / Flakes ────────────────────────────────────────────────────────────

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "craole" ];

      # Binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCUSeBc="
      ];
    };

    # Garbage collect weekly, keep last 5 generations
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # ── Locale & Time ───────────────────────────────────────────────────────────

  time.timeZone = "America/Jamaica";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS        = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT    = "en_US.UTF-8";
      LC_MONETARY       = "en_US.UTF-8";
      LC_NAME           = "en_US.UTF-8";
      LC_NUMERIC        = "en_US.UTF-8";
      LC_PAPER          = "en_US.UTF-8";
      LC_TELEPHONE      = "en_US.UTF-8";
      LC_TIME           = "en_US.UTF-8";
    };
  };

  console = {
    font   = "Lat2-Terminus16";
    keyMap = "us";
  };

  # ── Fonts ───────────────────────────────────────────────────────────────────

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      inter
      ibm-plex
      source-code-pro
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts = {
      monospace  = [ "JetBrainsMono Nerd Font" ];
      sansSerif  = [ "Inter" ];
      serif      = [ "IBM Plex Serif" ];
      emoji      = [ "Noto Color Emoji" ];
    };
  };

  # ── Base packages ───────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
    # Core utils
    coreutils
    curl
    wget
    git
    ripgrep
    fd
    bat
    eza
    fzf
    htop
    btop
    unzip
    zip
    jq
    yq

    # Nix helpers
    nix-output-monitor
    nvd
    nh
  ];
}
