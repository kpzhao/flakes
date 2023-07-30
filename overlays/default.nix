final: prev: rec {
           # xwayland = prev.xwayland.overrideAttrs (_: {
           #         patches = [
           #         ./hidpi.patch
           #         ];
           #         });

           wlroots_0_17 = (final.wlroots_0_16.overrideAttrs (old: {
                       version = "unstable-2023-06-03";
                       src = final.fetchFromGitLab {
                       domain = "gitlab.freedesktop.org";
                       owner = "wlroots";
                       repo = "wlroots";
                       # rev = "71b57b8d27e2817ebcaa6471e22251203c370554";
                       rev = "d40bcfe2c18f057f4bc324a81230f6ba2267db44"; # 20230729
                       # hash = "sha256-yYFlQsHD/TU0l6pS0t9tSHh7w+LFAUclJMpSyiA+Wnw=";
                       hash = "sha256-6MEVZCCwmNjKgMGDBIF2J2748vJEcEOaifLycXamvz0="; #20230729
                       };

                       # patches = [
                       # ./0001-xwayland-support-HiDPI-scale.patch
                       # ./0002-Fix-configure_notify-event.patch
                       # ];

                       nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
                       buildInputs = (old.buildInputs or [ ]) ++ [
                       final.libdisplay-info
                       final.libliftoff
                       ];
                       })).override { };

           sway-test = (prev.sway-unwrapped.overrideAttrs (old: {
                       version = "test";
                       src = final.fetchFromGitHub {
                       owner = "swaywm";
                       repo = "sway";
                       # rev = "6bd11ad0dfb11f8cf7e0ab5330cd2488851c5614";
                       rev = "c3e6390073167bae8245d7fac9b455f9f06a5333";
                       # sha256 = "sha256-WxnT+le9vneQLFPz2KoBduOI+zfZPhn1fKlaqbPL6/g=";
                       # sha256 = "sha256-wV24FHJ+ZB95OSWEYF0UzZ9qA8NDBvFUONFdOfnXEEs=";
                       sha256 = "sha256-QQOVim0U8uiAstPy9HMRBAl4McyvAdXoO44jCRlzVIQ=";
                       };

                       nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [  ];

# Our version of sway already has this patch upstream, so we filter it out.
                       patches = builtins.filter
                       # (p: !p ? name || (p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch" && p.name != "load-configuration-from-etc.patch" && p.name != "fix-paths.patch" && p.name != "sway-config-no-nix-store-references.patch" && p.name != "sway-config-nixos-paths.patch"))
                       (p: !p ? name || (p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")) 
                       (old.patches or [ ]);

                       })).override { wlroots = final.wlroots_0_17; enableXWayland = false; };
       }
