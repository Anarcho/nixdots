{ inputs, lib, config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "Australia/Brisbane";

  users.users.anarcho = {
    isNormalUser = true;
    initialPassword = "pass";
    extraGroups = [
      "wheel"
    ];
    packages = with pkgs; [
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  system.stateVersion = "24.05";
}
