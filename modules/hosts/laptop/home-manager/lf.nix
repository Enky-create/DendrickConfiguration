{ self, inputs, ... }: {
  flake.homeManagerModules.lf = { pkgs, ... }:
  let
    lfPreview = pkgs.writeShellScript "lf-preview" ''
      #!/usr/bin/env bash
      file="$1"
      w="$2"
      h="$3"

      case "$(${pkgs.file}/bin/file -Lb --mime-type "$file")" in
        text/*|application/json|application/x-empty)
          ${pkgs.bat}/bin/bat --color=always --style=plain --paging=never --wrap character --terminal-width "$w" "$file"
          ;;
        image/*)
          ${pkgs.chafa}/bin/chafa --size="$w"x"$h" "$file"
          ;;
        application/pdf)
          ${pkgs.poppler_utils}/bin/pdftotext "$file" -
          ;;
        *)
          echo "--- no preview ---"
          ;;
      esac
    '';
  in {
    home.packages = with pkgs; [
      bat
      chafa
      poppler-utils
      unzip
      p7zip
      ffmpegthumbnailer
    ];

    programs.lf = {
      enable = true;

      settings = {
        preview = true;
        hidden = true;
        icons = true;
        drawbox = true;
        ignorecase = true;
        number = true;
        relativenumber = true;
        scrolloff = 10;
        wrapscan = true;
      };

      previewer = {
        source = lfPreview;
      };

      keybindings = {
        "gh" = "cd ~";
        "<c-r>" = "reload";
        "<delete>" = "delete";
        "d" = "";
        "dd" = "cut";
        "dp" = "paste";
      };

      commands = {
        extract = ''%{{
          case "$f" in
            *.zip) unzip "$f" ;;
            *.tar.gz|*.tgz) tar xzf "$f" ;;
            *.tar.bz2) tar xjf "$f" ;;
            *.tar) tar xf "$f" ;;
            *.7z) 7z x "$f" ;;
          esac
        }}'';
      };
    };
  };
}
