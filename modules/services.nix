{
  config,
  lib,
  pkgs,
  dom,
  ...
}: let
  inherit (lib.lists) optionals;
  inherit (lib.modules) mkIf;

  cfg = config.${dom};
in {
  nixpkgs.config.permittedInsecurePackages =
    optionals cfg.services.openclaw ["openclaw-2026.4.2"];

  # ── SSH ─────────────────────────────────────────────────────────────────────

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false; # keys only
      PermitRootLogin = "no";
      X11Forwarding = false;
    };
  };

  # ── Docker ──────────────────────────────────────────────────────────────────

  virtualisation.docker = mkIf cfg.containers.enable {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  # ── Podman ──────────────────────────────────────────────────────────────────

  virtualisation.podman = mkIf cfg.containers.enable {
    enable = true;
    dockerCompat = false; # Docker is already installed
    defaultNetwork.settings.dns_enabled = true;
  };

  # ── OpenClaw ────────────────────────────────────────────────────────────────
  # Scout-DJ/openclaw-nix module — security-hardened NixOS service
  # Run `openclaw onboard` as craole after first login to configure
  # Channels (Telegram, Discord, etc.) and API keys set up via onboard wizard

  services.openclaw = mkIf cfg.services.openclaw {
    enable = true;
    domain = "${cfg.hostName}.local";
    # Secrets managed via environment file — create after install:
    # /etc/openclaw/secrets (mode 600, owned by openclaw service user)
    # Contents:
    #   ANTHROPIC_API_KEY=sk-ant-...
    #   TELEGRAM_BOT_TOKEN=...  (optional)
  };

  # ── Packages ─────────────────────────────────────────────────────────────────

  environment.systemPackages = optionals cfg.containers.enable (with pkgs; [
    docker-compose
    podman-compose
    lazydocker # TUI for docker management
  ]);
}
