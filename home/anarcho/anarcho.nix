{ config, inputs, ... }:
{
  imports = [
    ./home.nix
    ./modules/nixvim
  ];
}
