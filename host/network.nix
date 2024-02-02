{ config, lib, pkgs, ... }:
{
  networking = {
    hostName = "frame";
    firewall.enable = false;
    useNetworkd = true;
    useDHCP = false;
    wireless.iwd.enable = true;
    nftables = {
      enable = true;
    };
  };
  systemd.network.networks = {
    "10-wlan0" = {
      name = "wlan0";
      DHCP = "yes";
      dhcpV4Config.RouteMetric = 2048;
      dhcpV6Config.RouteMetric = 2048;
    };
    "10-ether" = {
      name = "en*";
      DHCP = "yes";
    };
  };
  # Avoid slow boot time
  # systemd.services.NetworkManager-wait-online.enable = false;
  # If the user doesn't have any other interface managed by networkd, then there will be no interface managed (lo is ignored by default)
  # This makes networkd-wait-online impossible to succeed.
  # Thus let's disable on default
  systemd.services.systemd-networkd-wait-online = {
    enable = lib.mkDefault false;
    restartIfChanged = false;
  };

}
