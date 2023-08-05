{
  config,
  pkgs,
  ...
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
        PartOf = ["graphical-session.target"];
      };
      Install.WantedBy = ["sway-session.target"];
      Service = {
        ExecStart = ''
          ${pkgs.swaybg}/bin/swaybg -i /home/Tim/Pictures/Wallpaper/wallpaper1.jpg -m fill
        '';
        Type = "oneshot";
      };
    };
  };
}
