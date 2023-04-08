{ lib, targetPlatform }:

let
  isAarch64Darwin = targetPlatform.isDarwin && targetPlatform.isAarch64;
  p =  targetPlatform.gcc or {}
    // targetPlatform.parsed.abi;
in lib.concatLists [
  # --with-arch= is unknown flag on x86_64 and aarch64-darwin.
  (lib.optional (!targetPlatform.isx86_64 && !isAarch64Darwin && p ? arch) "--with-arch=${p.arch}")
  # Skip `--with-cpu` on aarch64-darwin; otherwise configure fails with "Unknown cpu used in --with-cpu=apple-a13".
  (lib.optional (!isAarch64Darwin && p ? cpu) "--with-cpu=${p.cpu}")
  (lib.optional (p ? abi) "--with-abi=${p.abi}")
  (lib.optional (p ? fpu) "--with-fpu=${p.fpu}")
  (lib.optional (p ? float) "--with-float=${p.float}")
  (lib.optional (p ? mode) "--with-mode=${p.mode}")
  (lib.optional
    (let tp = targetPlatform; in tp.isPower && tp.libc == "glibc" && tp.is64bit)
    "--with-long-double-128")
]
