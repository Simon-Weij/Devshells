{
  inputs = {
    flakelight.url = "github:nix-community/flakelight";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "flakelight/nixpkgs";
    };
  };

  outputs = {
    flakelight,
    rust-overlay,
    ...
  }:
    flakelight ./. {
      nixpkgs.overlays = [rust-overlay.overlays.default];

      nixpkgs.config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };

      devShell = pkgs: let
        androidSdk =
          (pkgs.androidenv.composeAndroidPackages {
            ndkVersions = ["28.2.13676358"];
            includeNDK = true;
            buildToolsVersions = ["35.0.0"];
            platformVersions = ["36"];
          }).androidsdk;
        ndkRoot = "${androidSdk}/libexec/android-sdk/ndk/28.2.13676358";
        llvmBin = "${ndkRoot}/toolchains/llvm/prebuilt/linux-x86_64/bin";
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = ["rust-src"];
          targets = [
            "aarch64-linux-android"
            "armv7-linux-androideabi"
            "i686-linux-android"
            "x86_64-linux-android"
          ];
        };
      in {
        packages = with pkgs; [
          pkg-config
          wrapGAppsHook4
          nodejs-slim
          pnpm
          librsvg
          webkitgtk_4_1
          jdk21
          android-tools
          rustToolchain
          androidSdk
        ];

        shellHook = ''
          export XDG_DATA_DIRS="$GSETTINGS_SCHEMAS_PATH"
          export ANDROID_HOME="${androidSdk}/libexec/android-sdk"
          export ANDROID_NDK_HOME="${ndkRoot}"
          export NDK_HOME="${ndkRoot}"
          export RUST_SRC_PATH="${rustToolchain}/lib/rustlib/src/rust/library"
          export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER="${llvmBin}/aarch64-linux-android24-clang"
          export CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_LINKER="${llvmBin}/armv7a-linux-androideabi24-clang"
          export CARGO_TARGET_I686_LINUX_ANDROID_LINKER="${llvmBin}/i686-linux-android24-clang"
          export CARGO_TARGET_X86_64_LINUX_ANDROID_LINKER="${llvmBin}/x86_64-linux-android24-clang"
          export CARGO_TARGET_AARCH64_LINUX_ANDROID_RUSTFLAGS="-Clink-arg=-landroid -Clink-arg=-llog -Clink-arg=-lOpenSLES"
          export CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_RUSTFLAGS="-Clink-arg=-landroid -Clink-arg=-llog -Clink-arg=-lOpenSLES"
          export CARGO_TARGET_I686_LINUX_ANDROID_RUSTFLAGS="-Clink-arg=-landroid -Clink-arg=-llog -Clink-arg=-lOpenSLES"
          export CARGO_TARGET_X86_64_LINUX_ANDROID_RUSTFLAGS="-Clink-arg=-landroid -Clink-arg=-llog -Clink-arg=-lOpenSLES"
        '';
      };
    };
}
