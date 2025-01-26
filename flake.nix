{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: {
    devShells.x86_64-linux.default = let
      system = "x86_64-linux";
      pkgs = import nixpkgs {inherit system;};
    in
      pkgs.mkShell {
        packages = [pkgs.bison pkgs.flex pkgs.gcc];
        shellHook = ''
          alias run="flex simple_language.l && yacc -d simple_language.y && g++ lex.yy.c y.tab.c -o parser"
        '';
      };
  };
}
