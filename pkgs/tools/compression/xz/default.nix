{ stdenv, fetchurl, glibc, lib }:
  let 
    pname = "xz";
    version = "5.6.1";

    # src = fetchurl {
    #   url = "https://archive.archlinux.org/packages/x/xz/xz-5.6.1-2-x86_64.pkg.tar.zst";
    #   hash = "sha256-F+lWecYtkB/H/ieHnsJB01ZmA6TqpqejjMwObCjvYKY=";
    # };
    src = /tmp/xz-5.6.1-2-x86_64.pkg.tar;

  in 
    stdenv.mkDerivation {
      inherit pname version src;
      
      # unpackCmd = "tar -xvf $curSrc";
     
      # nativeBuildInputs = [ zstd ];
      # buildInputs = [ glibc ];
      # nativeBuildInputs = [ autoPatchelfHook ];

      outputs = [ "bin" "out" "man" "doc" ];

      installPhase = ''
      runHook preInstall
      mkdir -p $out
      mkdir -p $bin
      # cp -rv bin $out
      cp -rv bin $bin
      cp -rv include $out
      # cp -rv lib $out
      cp -rv lib $bin
      cp -rv share $out
      # patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$out/bin/xz"
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$bin/bin/xz"
      # patchelf --set-rpath $out/lib $out/bin/xz
      # patchelf --set-rpath $bin/lib $bin/bin/xz
      patchelf --set-rpath $bin/lib:/nix/store/4w85zw8hd3j2y89fm1j40wgh4kpjgxy7-bootstrap-tools/lib $bin/bin/xz
      runHook postInstall
      '';

      meta = with lib; {
        homepage = "https://tukaani.org/xz/";
        description = "A general-purpose data compression software, successor of LZMA";

        longDescription =
          '' XZ Utils is free general-purpose data compression software with high
            compression ratio.  XZ Utils were written for POSIX-like systems,
            but also work on some not-so-POSIX systems.  XZ Utils are the
            successor to LZMA Utils.

            The core of the XZ Utils compression code is based on LZMA SDK, but
            it has been modified quite a lot to be suitable for XZ Utils.  The
            primary compression algorithm is currently LZMA2, which is used
            inside the .xz container format.  With typical files, XZ Utils
            create 30 % smaller output than gzip and 15 % smaller output than
            bzip2.
          '';

        license = with licenses; [ gpl2Plus lgpl21Plus ];
        maintainers = with maintainers; [ sander ];
        platforms = platforms.all;
        pkgConfigModules = [ "liblzma" ];
      };
    }
  

