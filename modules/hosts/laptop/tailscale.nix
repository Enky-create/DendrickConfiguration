{ self, inputs, pkgs, ... }: {
  flake.nixosModules.tailscale = { pkgs, lib, ... }: {
      services.tailscale = {
      enable = true;
      package = inputs.nixpkgs-tailscale.legacyPackages.${pkgs.stdenv.hostPlatform.system}.tailscale;
    };

    networking.networkmanager.dns = "systemd-resolved";
    services.resolved.enable = true;

    systemd.services.tailscale-split-dns = {
    description = "Keep split DNS configured for Tailscale";
    after = [ "systemd-resolved.service" "tailscaled.service" ];
    requires = [ "systemd-resolved.service" ];
    bindsTo = [ "tailscaled.service" ];
    wantedBy = [ "tailscaled.service" ];

    serviceConfig = {
      Restart = "always";
      RestartSec = 5;
    };
    path = [ pkgs.systemd pkgs.iproute2 pkgs.gnugrep ];
    script = ''
      while true; do
        if ip link show tailscale0 >/dev/null 2>&1; then
          if ! resolvectl domain tailscale0 | grep -q 'tailf9e61d.ts.net'; then
            resolvectl dns tailscale0 100.100.100.100
            resolvectl domain tailscale0 '~tailf9e61d.ts.net'
          fi
        fi
        sleep 3
      done
    '';
  };
  };
  
}
