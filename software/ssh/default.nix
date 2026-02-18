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

      Host school.gitlab.com
        HostName gitlab.epfl.ch
        IdentityFile ~/.ssh/id_ed25519_school
    '';

    enableDefaultConfig = false;

    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
  };
}
