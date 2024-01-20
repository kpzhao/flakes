{ pkgs
, ...
}: {

  xdg.configFile = {
    "fcitx5/profile" = {
      source = ./profile;
      # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile,
      # so we need to force replace it in every rebuild to avoid file conflict.
      force = true;
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-configtool
      fcitx5-chinese-addons
      fcitx5-pinyin-zhwiki
    ];
  };
}
