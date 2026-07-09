
 { self, inputs, ... }: {
  flake.homeManagerModules.starship = { config, pkgs, inputs, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = "$username$hostname$directory$git_branch$git_status$nix_shell$character";

    username = {
      show_always = true;   # показывать даже локально, не только по SSH/root
      style_user = "bold blue";
      style_root = "bold red";
      format = "[$user]($style) ";
    };

    hostname = {
      ssh_only = true;      # хост показываем только при SSH-сессии, локально не нужно
      format = "on [$hostname](bold green) ";
    };
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      directory = {
        truncation_length = 3;
        style = "bold cyan";
      };

      git_branch = {
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        style = "bold yellow";
      };

      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$state( \($name\))]($style) ";
      };
    };
  };
};
}
