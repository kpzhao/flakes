{ lib
, stdenv
, fetchgit
, meson
, ninja
, pkg-config
, wayland-scanner
, libGL
, wayland
, libinput
, libxkbcommon
, pixman
, xcbutilwm
, libX11
, libcap
, xcbutilimage
, xcbutilerrors
, mesa
, libpng
, ffmpeg_4
, xcbutilrenderutil
, seatd
, vulkan-loader
, glslang
, nixosTests
, hwdata
, cmake
, libdisplay-info
, wlroots
, wlroots-git
, wayland-protocols
, git
, pcre2
, json_c
, pango
, cairo
, libdrm
, udev
, cargo
, xwayland
, gdk-pixbuf
, libevdev
, scdoc

}:

stdenv.mkDerivation rec {
  pname = "sway";
  version = "git-2023-7-23";

  src = fetchgit {
    url = "https://github.com/swaywm/sway";
    rev = "c3e6390073167bae8245d7fac9b455f9f06a5333";
    sha256 = "sha256-QQOVim0U8uiAstPy9HMRBAl4McyvAdXoO44jCRlzVIQ=";
  };

  # $out for the library and $examples for the example programs (in examples):
  # outputs = [ "out"  ];
  
  patches = [
  ./7226.patch
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ 
    meson ninja wayland-protocols git cmake libdrm libxkbcommon mesa vulkan-loader glslang udev seatd hwdata libdisplay-info
    libinput                    
    xcbutilrenderutil
    xwayland
    xcbutilwm
    xcbutilerrors
    gdk-pixbuf
    libevdev
    scdoc
  ];

  buildInputs = [
  
    meson 
    wlroots-git
    wayland
    wayland-protocols 
    pcre2
    json_c
    pango
    cairo
    git

  ]
  # ++ lib.optional enableXWayland xwayland
  ;

  # mesonFlags =
  #   lib.optional (!enableXWayland) "-Dxwayland=disabled"
  # ;
    mesonFlags = let
    # The "sd-bus-provider" meson option does not include a "none" option,
    # but it is silently ignored iff "-Dtray=disabled".  We use "basu"
    # (which is not in nixpkgs) instead of "none" to alert us if this
    # changes: https://github.com/swaywm/sway/issues/6843#issuecomment-1047288761
    # assert trayEnabled -> systemdSupport && dbusSupport;

    sd-bus-provider = "libsystemd" ;
    in
    [ "-Dsd-bus-provider=${sd-bus-provider}" ]
  ;


  # postFixup = ''
  #   # Install ALL example programs to $examples:
  #   # screencopy dmabuf-capture input-inhibitor layer-shell idle-inhibit idle
  #   # screenshot output-layout multi-pointer rotation tablet touch pointer
  #   # simple
  #   mkdir -p $examples/bin
  #   cd ./examples
  #   for binary in $(find . -executable -type f -printf '%P\n' | grep -vE '\.so'); do
  #     cp "$binary" "$examples/bin/wlroots-$binary"
  #   done
  # '';

  # Test via TinyWL (the "minimum viable product" Wayland compositor based on wlroots):
  # passthru.tests.tinywl = nixosTests.tinywl;

  # meta = with lib; {
  #   description = "A modular Wayland compositor library";
  #   longDescription = ''
  #     Pluggable, composable, unopinionated modules for building a Wayland
  #     compositor; or about 50,000 lines of code you were going to write anyway.
  #   '';
  #   inherit (src.meta) homepage;
  #   changelog = "https://gitlab.freedesktop.org/wlroots/wlroots/-/tags/${version}";
  #   license = licenses.mit;
  #   platforms = platforms.linux;
  #   maintainers = with maintainers; [ primeos synthetica ];
  # };
}
