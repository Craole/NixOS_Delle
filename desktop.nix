{ pkgs, ... }:

{
  # ── Wayland ─────────────────────────────────────────────────────────────────

  programs.niri = {
    enable = true;
  };

  # XWayland for apps that still need it
  programs.xwayland.enable = true;

  # ── Display Manager — greetd + regreet ──────────────────────────────────────

  services.greetd = {
    enable = true;
    settings = {
      # Falls back to regreet on logout/lock
      default_session = {
        command = "${pkgs.greetd.regreet}/bin/regreet";
        user    = "greeter";
      };
      # Auto-login craole into niri on first boot
      initial_session = {
        command = "niri-session";
        user    = "craole";
      };
    };
  };

  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = "/etc/greetd/background.jpg"; # drop an image here post-install
        fit  = "Cover";
      };
      GTK.application_prefer_dark_theme = true;
    };
  };

  # ── Desktop packages ────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
    # Niri ecosystem
    waybar           # status bar
    fuzzel           # launcher
    mako             # notifications
    swaylock         # lock screen
    swayidle         # idle management
    wl-clipboard     # clipboard
    grim             # screenshots
    slurp            # region select for screenshots
    xdg-utils        # xdg-open etc.
    xdg-user-dirs

    # File management
    nautilus
    gnome-disk-utility

    # Theming
    adwaita-icon-theme
    gnome-themes-extra

    # Apps
    firefox
    kitty            # terminal
    pavucontrol      # audio control
  ];

  # XDG portal — needed for screen sharing, file pickers etc.
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-wlr
    ];
  };

  # ── Session variables ────────────────────────────────────────────────────────

  environment.sessionVariables = {
    NIXOS_OZONE_WL    = "1"; # Electron/VSCode Wayland
    WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
