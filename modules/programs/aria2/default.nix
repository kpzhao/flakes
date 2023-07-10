{ pkgs, config, lib, user, ... }: 

{
    home = {
        packages = with pkgs; [
            aria2
        ];
    };
    systemd.user.services = {
        aria2 = {
            Unit = {
                Description = "aria2 daemon";
            };
            Install.WantedBy = [ "default.target" ];
            Service = {
                Type = "simple";
                ExecStart = ''
                    ${pkgs.aria2}/bin/aria2c
                    '';
                Restart = "on-failure";
            };
        };
    };
    programs.aria2 = {
        enable = true;
        settings = {
            dir = "/home/Tim/Downloads";
            file-allocation = "none";
            log-level = "warn";
            split = "10";
            max-connection-per-server = 10;
            min-split-size = "5M";
            bt-max-peers = "0";
            bt-request-peer-speed-limit = "0";
            max-overall-upload-limit = "512k";
            bt-external-ip = "127.0.0.1";
            dht-listen-port = "6882";
            enable-dht = "true";
            enable-peer-exchange = "true";
            listen-port = "6800";
            bt-force-encryption = "true";
            bt-min-crypto-level = "arc4";
            bt-require-crypto = "true";
            follow-torrent = "mem";
            seed-ratio = "100";
            seed-time = "0";
            socket-recv-buffer-size = "1M";
            event-poll = "epoll";
            realtime-chunk-checksum = "true";
            allow-overwrite = "true";
            always-resume = "true";
            auto-file-renaming = "false";
            continue = "true";
            rpc-save-upload-metadata = "false";
            enable-rpc=true;
        };
    };
}
