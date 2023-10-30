{ config
, pkgs
, ...
}: {
  home = {
    packages = with pkgs; [
      sioyek
    ];
  };

  home.file.".config/sioyek/prefs_user.config".source = config.lib.file.mkOutOfStoreSymlink "./prefs_user.config";
  home.file.".config/sioyek/keys_user.config".source = config.lib.file.mkOutOfStoreSymlink "./keys_user.config";
}
