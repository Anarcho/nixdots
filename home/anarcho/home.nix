{ config, lib, pkgs, ... }:
{
  home.username = lib.mkDefault "anarcho";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}anarcho";

  home.stateVersion = "24.05";


  home.packages = [ ];
  home.file = { };

  home.sessionVariables = { };

  programs.home-manager.enable = true;
}

