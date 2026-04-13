{...}:
# BTRFS with subvolumes — clean rollbacks, snapshots, no swap partition (zram handles it)
# Verify disk device with `lsblk` before running disko — update if not /dev/sda
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda"; #? ← confirm with lsblk on the live ISO

    content = {
      type = "gpt";
      partitions = {
        #~@ EFI system partition
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
          };
        };

        #~@ BTRFS root — all subvolumes live here
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = ["-f" "-L" "delle-root"];

            subvolumes = {
              "@" = {
                mountpoint = "/";
                mountOptions = ["compress=zstd" "noatime" "space_cache=v2"];
              };
              "@home" = {
                mountpoint = "/home";
                mountOptions = ["compress=zstd" "noatime" "space_cache=v2"];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = ["compress=zstd" "noatime" "space_cache=v2"];
              };
              "@log" = {
                mountpoint = "/var/log";
                mountOptions = ["compress=zstd" "noatime" "space_cache=v2"];
              };
              "@snapshots" = {
                mountpoint = "/.snapshots";
                mountOptions = ["compress=zstd" "noatime" "space_cache=v2"];
              };
            };
          };
        };
      };
    };
  };

  #~@ zram swap — no partition needed, uses ~50% of RAM (≈7.8GB compressed)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
