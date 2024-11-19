{ config, pkgs, ... }:

{
  home = {
    username = "anarcho";
    homeDirectory = "/home/anarcho";
    
    packages = with pkgs; [
      # Browsers
      firefox
      
      # Additional tools
      pavucontrol
      brightnessctl
    ];

    stateVersion = "24.05";
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "anarcho";
      userEmail = "your.email@example.com";
    };

    bash = {
      enable = true;
      shellAliases = {
        ll = "ls -la";
        update = "sudo nixos-rebuild switch --flake .#nixvm";
      };
    };

    kitty = {
      enable = true;
      settings = {
        font_size = 11;
        font_family = "monospace";
        enable_audio_bell = false;
      };
    };
  };

    wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;  # Disable systemd integration temporarily
    
    settings = {
      "$mod" = "SUPER";
      
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
        allow_tearing = false;
      };

      monitor = [
        "Virtual-1,1920x1080@60,0x0,1,bitdepth,8"  # Added bitdepth
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = false;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = false;  # Disable blur effects
          size = 3;
          passes = 1;
        };
        drop_shadow = false;  # Disable shadows
      };

      animations = {
        enabled = false;  # Disable animations for now
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        vfr = false;
      };

      # Basic keybindings
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, Space, togglefloating"
        "$mod, D, exec, wofi --show drun"
      ];
    };
  };
}