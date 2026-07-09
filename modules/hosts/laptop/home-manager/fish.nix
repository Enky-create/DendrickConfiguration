{ self, inputs, ... }: {
flake.homeManagerModules.fish = { config, pkgs, inputs, ... }:
{
 home.packages = with pkgs; [
    bat
    eza      # современный ls
    fzf      # fuzzy finder
    zoxide   # умный cd
    fd       # быстрый find
    ripgrep  # быстрый grep
  ];

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      # zoxide (умный cd, учит частые директории)
      zoxide init fish | source

      # fzf keybindings (Ctrl+R — история, Ctrl+T — файлы)
      fzf --fish | source
    '';

    plugins = [
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
    ];

    shellAliases = {
      # --- замены стандартных команд ---
      ls = "eza --icons --group-directories-first";
      ll = "eza -la --icons --group-directories-first";
      lt = "eza --tree --icons --level=2";
      cat = "bat";
      cd  = "z"; # zoxide

      # --- git ---
      g   = "git";
      gs  = "git status";
      ga  = "git add";
      gaa = "git add --all";
      gc  = "git commit -m";
      gca = "git commit --amend";
      gp  = "git push";
      gpl = "git pull";
      gco = "git checkout";
      gcb = "git checkout -b";
      gb  = "git branch";
      gd  = "git diff";
      gds = "git diff --staged";
      gl  = "git log --oneline --graph --decorate --all";
      glog = "git log --oneline --graph --decorate -20";
      gst = "git stash";
      gstp = "git stash pop";
      grh = "git reset --hard";
      grs = "git reset --soft HEAD~1";
    };

    functions = {
      # --- быстрые команды для NixOS (хост laptop) ---
      rebuild = ''
        echo "🔧 Rebuilding NixOS (laptop)..."
        sudo nixos-rebuild switch --flake ~/DendricConfiguration#laptop
      '';

      rebuild-boot = ''
        echo "🔧 Rebuilding NixOS boot generation (laptop)..."
        sudo nixos-rebuild boot --flake ~/DendricConfiguration#laptop
      '';

      rebuild-test = ''
        echo "🧪 Testing NixOS config (laptop, no bootloader entry)..."
        sudo nixos-rebuild test --flake ~/DendricConfiguration#laptop
      '';

      flake-update = ''
        echo "⬆️  Updating flake inputs..."
        pushd ~/DendricConfiguration
        nix flake update
        popd
      '';

      nix-clean = ''
        echo "🧹 Cleaning old generations..."
        sudo nix-collect-garbage -d
        sudo nixos-rebuild boot --flake ~/DendricConfiguration#laptop
      '';

      # быстрый git commit + push одной командой
      gcp = ''
        git add --all
        git commit -m "$argv"
        git push
      '';
    };
  };
};
}
