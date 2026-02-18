{
  description = "Home Manager configuration of jun2040";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # astal.url = "path:/home/jun2040/.config/astal";
    # astal.url = "path:/home/jun2040/.config/astal-bar";

    astal.url = "github:aylur/astal";

    ags.url = "github:aylur/ags";

    nixCats.url = "github:bkjn2040/nvim-config";
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
    in
    {
      homeConfigurations."jun2040" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
}
