{ ... }:

{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        HostName github.com
        IdentityFile ~/.ssh/id_ed25519_personal

      Host github-work
        HostName github.com
        IdentityFile ~/.ssh/id_ed25519_work

      Host gitlab-school
        HostName gitlab.epfl.ch
        IdentityFile ~/.ssh/id_ed25519_school
    '';
  };
}
