{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ── Version Control ────────────────────────────────────────────────────────
    git
    gh            # GitHub CLI
    lazygit       # TUI git client
    delta         # better git diffs

    # ── Editors ────────────────────────────────────────────────────────────────
    neovim
    vscode        # launches with Wayland via NIXOS_OZONE_WL=1

    # ── AI / Claude ────────────────────────────────────────────────────────────
    claude-code   # Claude Code CLI

    # ── Node.js ────────────────────────────────────────────────────────────────
    nodejs_22     # OpenClaw requires Node 22+
    nodePackages.pnpm
    nodePackages.npm

    # ── Python ─────────────────────────────────────────────────────────────────
    python3
    python3Packages.pip

    # ── Rust ───────────────────────────────────────────────────────────────────
    rustup

    # ── Go ─────────────────────────────────────────────────────────────────────
    go

    # ── Shell & Terminal ───────────────────────────────────────────────────────
    zsh
    starship      # prompt
    direnv        # per-directory environments
    nix-direnv    # nix integration for direnv

    # ── Build tools ────────────────────────────────────────────────────────────
    gnumake
    gcc
    pkg-config
    openssl

    # ── Misc dev utils ─────────────────────────────────────────────────────────
    httpie        # curl alternative
    jq
    yq
    sqlite
  ];

  # direnv hooks into shell
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Default shell for craole (set in users.nix) — zsh available system-wide
  programs.zsh.enable = true;
}
