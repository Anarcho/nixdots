{ config, lib, pkgs, ... }:
{
  home.username = lib.mkDefault "anarcho";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.stateVersion = "24.05"; # Please read the comment before changing.
  home.packages = with pkgs; [
  ];
  home.file = {
  };
  home.sessionVariables = { };
  programs.home-manager.enable = true;
}
