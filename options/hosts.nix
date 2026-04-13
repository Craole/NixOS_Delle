{
  lib,
  dom,
  ...
}: let
  mod = "hosts";
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str bool attrsOf submodule;
in {
  options.${dom}.${mod} = mkOption {
    description = "NixOS host configurations.";
    type = attrsOf (submodule {
      options = {
        name = mkOption {
          type = str;
          description = "Hostname for this NixOS configuration.";
        };

        system = mkOption {
          type = str;
          default = "x86_64-linux";
          description = "Target system for this host.";
        };

        stateVersion = mkOption {
          type = str;
          default = "25.11";
          description = "NixOS state version for this host.";
        };

        path = mkOption {
          type = str;
          default = "/etc/nixos";
          description = "Filesystem path used by rebuild aliases.";
        };

        profiles = {
          desktop = mkEnableOption "desktop packages and graphical session";
          dev = mkEnableOption "development tooling";
        };

        services = {
          tailscale = mkOption {
            type = bool;
            default = true;
            description = "Enable Tailscale networking.";
          };

          openclaw = mkEnableOption "the OpenClaw service";
        };

        containers.enable = mkOption {
          type = bool;
          default = true;
          description = "Enable local container tooling.";
        };
      };
    });
    default = {};
  };
}
