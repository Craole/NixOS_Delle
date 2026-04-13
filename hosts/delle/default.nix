{...}: {
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  my = {
    hostName = "delle";
    system = "x86_64-linux";
    stateVersion = "25.11";
    flakePath = "/etc/nixos";

    user = {
      name = "craole";
      fullName = "Craole";
      email = "32288735+Craole@users.noreply.github.com";
    };

    profiles = {
      desktop = true;
      dev = true;
    };

    services = {
      tailscale = true;
      openclaw = true;
    };

    containers.enable = true;
  };
}
