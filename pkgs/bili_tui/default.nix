{ lib
, buildGoModule
, source
, fetchFromGitHub
}:

buildGoModule {
  inherit (source) pname version src ;
  vendorHash = "sha256-eoLVLAzbw9BxbSgHWxmaxVmlV6RhIscwSAJrv2OpU+k=";


  subPackages = [ "." ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "终端下使用的bilibili弹幕获取和弹幕发送服务";
    homepage = "https://github.com/yaocccc/bilibili_live_tui";
    mainProgram = "bili";
    platforms = platforms.linux;
  };
}
