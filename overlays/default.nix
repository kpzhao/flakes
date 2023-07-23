# $ cat /tmp/overlay/local-packages.nix
final: prev: rec {
# we create new 'ski' attribute here!
           sway-git = final.callPackage ./sway-git.nix {};
           wlroots-git = final.callPackage ./wlroots-git.nix {};
           xwayland-git = final.callPackage ./xwayland-git.nix {};

           xwayland = prev.xwayland.overrideAttrs (_: {
                   patches = [
                   ./hidpi.patch
                   ];
                   });

           wlroots_0_17 = (final.wlroots_0_16.overrideAttrs (old: {
                       version = "unstable-2023-06-03";
                       src = final.fetchFromGitLab {
                       domain = "gitlab.freedesktop.org";
                       owner = "wlroots";
                       repo = "wlroots";
                       rev = "71b57b8d27e2817ebcaa6471e22251203c370554";
                       hash = "sha256-yYFlQsHD/TU0l6pS0t9tSHh7w+LFAUclJMpSyiA+Wnw=";
                       };
# src = fetchgit {
# url = "https://github.com/swaywm/sway";
# rev = "c3e6390073167bae8245d7fac9b455f9f06a5333";
# sha256 = "sha256-QQOVim0U8uiAstPy9HMRBAl4McyvAdXoO44jCRlzVIQ=";
# };
#

                       patches = [
                       ./0001-xwayland-support-HiDPI-scale.patch
                       ./0002-Fix-configure_notify-event.patch
                       ];

                       nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
                       buildInputs = (old.buildInputs or [ ]) ++ [
                           final.libdisplay-info
                               final.libliftoff
                       ];
           })).override { };

           sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
                       version = "git-2023-07-23-1";
                       src = final.fetchFromGitHub {
                       owner = "swaywm";
                       repo = "sway";
                       rev = "123";
                       hash = "sha256-WxnT+le9vneQLFPz2KoBduOI+zfZPhn1fKlaqbPL6/g=";
                       };

                       patch = [
                       ./7226.patch
                       ];

                       nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish cmake ];

# # Our version of sway already has this patch upstream, so we filter it out.
#                        patches = builtins.filter
#                        (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
#                        (old.patches or [ ]);

                       })).override { wlroots = final.wlroots_0_17; };

# xwayland = prev.xwayland.overrideAttrs (_: {
#         patches = [
#         ./hidpi.patch
#         ];
#         });

#            wlroots-hidpi =
#                (prev.wlroots.overrideAttrs (_: {
#                                             version = "unstable-2023-06-03";
#                                             src = prev.fetchFromGitLab {
#                                             domain = "gitlab.freedesktop.org";
#                                             owner = "wlroots";
#                                             repo = "wlroots";
#                                             rev = "63f5851b6fdc630355510c44e875119c4755208d";
# # sha256 = "sha256-/fJGHeDuZ9aLjCSxILqNSm2aMrvlLZMZpx/WzX5A/XU=";
#                                             sha256 = "sha256-35/po0RF0xTwSyjkUbYOALsc4WNJo2sVnmqk6PoxtnI=";
#                                             };
#
#                                             patches = [
#                                             ./0001-xwayland-support-HiDPI-scale.patch
#                                             ./0002-Fix-configure_notify-event.patch
#                                             ];
#                                             nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
#                                             buildInputs = (prev.buildInputs or [ ]) ++ [
#                                             final.libdisplay-info
#                                             final.libliftoff
#                                             ];
#                                             }))/* .override { inherit xwayland; } */;
#            sway-unwrapped =
#                (prev.sway-unwrapped.overrideAttrs (oa: {
#                                                    src = prev.fetchFromGitHub {
#                                                    owner = "swaywm";
#                                                    repo = "sway";
#                                                    rev = "68d620a";
#                                                    sha256 = "sha256-WRvJsSvDv2+qirqkpaV2c7fFOgJAT3sXxPtKLure580=";
#                                                    };
#
#                                                    buildInputs = oa.buildInputs ++ [ prev.pcre2 prev.xorg.xcbutilwm ];
#                                                    })).override { wlroots = wlroots-hidpi; };

# add more packages below:
# ...
       }
