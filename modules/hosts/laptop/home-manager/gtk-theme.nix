 { self, inputs, ... }: {
  flake.homeManagerModules.gtk-theme = { config, pkgs, inputs, ... }:
{
    home.file.".icons/default/index.theme".text = ''
    [Icon Theme]
    Inherits=Bibata-Modern-Classic
    '';
gtk = {
  enable = true;

  theme = {
    name = "adw-gtk3";
    package = pkgs.adw-gtk3;
  };

  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };

  cursorTheme = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };
}; 
};
}
