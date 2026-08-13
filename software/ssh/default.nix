{ ... }:

{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        HostName github.com
        IdentityFile ~/.ssh/id_ed25519_personal

      Host work.github.com
        HostName github.com
        IdentityFile ~/.ssh/id_ed25519_work

      Host gitlab.epfl.ch
        HostName gitlab.epfl.ch
        IdentityFile ~/.ssh/id_ed25519_epfl
    '';

    enableDefaultConfig = false;

    settings."*" = {
      ForwardAgent = false;
      AddKeysToAgent = "no";
      Compression = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
    };
  };
}
