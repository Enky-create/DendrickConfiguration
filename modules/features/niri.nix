{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };
  perSystem = { pkgs, lib, self', system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;

      config.allowUnfree = true;
    };
    packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs; # THIS PART IS VERY IMPORTAINT, I FORGOT IT IN THE VIDEO!!!
      settings =
        (builtins.fromJSON
          (builtins.readFile ./noctalia.json)).settings;
    };
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs; # THIS PART IS VERY IMPORTAINT, I FORGOT IT IN THE VIDEO!!!
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        input.focus-follows-mouse = {};
        input.keyboard.xkb.layout = "us,ru";
        input.keyboard.xkb.options = "grp:win_space_toggle";
        input.touchpad.tap = {};
        input.touchpad.dwt = {};
        input.touchpad.natural-scroll  = {};
        
        layout = {
          gaps = 5;
          focus-ring = {
            #enable ={};
            width = 3;

            active-color = "#f27c7c";
            inactive-color = "#313244";
          };
        };  
        
        
        workspaces = let
          settings = {layout.gaps = 5;};
        in {
          "w0" = settings;
          "w1" = settings;
          "w2" = settings;
          "w3" = settings;
          "w4" = settings;
          "w5" = settings;
          "w6" = settings;
          "w7" = settings;
          "w8" = settings;
          "w9" = settings;
        };

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+W".spawn-sh = lib.getExe pkgs.firefox;
          "Mod+T".spawn-sh = lib.getExe pkgs.throne;
          "Mod+A".spawn-sh = lib.getExe pkgs.amnezia-vpn;
          "Mod+V".spawn-sh = lib.getExe pkgs.vscode;
          "Mod+Q".close-window ={};
          "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          

          "Mod+F".maximize-column ={};
          "Mod+G".fullscreen-window ={};
          "Mod+Shift+F".toggle-window-floating ={};
          "Mod+C".center-column ={};
          "Mod+D".toggle-overview = {};

          "Mod+H".focus-column-left ={};
          "Mod+L".focus-column-right ={};
          "Mod+K".focus-window-up ={};
          "Mod+J".focus-window-down ={};

          "Mod+Left".focus-column-left ={};
          "Mod+Right".focus-column-right ={};
          "Mod+Up".focus-window-up ={};
          "Mod+Down".focus-window-down ={};

          "Mod+Shift+H".move-column-left ={};
          "Mod+Shift+L".move-column-right ={};
          "Mod+Shift+K".move-window-up ={};
          "Mod+Shift+J".move-window-down ={};

          "Mod+1".focus-workspace = "w0";
          "Mod+2".focus-workspace = "w1";
          "Mod+3".focus-workspace = "w2";
          "Mod+4".focus-workspace = "w3";
          "Mod+5".focus-workspace = "w4";
          "Mod+6".focus-workspace = "w5";
          "Mod+7".focus-workspace = "w6";
          "Mod+8".focus-workspace = "w7";
          "Mod+9".focus-workspace = "w8";
          "Mod+0".focus-workspace = "w9";

          "Mod+Shift+1".move-column-to-workspace = "w0";
          "Mod+Shift+2".move-column-to-workspace = "w1";
          "Mod+Shift+3".move-column-to-workspace = "w2";
          "Mod+Shift+4".move-column-to-workspace = "w3";
          "Mod+Shift+5".move-column-to-workspace = "w4";
          "Mod+Shift+6".move-column-to-workspace = "w5";
          "Mod+Shift+7".move-column-to-workspace = "w6";
          "Mod+Shift+8".move-column-to-workspace = "w7";
          "Mod+Shift+9".move-column-to-workspace = "w8";
          "Mod+Shift+0".move-column-to-workspace = "w9";

          #"Mod+V".spawn-sh = ''${config.pkgs.alsa-utils}/bin/amixer sset Capture toggle'';

          "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

          "Mod+Ctrl+H".set-column-width = "-5%";
          "Mod+Ctrl+L".set-column-width = "+5%";
          "Mod+Ctrl+J".set-window-height = "-5%";
          "Mod+Ctrl+K".set-window-height = "+5%";

          "Mod+WheelScrollDown".focus-column-left ={};
          "Mod+WheelScrollUp".focus-column-right ={};
          "Mod+Ctrl+WheelScrollDown".focus-workspace-down ={};
          "Mod+Ctrl+WheelScrollUp".focus-workspace-up ={};
          "Mod+Comma".consume-window-into-column ={};
          "Mod+Period".expel-window-from-column ={};
          "Mod+Escape".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call lockScreen lock";
        };
      };
    };
  };
}