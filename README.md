# Delle — NixOS Configuration

Dell Precision M2800 | i7-4810MQ | 15.6GB RAM | 256GB SSD

## Structure

```text
/etc/nixos/
├── flake.nix
├── hosts/
│   └── delle/
│       ├── default.nix          # machine-specific settings and profile toggles
│       ├── disko.nix            # declarative partition layout
│       └── hardware.nix         # boot/platform defaults; replace with generated hardware config when installing
├── modules/
│   ├── default.nix              # shared module entrypoint
│   ├── options.nix              # custom my.* options
│   ├── core.nix                 # nix settings, locale, fonts, base packages
│   ├── desktop.nix              # niri, greetd/regreet, desktop packages
│   ├── dev.nix                  # development tooling
│   ├── hardware.nix             # shared hardware defaults
│   ├── networking.nix           # networkmanager, tailscale, firewall
│   └── services.nix             # ssh, containers, openclaw
└── users/
    ├── default.nix              # system users + Home Manager wiring
    └── craole/default.nix       # per-user Home Manager config
```

## Host Options

`hosts/delle/default.nix` is the single place to declare:

- `my.hostName`, `my.system`, `my.stateVersion`
- `my.user.*`
- `my.profiles.desktop`, `my.profiles.dev`
- `my.services.tailscale`, `my.services.openclaw`
- `my.containers.enable`

Shared modules read those options and enable only the relevant parts.

## Install Steps

1. Boot the minimal ISO on Delle.
2. Copy this config to `/etc/nixos/`.
3. Run `lsblk` to confirm the target disk is `/dev/sda`, then update `hosts/delle/disko.nix` if needed.
4. Run `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /etc/nixos/hosts/delle/disko.nix`.
5. Run `sudo nixos-generate-config --root /mnt` and merge the generated hardware config into `hosts/delle/hardware.nix`.
6. Run `sudo nixos-install --flake /etc/nixos#delle`.
7. Set the password for `craole` when prompted.
8. Reboot.

## Post-Install

- Run `sudo tailscale up` to authenticate Tailscale.
- Run `openclaw onboard` to set up the OpenClaw gateway.
- Run `claude` to authenticate Claude Code.
