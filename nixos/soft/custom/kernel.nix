{ config, pkgs, lib, ... }:

let
  clangKernel = pkgs.linux_zen.override {
    stdenv = pkgs.clangStdenv;
  };

  stage1Kernel = clangKernel.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
      pkgs.llvmPackages.bintools
      pkgs.lld
      pkgs.llvmPackages.llvm
    ];
    makeFlags = (old.makeFlags or []) ++ [
      "LLVM=1"
      "LLVM_IAS=1"
      "KCFLAGS=-march=znver3 -O3 -pipe -U_FORTIFY_SOURCE -Wno-error"
      "KCPPFLAGS=-march=znver3 -O3 -pipe -U_FORTIFY_SOURCE -Wno-error"
    ];
  });
in
{
  boot.kernelPackages = pkgs.linuxPackagesFor stage1Kernel;

  boot.kernelPatches = [
    {
      name = "disable-gud-and-fortify";
      patch = null;
      structuredExtraConfig = with lib.kernel; {
        DRM_GUD = lib.mkForce no;
        FORTIFY_SOURCE = lib.mkForce no;
        WERROR = lib.mkForce no;
      };
    }
  ];

  environment.systemPackages = [
    pkgs.perf
  ];
}
