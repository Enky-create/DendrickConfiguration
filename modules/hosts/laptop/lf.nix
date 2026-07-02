{ self, inputs, ... }: {
  flake.nixosModules.lf = { config, pkgs, inputs, ... }:
{
  programs.lf = {
    enable = true;
  };
};
}