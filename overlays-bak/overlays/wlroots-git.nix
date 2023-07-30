{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  libGL,
  wayland,
  wayland-protocols,
  libinput,
  libxkbcommon,
  pixman,
  xcbutilwm,
  libX11,
  libcap,
  xcbutilimage,
  xcbutilerrors,
  mesa,
  libpng,
  ffmpeg_4,
  xcbutilrenderutil,
  seatd,
  vulkan-loader,
  glslang,
  nixosTests,
  hwdata,
  cmake,
  libdisplay-info,
  xwayland-git,
  fetchgit,
}:
stdenv.mkDerivation rec {
  pname = "wlroots";
  version = "git";

  # src = fetchFromGitLab {
  #   domain = "gitlab.freedesktop.org";
  #   owner = "wlroots";
  #   repo = "wlroots";
  #   rev = "63f5851b";
  #   sha256 = "sha256-35/po0RF0xTwSyjkUbYOALsc4WNJo2sVnmqk6PoxtnI=";
  # };

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/wlroots/wlroots";
    rev = "63f5851b6fdc630355510c44e875119c4755208d";
    sha256 = "sha256-35/po0RF0xTwSyjkUbYOALsc4WNJo2sVnmqk6PoxtnI=";
  };

  patches = [
    ./0001-xwayland-support-HiDPI-scale.patch
    ./0002-Fix-configure_notify-event.patch
  ];

  # $out for the library and $examples for the example programs (in examples):
  # outputs = [ "out" "examples" ];

  depsBuildBuild = [pkg-config];

  nativeBuildInputs = [meson ninja cmake pkg-config wayland-scanner glslang hwdata libdisplay-info];

  buildInputs = [
    libGL
    wayland
    wayland-protocols
    libinput
    libxkbcommon
    pixman
    xcbutilwm
    libX11
    libcap
    xcbutilimage
    xcbutilerrors
    mesa
    libpng
    ffmpeg_4
    xcbutilrenderutil
    seatd
    vulkan-loader
    xwayland-git
  ];

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
  #
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
