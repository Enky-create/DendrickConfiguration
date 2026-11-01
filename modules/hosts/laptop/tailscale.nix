{ self, inputs, ... }: {
  flake.nixosModules.tailscale = { pkgs, lib, ... }: {
      services.tailscale = {
      enable = true;
      package = inputs.nixpkgs-tailscale.legacyPackages.${pkgs.stdenv.hostPlatform.system}.tailscale;
    };
  };
  
}
