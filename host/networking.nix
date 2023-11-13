{ config, pkgs, ... }:
{
  #  networking.bridges = {
  #   br0 = {
  #     interfaces = [ "wlp1s0" "wlan-station0" ];
  #   };
  # };
  #   networking.useDHCP = false;
  #   networking.interfaces.wlp1s0.useDHCP = true;
  #   networking.interfaces.br0.useDHCP = true;
  #   networking.wlanInterfaces = {
  #       wlan-station0 = {
  #         device = "wlp6s0";
  #         fourAddr = true;
  #       };
  #   };
  networking.dhcpcd.denyInterfaces = [ "macvtap0@*" ];
}
