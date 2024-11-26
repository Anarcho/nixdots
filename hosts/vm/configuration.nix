{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  networking.hostName = "vm";

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
    packages = with pkgs; [ ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    home-manager
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  programs.sway = {
    enable = true;
    xwayland.enable = true;
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [
        "root"
        "anarcho"
        "aaronk"
      ];
    };
  };

  system.stateVersion = "24.05";
}
