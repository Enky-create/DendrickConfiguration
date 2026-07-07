{ self, inputs, ... }: {
  flake.nixosModules.homeManager = { config, pkgs, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;      # не тянуть второй раз nixpkgs, юзать системный
      useUserPackages = true;    # пакеты из home.packages идут в /etc/profiles, а не в ~/.nix-profile
      backupFileExtension = "hm-backup"; # чтобы не падало при коллизиях с существующими dotfiles

      users.vadim = { pkgs, ... }: {
        imports = [
          self.homeManagerModules.lf
          # сюда же потом можно добавить self.homeManagerModules.kitty и т.д.
        ];

        home.stateVersion = "25.05"; # обязательное поле, ставить как system.stateVersion
      };
    };
  };
}
