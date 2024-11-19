{ lib, pkgs, config, ... }:
with lib;
{
  options.drivers.genericGpu = {
    enable = mkEnableOption "Enable basic rendering support for virtual machines";
  };

  config = mkIf config.drivers.genericGpu.enable {
    # Basic OpenGL configuration
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        mesa.drivers
      ];
    };

    # Environment variables for software rendering
    environment = {
      sessionVariables = {
        # Force software rendering
        LIBGL_ALWAYS_SOFTWARE = "1";
        
        # Use llvmpipe for better performance
        GALLIUM_DRIVER = "llvmpipe";
        
        # Basic wayland variables
        XDG_SESSION_TYPE = "wayland";
        WLR_NO_HARDWARE_CURSORS = "1";
        
        # Use pixman renderer instead of vulkan/gl
        WLR_RENDERER = "pixman";
        WLR_BACKENDS = "headless,libinput";
      };
    };

    # Boot configuration for virtual environment
    boot = {
      initrd.kernelModules = [
        "hyperv_fb"
        "hv_vmbus"
        "hv_storvsc"
      ];

      kernelParams = [
        "video=hyperv_fb:1920x1080"
      ];
    };

    # Services configuration
    services.xserver = {
      videoDrivers = [ "modesetting" ];
    };
  };
}