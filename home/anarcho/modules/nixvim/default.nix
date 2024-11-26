{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./options.nix
    ./colorschemes.nix
  ];

  programs.nixvim = {
    enable = true;

    globals.mapleader = " ";

  };
}
