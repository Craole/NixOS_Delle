{ pkgs, ... }:

{
  users = {

    # ── craole — primary user ────────────────────────────────────────────────

    users.craole = {
      isNormalUser    = true;
      description     = "Craole";
      shell           = pkgs.zsh;
      extraGroups     = [
        "wheel"           # sudo
        "networkmanager"  # manage network connections
        "docker"          # run docker without sudo
        "podman"          # run podman without sudo
        "video"           # screen brightness, video devices
        "audio"           # audio devices
        "bluetooth"       # bluetooth management
        "input"           # input devices
      ];
      # SSH public keys — add your key(s) here
      # Generate with: ssh-keygen -t ed25519 -C "craole@delle"
      openssh.authorizedKeys.keys = [
        # "ssh-ed25519 AAAA... craole@desktop"
      ];
    };

    # ── cc — system/service account ──────────────────────────────────────────
    # Used for running background services and automation
    # Not a login user — no password, no shell

    users.cc = {
      isSystemUser    = true;
      description     = "System service account";
      group           = "cc";
      extraGroups     = [ "docker" ];
      home            = "/var/lib/cc";
      createHome      = true;
    };

    groups.cc = { };
  };

  # ── sudo ────────────────────────────────────────────────────────────────────

  security.sudo = {
    enable          = true;
    wheelNeedsPassword = true; # require password for sudo
  };
}
