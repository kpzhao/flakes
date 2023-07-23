{ lib
, stdenv
, fetchFromGitLab
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
}:

stdenv.mkDerivation rec {
  pname = "sway";
  version = "unstable-git-2023-1";

  src = fetchFromGitLab {
    domain = "github.com";
    owner = "swaywm";
    repo = "sway";
    rev = "c3e6390";
    sha256 = "sha256-35/po0RF0xTwSyjkUbYOALsc4WNJo2sVnmqk6PoxtnI=";
  };

  # $out for the library and $examples for the example programs (in examples):
  outputs = [ "out"  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ 
    meson ninja wayland-protocols git cmake libdrm libxkbcommon mesa vulkan-loader glslang udev seatd hwdata libdisplay-info
    libinput                    
    xcbutilrenderutil
    xwayland
    xcbutilwm
    xcbutilerrors
  ];

  buildInputs = [
  
    meson 
    wlroots
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
