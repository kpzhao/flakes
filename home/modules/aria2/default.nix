{ pkgs
, ...
}: {
  home = {
    packages = with pkgs; [
      aria2
    ];
  };
  systemd.user.services = {
    aria2 = {
      Unit = {
        Description = "aria2 daemon";
      };
      Install.WantedBy = [ "default.target" ];
      Service = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.aria2}/bin/aria2c
        '';
        Restart = "on-failure";
      };
    };
  };
  programs.aria2 = {
    enable = true;
    settings = {
      dir = "/home/Tim/Downloads";
      file-allocation = "none";
      continue = true;
      log-level = "warn";
      ## 下载连接相关 ##

      # 最大同时下载任务数, 运行时可修改, 默认:5
      max-concurrent-downloads = "2";
      # 同一服务器连接数, 添加时可指定, 默认:1
      max-connection-per-server = "15";
      # 最小文件分片大小, 添加时可指定, 取值范围1M -1024M, 默认:20M
      # 假定size=10M, 文件为20MiB 则使用两个来源下载; 文件为15MiB 则使用一个来源下载
      min-split-size = "10M";
      # 单个任务最大线程数, 添加时可指定, 默认:5
      split = "16";
      # 整体下载速度限制, 运行时可修改, 默认:0
      #max-overall-download-limit=0
      # 单个任务下载速度限制, 默认:0
      #max-download-limit=0
      # 整体上传速度限制, 运行时可修改, 默认:0
      max-overall-upload-limit = "20kb";
      # 单个任务上传速度限制, 默认:0
      max-upload-limit = "5kb";
      # 禁用IPv6, 默认:false
      disable-ipv6 = true;
      # 禁用https证书检查
      check-certificate = false;
      #运行覆盖已存在文件
      allow-overwrite = true;
      #自动重命名
      auto-file-renaming = false;

      ## 进度保存相关 ##

      # 从会话文件中读取下载任务
      input-file = "/home/Tim/.config/aria2/aria2.session";
      # 在Aria2退出时保存`错误/未完成`的下载任务到会话文件
      save-session = "/home/Tim/.config/aria2/aria2.session";
      # 定时保存会话, 0为退出时才保存, 需1.16.1以上版本, 默认:0
      save-session-interval = "120";

      ## RPC相关设置 ##

      # 启用RPC, 默认:false
      enable-rpc = true;
      # 允许所有来源, 默认:false
      rpc-allow-origin-all = true;
      # 允许非外部访问, 默认:false
      rpc-listen-all = true;
      # 事件轮询方式, 取值:[epoll, kqueue, port, poll, select], 不同系统默认值不同
      #event-poll=select
      # RPC监听端口, 端口被占用时可以修改, 默认:6800
      rpc-listen-port = "6800";
      # 保存上传的种子文件
      rpc-save-upload-metadata = true;

      ## BT/PT下载相关 ##

      # 当下载的是一个种子(以.torrent结尾)时, 自动开始BT任务, 默认:true
      #follow-torrent=true
      # BT监听端口, 当端口被屏蔽时使用, 默认:6881-6999
      listen-port = "51413";
      # 单个种子最大连接数, 默认:55
      #bt-max-peers=55
      # 打开DHT功能, PT需要禁用, 默认:true
      enable-dht = true;
      # 打开IPv6 DHT功能, PT需要禁用
      enable-dht6 = false;
      # DHT网络监听端口, 默认:6881-6999
      #dht-listen-port=6881-6999
      # 本地节点查找, PT需要禁用, 默认:false
      bt-enable-lpd = true;
      # 种子交换, PT需要禁用, 默认:true
      enable-peer-exchange = true;
      # 当种子的分享率达到这个数时, 自动停止做种, 0为一直做种, 默认:1.0
      seed-ratio = "1.0";
      # 继续之前的BT任务时, 无需再次校验, 默认:false
      bt-seed-unverified = true;
      # 保存磁力链接元数据为种子文件(.torrent文件), 默认:false
      bt-save-metadata = false;
      # 加载已保存的元数据文件(.torrent)，默认:false
      bt-load-saved-metadata = false;
      #仅下载种子文件
      # bt-metadata-only = true;
      #通过网上的种子文件下载，种子保存在内存
      follow-torrent = "mem";

      bt-tracker = "udp://tracker.opentrackr.org:1337/announce,udp://tracker.leechers-paradise.org:6969/announce,udp://p4p.arenabg.com:1337/announce,udp://9.rarbg.to:2710/announce,udp://9.rarbg.me:2710/announce,udp://exodus.desync.com:6969/announce,udp://tracker.sbsub.com:2710/announce,udp://retracker.lanta-net.ru:2710/announce,udp://open.stealth.si:80/announce,udp://tracker.tiny-vps.com:6969/announce,udp://tracker.cyberia.is:6969/announce,udp://tracker.torrent.eu.org:451/announce,udp://tracker.moeking.me:6969/announce,udp://tracker3.itzmx.com:6961/announce,udp://ipv4.tracker.harry.lu:80/announce,udp://bt2.archive.org:6969/announce,udp://bt1.archive.org:6969/announce,http://tracker1.itzmx.com:8080/announce,udp://valakas.rollo.dnsabr.com:2710/announce,udp://tracker.zerobytes.xyz:1337/announce";
    };
  };
}
