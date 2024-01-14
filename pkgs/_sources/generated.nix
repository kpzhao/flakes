# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  bili_tui = {
    pname = "bili_tui";
    version = "fa2d6d249aa745dbb958d5d43bc59f4b36e10b43";
    src = fetchFromGitHub {
      owner = "yaocccc";
      repo = "bilibili_live_tui";
      rev = "fa2d6d249aa745dbb958d5d43bc59f4b36e10b43";
      fetchSubmodules = false;
      sha256 = "sha256-i/jb2ZCduR83kglq9r9UjxRrA92wHezVnXGPw1Sxzo4=";
    };
    date = "2024-01-13";
  };
  bird-babel-rtt = {
    pname = "bird-babel-rtt";
    version = "bcbd53c4966cb59a50aa9d004250e08d10038250";
    src = fetchFromGitHub {
      owner = "NickCao";
      repo = "bird";
      rev = "bcbd53c4966cb59a50aa9d004250e08d10038250";
      fetchSubmodules = false;
      sha256 = "sha256-9DxTnftcJ52JTvTWW+V37VQR1aXL0Nt0sHXVcOicrbU=";
    };
    date = "2023-10-07";
  };
  fcitx5-pinyin-zhwiki = {
    pname = "fcitx5-pinyin-zhwiki";
    version = "20231205";
    src = fetchurl {
      url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.4/zhwiki-20231205.dict";
      sha256 = "sha256-crMmSqQ7QgmjgEG8QpvBgQYfvttCUsKYo8gHZGXIZmc=";
    };
  };
  sway-git = {
    pname = "sway-git";
    version = "c5fd8c050f7ddbfe3e5b7abc8f5f6ace3a3c5307";
    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "c5fd8c050f7ddbfe3e5b7abc8f5f6ace3a3c5307";
      fetchSubmodules = false;
      sha256 = "sha256-RoTFYjSb6miOnUSjEglbDwMy5mCVt3i4N/5tJSLTLgI=";
    };
    date = "2024-01-08";
  };
  wlroots-git = {
    pname = "wlroots-git";
    version = "ce89f49b7aab281198fad64e9a825a24dbf72e3d";
    src = fetchgit {
      url = "https://gitlab.freedesktop.org/wlroots/wlroots.git";
      rev = "ce89f49b7aab281198fad64e9a825a24dbf72e3d";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-JOrvP2cSCdpFEArVbIwBdRtRcayd7MszbCREEefQFh8=";
    };
    date = "2024-01-09";
  };
  xwayland-xprop = {
    pname = "xwayland-xprop";
    version = "23.2.3";
    src = fetchurl {
      url = "https://xorg.freedesktop.org/archive/individual/xserver/xwayland-23.2.3.tar.xz";
      sha256 = "sha256-652apyMsR0EsiDXsFal8V18DVjcmx4d1T/DAGb0H4wI=";
    };
  };
}
