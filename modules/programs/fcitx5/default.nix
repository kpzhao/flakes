{
  pkgs,
  config,
  lib,
  ...
}: {
  # home.file.".config/fcitx5/profile".source = ./profile;
  # home.file.".config/fcitx5/profile-bak".source = ./profile; # used for backup
  #
  # # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile file,
  # # which will override my config managed by home-manager
  # # so we need to remove it before everytime we rebuild the config
  # home.activation.removeExistingFcitx5Profile = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
  #   rm -f "${config.xdg.configHome}/fcitx5/profile"
  # '';

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
    ];
  };
}
