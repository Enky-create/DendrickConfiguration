{ self, inputs, pkgs, ... }: {
  flake.nixosModules.postgres = { pkgs, lib, ... }: {
    services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    dataDir = "/data/postgresql";
  }
  };
  
}
