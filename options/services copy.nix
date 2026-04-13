{
  lib,
  dom,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  mod = "containers";
in {
  options.${dom}.${mod} = {
    tailscale = {
      enable =
        mkEnableOption "Enable Tailscale networking."
        // {
          default = true;
        };
    };

    openclaw = {
      enable = mkEnableOption "the OpenClaw service";
    };
  };
}
