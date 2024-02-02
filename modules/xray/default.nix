{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.my.xray;
  inherit (cfg) xrayUserName;
  nft_file = builtins.toFile "xray.nft" ''
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

  xrayModule = types.submodule {
    options = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable xray transparent proxy module.";
      };

      configPath = mkOption {
        type = types.path;
        description = "Path to the Clash config file.";
      };

      xrayUserName = mkOption {
        type = types.str;
        default = "xray";
        description =
          "The user who would run the xray proxy systemd service. User would be created automatically.";
      };

      tproxyPort = mkOption {
        type = types.port;
        default = 10803;
        description =
          "xray tproxy-port";
      };

      afterUnits = mkOption {
        type = with types; listOf str;
        default = [ ];
        description =
          "List of systemd units that need to be started after xray. Note this is placed in `before` parameter of xray's systemd config.";
      };

      requireUnits = mkOption {
        type = with types; listOf str;
        default = [ ];
        description =
          "List of systemd units that need to be required by xray.";
      };

      beforeUnits = mkOption {
        type = with types; listOf str;
        default = [ ];
        description =
          "List of systemd units that need to be started before clash. Note this is placed in `after` parameter of xray's systemd config.";
      };
    };
  };
in
{
  options.my.xray = mkOption {
    type = xrayModule;
    default = { };
    description = "xray system service related configurations";
  };

  config = mkIf (cfg.enable) {
    # environment.etc."xray/config.json".source = cfg.configPath;

    users.users.${xrayUserName} = {
      description = "xray deamon user";
      isSystemUser = true;
      group = "xray";
    };
    users.groups.xray = {
      gid = 23333;
    };

    networking = {
      hostName = "frame";
      firewall.enable = false;
      useNetworkd = true;
      useDHCP = false;
      wireless.iwd.enable = true;
      nftables = {
        enable = true;
        # ruleset = nftablesRuleset;
      };
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

    # Don't use resolved which is enabled by default once networkd is enabled
    # This priority is higher than mkDefault (1000), but less than manual definition
    # services.resolved.enable = mkOverride 999 false;
    systemd.network.networks = {
      lo = {
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

    systemd.services.xray =
      {
        path = with pkgs; [ xray ];
        description = "xray networking service";
        after = [ "network.target" ] ++ cfg.beforeUnits;
        before = cfg.afterUnits;
        requires = cfg.requireUnits;
        wantedBy = [ "multi-user.target" ];
        script =
          "${lib.getExe' pkgs.xray "xray"} -c /nix/persist/etc/config-nft.json"; # We don't need to worry about whether /etc/clash is reachable in Live CD or not. Since it would never be execuated inside LiveCD.

        # Don't start if the config file doesn't exist.
        # unitConfig = {
        #   # NOTE: configPath is for the original config which is linked to the following path.
        #   ConditionPathExists = " /nix/persist/etc/config-nft.json";
        # };
        serviceConfig = {
          # Use prefix `+` to run iptables as root.
          ExecStartPre = "+${lib.getExe pkgs.nftables} -f ${nft_file}";
          ExecStopPost = "+${lib.getExe pkgs.nftables} delete table ip xray";
          # CAP_NET_BIND_SERVICE: Bind arbitary ports by unprivileged user.
          # CAP_NET_ADMIN: Listen on UDP.
          AmbientCapabilities =
            "CAP_NET_BIND_SERVICE CAP_NET_ADMIN"; # We want additional capabilities upon a unprivileged user.
          User = xrayUserName;
          Restart = "on-failure";
        };
      };
  };
}
