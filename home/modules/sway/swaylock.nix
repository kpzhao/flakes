{ ... }: {
  # security.pam.services.swaylock = {};
    programs.swaylock.settings = {
    show-failed-attempts = true;
    daemonize = true;
    scaling = "fill";
  };
}
