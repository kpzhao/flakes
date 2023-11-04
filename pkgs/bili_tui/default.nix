{ lib
, buildGoModule
, source
, fetchFromGitHub
}:

buildGoModule {
  inherit (source) pname version src vendorSha256;

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
