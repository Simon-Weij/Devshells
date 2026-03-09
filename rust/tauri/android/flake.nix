{
  # Slightly hacky flake, but it works, may need improvements, since it's not really pure
  inputs.flakelight.url = "github:nix-community/flakelight";
  outputs = {flakelight, ...}:
    flakelight ./. {
      devShell = {
        packages = pkgs: [
          pkgs.pkg-config
          pkgs.wrapGAppsHook4
          pkgs.nodejs
          pkgs.librsvg
          pkgs.webkitgtk_4_1

          pkgs.jdk21
          pkgs.rustup
          pkgs.android-tools
        ];
        shellHook = pkgs: ''
          export XDG_DATA_DIRS="$GSETTINGS_SCHEMAS_PATH"
          export ANDROID_HOME="$HOME/Android/Sdk"
          export ANDROID_NDK_HOME="$HOME/Android/Sdk/ndk/28.2.13676358"

          rustup default stable
          rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android

          export RUST_SRC_PATH="$(rustup run stable rustc --print sysroot)/lib/rustlib/src/rust/library"

          export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER="$ANDROID_NDK_HOME/too lchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android21-clang"
          export CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_LINKER="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi21-clang"
          export CARGO_TARGET_I686_LINUX_ANDROID_LINKER="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/i686-linux-android21-clang"
          export CARGO_TARGET_X86_64_LINUX_ANDROID_LINKER="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/x86_64-linux-android21-clang"
        '';
      };
    };
}
