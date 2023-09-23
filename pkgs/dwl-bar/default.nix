{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, libX11
, libinput
, libxcb
, libxkbcommon
, pango
, pixman
, pkg-config
, substituteAll
, wayland-scanner
, wayland
, wayland-protocols
, wlroots-hidpi
, writeText
, xcbutilwm
, xwayland
, enableXWayland ? true
, conf ? null
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dwl-bar";
  version = "0.4";

  src = builtins.fetchGit {
    url = "https://github.com/MadcowOG/dwl-bar";
    rev = "a5dbf902cfd893b97bfbf9f1064f5d9c068b3984";
    ref = "main";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    wayland-scanner
    pango
  ];

  buildInputs = [
    libinput
    libxcb
    libxkbcommon
    pixman
    wayland
    wayland-protocols
    # wlroots-hidpi
  ]  ;

  outputs = [ "out" ];

  makeFlags = [
     "PREFIX=$(out)"
  ];



})
# TODO: custom patches from upstream website
