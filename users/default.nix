{
  config,
  inputs,
  pkgs,
  dom,
  ...
}: let
  cfg = config.${dom};
in {
  users.users.${cfg.user.name} = {
    isNormalUser = true;
    description = cfg.user.fullName;
    home = cfg.user.homeDirectory;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "podman"
      "video"
      "audio"
      "bluetooth"
      "input"
    ];
    openssh.authorizedKeys.keys = [
      # "ssh-ed25519 AAAA... ${cfg.user.name}@${cfg.hostName}"
    ];
  };

  users.users.cc = {
    isSystemUser = true;
    description = "System service account";
    group = "cc";
    extraGroups = ["docker"];
    home = "/var/lib/cc";
    createHome = true;
  };

  users.groups.cc = {};

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  home-manager = {
    backupFileExtension = "backup";
    overwriteBackup = true;
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      my = cfg;
    };

    users.${cfg.user.name} = {
      home = {
        username = cfg.user.name;
        homeDirectory = cfg.user.homeDirectory;
        stateVersion = config.system.stateVersion;
      };
      imports = [./craole];
    };
  };
}
