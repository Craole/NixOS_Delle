{ pkgs, ... }:

{
  # ── SSH ─────────────────────────────────────────────────────────────────────

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;  # keys only
      PermitRootLogin        = "no";
      X11Forwarding          = false;
    };
  };

  # ── Docker ──────────────────────────────────────────────────────────────────

  virtualisation.docker = {
    enable           = true;
    enableOnBoot     = true;
    autoPrune.enable = true;
  };

  # ── Podman ──────────────────────────────────────────────────────────────────

  virtualisation.podman = {
    enable            = true;
    dockerCompat      = false; # Docker is already installed
    defaultNetwork.settings.dns_enabled = true;
  };

  # ── OpenClaw ────────────────────────────────────────────────────────────────
  # Scout-DJ/openclaw-nix module — security-hardened NixOS service
  # Run `openclaw onboard` as craole after first login to configure
  # Channels (Telegram, Discord, etc.) and API keys set up via onboard wizard

  services.openclaw = {
    enable  = true;
    domain  = "delle.local";
    # Secrets managed via environment file — create after install:
    # /etc/openclaw/secrets (mode 600, owned by openclaw service user)
    # Contents:
    #   ANTHROPIC_API_KEY=sk-ant-...
    #   TELEGRAM_BOT_TOKEN=...  (optional)
  };

  # ── Packages ─────────────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
    docker-compose
    podman-compose
    lazydocker   # TUI for docker management
  ];
}
