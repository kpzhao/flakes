{ config
, pkgs
, ...
}: {
  home = {
    packages = with pkgs; [
      swaybg
    ];
  };

  systemd.user.services = {
    swaybg = {
      Unit = {
        Description = "default wallpaper";
        PartOf = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "sway-session.target" ];
      Service = {
        ExecStart = ''
          ${pkgs.swaybg}/bin/swaybg -i /home/Tim/Pictures/Wallpaper/1.png -m fill
        '';
        Type = "oneshot";
      };
    };
  };
}
