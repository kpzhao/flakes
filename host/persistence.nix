{ config
, pkgs
, ...
}: {
  # /nix/persistent 是你实际保存文件的地方
  environment.persistence."/nix/persist" = {
    # 不让这些映射的 mount 出现在文件管理器的侧边栏中
    hideMounts = true;

    # 你要映射的文件夹
    directories = [
      "/etc/NetworkManager/system-connections"
      "/home"
      "/root"
      "/var"
    ];

    # 你要映射的文件
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
    ];

    # 类似的，你还可以在用户的 home 目录中单独映射文件和文件夹
    users.Tim = {
      directories = [
        # 个人文件
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"

        # 配置文件夹
        ".cache"
        ".config"
        ".gnupg"
        ".local"
        ".mozilla"
        ".ssh"
      ];
      files = [ ];
    };
  };
}
