{ lib, flake-parts-lib, ... }: {
  options.flake = flake-parts-lib.mkSubmoduleOptions {
    homeManagerModules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.unspecified;
      default = { };
      description = "Home-manager модули, аналог flake.nixosModules";
    };
  };
}
