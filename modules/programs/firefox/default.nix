{
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.ihome = {
      isDefault = true;
      settings = {
        "media.av1.enabled" = false;
        "media.ffmpeg.vaapi.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };
}
