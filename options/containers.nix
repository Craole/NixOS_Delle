{
  lib,
  dom,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  mod = "containers";
in {
  options.${dom}.${mod} = {
    local = {
      enable = mkEnableOption "local container tooling";
    };
  };
}
