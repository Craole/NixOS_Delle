{ pkgs, ... }:

{
  # ── Intel HD 4600 (Haswell) ─────────────────────────────────────────────────

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver   # VAAPI for Haswell+
      vaapiVdpau
      libvdpau-via-va
    ];
  };

  # ── Audio — PipeWire ────────────────────────────────────────────────────────

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Disable PulseAudio (replaced by PipeWire)
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # ── Bluetooth ───────────────────────────────────────────────────────────────

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Experimental = true; # battery level reporting etc.
    };
  };
  services.blueman.enable = true;

  # ── Power Management ────────────────────────────────────────────────────────

  services.thermald.enable = true; # Intel thermal daemon — important for 4810MQ

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave"; # good default; kick to performance if needed
  };

  services.upower.enable = true;

  # ── SSD ─────────────────────────────────────────────────────────────────────

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}
