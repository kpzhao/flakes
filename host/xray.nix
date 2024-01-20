{ config, lib, ... }:
let
  nftablesRuleset = ''
      # 保留 IP 参考 https://en.wikipedia.org/wiki/Reserved_IP_addresses
    define LANv4 = {
        0.0.0.0/8,
        10.0.0.0/8,
        127.0.0.0/8,
        169.254.0.0/16,
        172.16.0.0/12,
        192.168.0.0/16,
        224.0.0.0/4,
        240.0.0.0/4
    }

    define LANv6 = {
        ::/128,
        ::1/128,
        fc00::/7,
        fe80::/10,
        ff00::/8
    }

    # 只做了 ipv4
    table ip xray {

        chain local {
            type route hook output priority mangle; policy accept;
            ip protocol != { tcp, udp } accept
            udp dport 53 accept
            tcp dport 53 accept
            ip daddr $LANv4 accept
            meta skgid 23333 accept
            ip protocol { tcp, udp } mark set 1
        }
        chain forward {
            type filter hook prerouting priority mangle; policy accept;
            ip protocol != { tcp, udp } accept
            udp dport 53 accept
            tcp dport 53 accept
            ip daddr $LANv4 accept
            meta skgid 23333 accept
            # DIVERT 规则
            meta l4proto tcp socket transparent 1 meta mark set 1 accept
            ip protocol { tcp, udp } mark set 1 tproxy to :10803
        }

        # chain local-dns-redirect {
            # type nat hook output priority 0; policy accept;

            # ip protocol != { tcp, udp } accept

            # meta mark 7777 accept

            # udp dport 53 redirect to :1053
            # tcp dport 53 redirect to :1053
        # }

        # chain forward-dns-redirect {
            # type nat hook prerouting priority dstnat; policy accept;

            # ip protocol != { tcp, udp } accept

            # meta mark 7777 accept

            # udp dport 53 redirect to :1053
            # tcp dport 53 redirect to :1053
        # }
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
