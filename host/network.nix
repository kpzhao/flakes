{ config, lib, pkgs, ... }:
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
  users.users.xray = {
    isSystemUser = true;
    # uid = ;
    group = "xray";
    # extraGroups = [ "proxy" ];
    packages = with pkgs; [
      xray
    ];
  };
  users.groups = {
    xray.gid = 23333;
  };

  networking = {
    hostName = "frame";
    firewall.enable = false;
    useNetworkd = true;
    useDHCP = false;
    wireless.iwd.enable = true;
    nftables = {
      enable = true;
      ruleset = nftablesRuleset;
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

    # Use networkd to manage our local loopback
    #
    # [Match]
    # Name = lo
    #
    # [RoutingPolicyRule]
    # FirewallMark = 1
    # Table = 100
    # Priority = 100
    #
    # [Route]
    # Table = 100
    # Destination = 0.0.0.0/0
    # Type = local
    "10-lo" = {
      # equivalent to matchConfig.Name = "lo";
      name = "lo";
      routingPolicyRules = [{
        # Route all packets with firewallmark 1 (set by iptables in output chain) using table "100" which says go to loopback
        routingPolicyRuleConfig = { FirewallMark = 1; Table = 100; Priority = 100; };
      }
        { routingPolicyRuleConfig = { From = "::/0"; FirewallMark = 1; Table = 100; Priority = 100; }; }];
      routes = [
        # Create a table that routes to loopback
        { routeConfig = { Table = 100; Destination = "0.0.0.0/0"; Type = "local"; }; }
        { routeConfig = { Table = 100; Destination = "::/0"; Type = "local"; }; }
      ];
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

  systemd.services.xray = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "xray service";
    serviceConfig = {
      Type = "simple";
      User = "xray";
      ExecStart = ''${pkgs.xray}/bin/xray -c /nix/persist/etc/config-nft.json'';
      # ExecStop = ''${pkgs.screen}/bin/screen -S irc -X quit'';
      Restart = "always";
      RestartSec = "1";
      CapabilityBoundingSet = "CAP_NET_BIND_SERVICE CAP_NET_RAW";
      AmbientCapabilities = "CAP_NET_BIND_SERVICE CAP_NET_RAW";
    };
  };
}
