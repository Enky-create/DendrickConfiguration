{ self, inputs, ... }: {
  flake.nixosModules.amnezia = { config, pkgs, inputs, ... }:
{
    networking.wireguard.enable = true;
    programs = {
    amnezia-vpn = {
        package = pkgs.amnezia-vpn;
        enable = true;
        };
    };
    systemd.services.amnezia-service = {
    description = "Amnezia VPN Service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
        ExecStart = "${pkgs.amnezia-vpn}/bin/AmneziaVPN-service";
        Restart = "always";
        RestartSec = 3;
    };
};

};
}