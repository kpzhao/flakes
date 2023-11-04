{ config, lib, ... }:
let
  nftablesRuleset = ''
    table inet xray {
      chain prerouting {
        type filter hook prerouting priority filter; policy accept;
        meta skgid 23333 return
        ip daddr { 127.0.0.0/8, 224.0.0.0/4, 255.255.255.255 } return
        meta l4proto tcp ip daddr 192.168.0.0/16 return
        ip daddr 192.168.0.0/16 udp dport != 53 return
        ip6 daddr { ::1, fe80::/10 } return
        meta l4proto tcp ip6 daddr fd00::/8 return
        ip6 daddr fd00::/8 udp dport != 53 return
        meta l4proto { tcp, udp } meta mark set 1 tproxy to :1 accept
      }

      chain output {
        type route hook output priority filter; policy accept;
        meta skgid 23333 return
        ip daddr { 127.0.0.0/8, 224.0.0.0/4, 255.255.255.255 } return
        meta l4proto tcp ip daddr 192.168.0.0/16 return
        ip daddr 192.168.0.0/16 udp dport != 53 return
        ip6 daddr { ::1, fe80::/10 } return
        meta l4proto tcp ip6 daddr fd00::/8 return
        ip6 daddr fd00::/8 udp dport != 53 return
        meta l4proto { tcp, udp } meta mark set 1 accept
      }

      chain divert {
        type filter hook prerouting priority mangle; policy accept;
        meta l4proto tcp socket transparent 1 meta mark set 1 accept
      }
    }
  '';
in
 {
  networking = {
      # Packets in the output chain cannot use tproxy directly, we need to
    # set their fwmark to 1 and add a rule that sends packets with fwmark=1
    # to lo. They are then matched by the prerouting chain.
    # Currently there's no way to configure ip rules more declaratively
    localCommands = ''
      ip rule add fwmark 1 table 100
      ip route add local 0.0.0.0/0 dev lo table 100

      ip -6 rule add fwmark 1 table 100
      ip -6 route add local ::/0 dev lo table 100
    '';

    nftables = {
      enable = true;
      ruleset = nftablesRuleset;
    };
  };
}
