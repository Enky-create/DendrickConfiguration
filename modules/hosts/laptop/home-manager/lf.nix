{ self, inputs, ... }: {
  flake.homeManagerModules.lf = { pkgs, ... }:
  let
    lfPreview = pkgs.writeShellScript "lf-preview" ''
      #!/usr/bin/env bash
      file="$1"
      w="$2"
      h="$3"
      x="$4"
      y="$5"

      mimetype=$(${pkgs.file}/bin/file -Lb --mime-type "$file")

      case "$mimetype" in
        image/*)
          ${pkgs.kitty}/bin/kitten icat \
            --stdin=no --transfer-mode=memory \
            --place="''${w}x''${h}@''${x}x''${y}" \
            "$file" < /dev/null > /dev/tty
          ;;
        text/*|application/json|application/x-empty)
          ${pkgs.bat}/bin/bat --color=always --style=plain --paging=never --wrap character --terminal-width "$w" "$file"
          ;;
        application/pdf)
          ${pkgs.poppler-utils}/bin/pdftotext "$file" -
          ;;
        *)
          echo "--- no preview ---"
          ;;
      esac
      exit 1
    '';
  in {
    home.packages = with pkgs; [
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
        "dd" = "cut";
        "dp" = "paste";
	"dc" = "copy";
      };

      commands = {
        open = ''
          ''${{
            case $(${pkgs.file}/bin/file -Lb --mime-type "$f") in
              text/*|application/json) $EDITOR "$f" ;;
              *) setsid -f ''${OPENER:-xdg-open} "$f" > /dev/null 2>&1 ;;
            esac
          }}
        '';

        extract = ''%{{
          case "$f" in
            *.zip) unzip "$f" ;;
            *.tar.gz|*.tgz) tar xzf "$f" ;;
            *.tar.bz2) tar xjf "$f" ;;
            *.tar) tar xf "$f" ;;
            *.7z) 7z x "$f" ;;
          esac
        }}'';

        # Ключевой момент: принудительная перерисовка экрана
        # при каждом переключении файла — убирает графические
        # артефакты kitty без отдельного cleaner-скрипта.
        on-select = "&{{ lf -remote 'send redraw' }}";
      };
    };
  };
}
