# similar to interpreters/python/default.nix
{
  stdenv,
  config,
  lib,
  callPackage,
  fetchFromGitHub,
  fetchurl,
  makeBinaryWrapper,
  path,
}:
let
  # Common passthru for all lua interpreters.
  # copied from python
  passthruFun =
    {
      executable,
      luaversion,
      packageOverrides,
      luaOnBuildForBuild,
      luaOnBuildForHost,
      luaOnBuildForTarget,
      luaOnHostForHost,
      luaOnTargetForTarget,
      luaAttr ? null,
      self, # is luaOnHostForTarget
    }:
    let
      luaPackages =
        callPackage
          # Function that when called
          # - imports lua-packages.nix
          # - adds spliced package sets to the package set
          # - applies overrides from `packageOverrides`
          (
            {
              lua,
              overrides,
              callPackage,
              makeScopeWithSplicing',
            }:
            let
              luaPackagesFun = callPackage "${path}/pkgs/top-level/lua-packages.nix" {
                lua = self;
              };
              generatedPackages =
                if (builtins.pathExists "${path}/pkgs/development/lua-modules/generated-packages.nix") then
                  (
                    final: prev:
                    callPackage "${path}/pkgs/development/lua-modules/generated-packages.nix" {
                      inherit (final) callPackage;
                    } final prev
                  )
                else
                  (final: prev: { });
              overriddenPackages = callPackage "${path}/pkgs/development/lua-modules/overrides.nix" { };

              otherSplices = {
                selfBuildBuild = luaOnBuildForBuild.pkgs;
                selfBuildHost = luaOnBuildForHost.pkgs;
                selfBuildTarget = luaOnBuildForTarget.pkgs;
                selfHostHost = luaOnHostForHost.pkgs;
                selfTargetTarget = luaOnTargetForTarget.pkgs or { };
              };

              aliases =
                final: prev:
                lib.optionalAttrs config.allowAliases (
                  import "${path}/pkgs/development/lua-modules/aliases.nix" lib final prev
                );

              extensions = lib.composeManyExtensions [
                aliases
                generatedPackages
                overriddenPackages
                overrides
              ];
            in
            makeScopeWithSplicing' {
              inherit otherSplices;
              f = lib.extends extensions luaPackagesFun;
            }
          )
          {
            overrides = packageOverrides;
            lua = self;
          };
    in
    rec {
      buildEnv = callPackage "${path}/pkgs/development/interpreters/lua-5/wrapper.nix" {
        lua = self;
        makeWrapper = makeBinaryWrapper;
        inherit (luaPackages) requiredLuaModules;
      };
      withPackages = import "${path}/pkgs/development/interpreters/lua-5/with-packages.nix" {
        inherit buildEnv luaPackages;
      };
      pkgs =
        let
          lp = luaPackages;
        in
        lp
        // {
          luaPackages = lp.luaPackages // {
            __attrsFailEvaluation = true;
          };
        };
      interpreter = "${self}/bin/${executable}";
      inherit executable luaversion;
      luaOnBuild = luaOnBuildForHost.override {
        inherit packageOverrides;
        self = luaOnBuild;
      };

      tests = callPackage "${path}/pkgs/development/interpreters/lua-5/tests.nix" {
        lua = self;
        inherit (luaPackages) wrapLua;
      };

      inherit luaAttr;
    };
in
rec {
  luajit_2_1 = import ./luajit/luajit.nix {
    self = luajit_2_1;
    inherit
      callPackage
      fetchFromGitHub
      passthruFun
      lib
      ;
  };
}
