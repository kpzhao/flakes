{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs; [
      xray
    ];
  };

  home.file.".config/xray/config.json".source = ./config.json;

  systemd.user.services = {
    xray = {
      Unit = {
        Description = "xray is a proxy tool";
      };
      Install.WantedBy = ["default.target"];
      Service = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.xray}/bin/xray -c /home/Tim/.config/xray/config.json
        '';
        Restart = "on-failure";
      };
    };
  };
}
