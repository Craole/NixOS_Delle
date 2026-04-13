{
  lib,
  dom,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  mod = "profiles";
in {
  options.${dom}.${mod} = {
    desktop = {
      enable = mkEnableOption "desktop packages and graphical session";
    };
    dev = {
      enable = mkEnableOption "development tooling";
    };
    containers = {
      enable = mkEnableOption "container tooling";
    };
  };
}
