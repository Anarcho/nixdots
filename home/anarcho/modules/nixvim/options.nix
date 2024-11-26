{pkgs, ...}:
{
  programs.nixvim = {
    opts = {
      number = true;
      relativenumber = true;
    };
  };
}
