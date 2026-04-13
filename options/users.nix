{
  config,
  lib,
  dom,
  ...
}: let
  mod = "users";
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str submodule;
in {
  options.${dom}.${mod} = mkOption {
    description = "Primary user configuration.";
    type = submodule {
      options = {
        enable = mkEnableOption "Enable this user configuration.";
        name = mkOption {
          type = str;
          description = "Primary interactive user for the host.";
        };

        fullName = mkOption {
          type = str;
          default = config.${dom}.${mod}.user.name;
          description = "Display name for the primary user.";
        };

        email = mkOption {
          type = str;
          default = "";
          description = "Email address used by user-facing tooling.";
        };

        homeDirectory = mkOption {
          type = str;
          default = "/home/${config.${dom}.${mod}.user.name}";
          description = "Home directory for the primary user.";
        };
      };
    };
    default = {};
  };
}
