{ pkgs, ... }:

{
  # ── NetworkManager ──────────────────────────────────────────────────────────

  networking = {
    networkmanager.enable = true;

    # Firewall — allow SSH and Tailscale; lock everything else
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      trustedInterfaces = [ "tailscale0" ];
      # Starlink Mini comes in as a regular ethernet/wifi interface
      # No special config needed — NM handles it
    };
  };

  # ── Tailscale ───────────────────────────────────────────────────────────────
  # Run `sudo tailscale up` post-install to authenticate
  # With two ISPs you can use exit nodes to route through either

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both"; # allows using Delle as exit node if needed
    openFirewall = true;
  };

  # ── mDNS / local discovery ──────────────────────────────────────────────────

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # ── Packages ─────────────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
    networkmanagerapplet  # nm-applet for tray
    dig
    nmap
    traceroute
  ];
}
