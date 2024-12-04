{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = {nixpkgs, ...}: let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {inherit system;};
    inherit (pkgs.beam.interpreters) erlang_27;
    inherit (pkgs.beam) packagesWith;
    beam = packagesWith erlang_27;
  in {
    packages.${system} = {
      # 01 - cli
      spellbook = null;
      # 02 - web chat
      enchanters = null;
      # 03 - real-time observer
      sorcerers_eye = null;
      # 04 - web crawler
      scryer = null;
      # 05 - async job processor
      conductor = null;
    };

    devShells.${system}.default = with pkgs;
      mkShell {
        packages = with pkgs;
          [beam.elixir erlang_27 nodejs sqlite]
          ++ lib.optional stdenv.isLinux [inotify-tools]
          ++ lib.optional stdenv.isDarwin [
            darwin.apple_sdk.frameworks.CoreServices
            darwin.apple_sdk.frameworks.CoreFoundation
          ];
      };
  };
}
