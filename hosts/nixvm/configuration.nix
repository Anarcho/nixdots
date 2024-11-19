{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nvidia-module.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Enable flakes and nix-command
  nix = {
    settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "anarcho" ];
  };
    

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Boot configuration
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ 
      "hv_balloon" 
      "hv_vmbus" 
      "hv_storvsc" 
      "virtio_gpu"
      "virgl"
    ];
    kernelParams = [
      "video=hyperv_fb:1920x1080"
      "systemd.mask=systemd-vconsole-setup.service"
      "systemd.mask=dev-tpmrm0.device"
      "nowatchdog"
    ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    tmp.useTmpfs = false;
  };

  # Hardware configuration
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        mesa.drivers
        vaapiVdpau
        libvdpau
      ];
    };
  };

  # Network configuration
  networking = {
    hostName = "nixvm";
    networkmanager.enable = true;
    useNetworkd = lib.mkForce false;
    useDHCP = lib.mkForce false;
  };

  # Time and locale
  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_AU.UTF-8";

  # Systemd configuration
  systemd = {
    user = {
      services = {
        "gdm-*" = {
          enable = lib.mkDefault false;
          restartIfChanged = false;
        };
      };
    };
    
    services = {
      "getty@tty1" = {
        enable = false;
        restartIfChanged = false;
      };
      
      "autovt@tty1" = {
        enable = false;
        restartIfChanged = false;
      };
      
      "systemd-networkd-wait-online" = {
        enable = false;
        restartIfChanged = false;
      };
      
      "NetworkManager-wait-online" = {
        enable = false;
        restartIfChanged = false;
      };
    };

    tmpfiles.rules = [
      "d /run/gdm 0711 root root"
      "d /var/lib/gdm 0711 root root"
      "z /var/lib/gdm 0711 root root"
    ];
  };

  # XDG Portal configuration
  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  # Services configuration
  services = {
    openssh.enable = true;
    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
          autoSuspend = false;
        };
        defaultSession = "hyprland";
        autoLogin.enable = false;
        job = {
          logToJournal = true;
          preStart = ''
            mkdir -p /run/gdm
            mkdir -p /var/lib/gdm
            rm -f /run/nologin
          '';
        };
      };
    };
  };  # Added missing closing brace for services

  # User configuration
  users.users.anarcho = {
    isNormalUser = true;
    initialPassword = "pass";
    extraGroups = [ 
      "wheel"
      "video"
      "networkmanager"
      "input"
    ];
  };



  # Environment configuration
  environment = {    # Changed to a proper attribute set
    sessionVariables = {
      LIBGL_ALWAYS_SOFTWARE = "1";
      WLR_RENDERER = "pixman";
      WLR_NO_HARDWARE_CURSORS = "1";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      WLR_BACKENDS = "headless,libinput";
      QT_QPA_PLATFORM = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";
    };

    systemPackages = with pkgs; [
      # Graphics
      mesa
      mesa.drivers
      glxinfo
      
      # Wayland
      wayland
      wayland-utils
      wl-clipboard
      
      # Basic utilities
      git
      curl
      wget
      neovim
      
      # Terminal
      kitty
      
      # Additional tools
      wofi
      waybar
    ];
  };

  # Hyprland configuration - fixed the partial line
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Security configuration
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  system.stateVersion = "24.05";
} 
