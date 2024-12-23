{ pkgs, lib, ... }:

pkgs.flutter.buildFlutterApplication rec {
  pname = "jellyflix";
  version = "unstable-2024-12-23";

  buildInputs = with pkgs; [
    libsecret
    jsoncpp
    mpv
  ];

  desktopItem = pkgs.makeDesktopItem {
    name = "jellyflix";
    exec = "jellyflix";
    icon = "icon";
    desktopName = "Jellyflix";
  };

  src = pkgs.fetchFromGitHub {
    owner = "jellyflix-app";
    repo = "jellyflix";
    rev = "1637ccf2bfbda1fca1039deb065ba7b203d813ff";
    hash = "sha256-1CInDm831yJ/CfEjq914TX6aG2C+E9RezoLFw953DLQ=";
  };

  autoPubspecLock = src + "/pubspec.lock";

  preInstall = ''
    echo "Installing desktop item"
    mkdir -p "$out/share/icons/hicolor/jellyflix/apps/"
    cp "${src}/assets/icon/icon.png" "$out/share/icons/hicolor/jellyflix/apps/"

    mkdir -p "$out/share"
    cp -r "${desktopItem}/share/applications" "$out/share/applications"
  '';

  gitHashes = {
    filter_list = "sha256-/KgFLeoBTC3yq77esDqXwqP97+BcO3msYKki86OJEj0=";
    flutter_secure_storage = "sha256-7c6ooUpJ+ZBmtNdBzKAOzY8raNZ9V8qeVkI6hraF1cQ=";
    media_kit = "sha256-6qtw+NSwfGWXQmNBH5kPg45oqvd/oAH5sYA2nz4iHPM=";
    media_kit_video = "sha256-6qtw+NSwfGWXQmNBH5kPg45oqvd/oAH5sYA2nz4iHPM=";
    media_kit_libs_video = "sha256-6qtw+NSwfGWXQmNBH5kPg45oqvd/oAH5sYA2nz4iHPM=";
    media_kit_libs_android_video = "sha256-6qtw+NSwfGWXQmNBH5kPg45oqvd/oAH5sYA2nz4iHPM=";
    media_kit_libs_ios_video = "sha256-6qtw+NSwfGWXQmNBH5kPg45oqvd/oAH5sYA2nz4iHPM=";
    media_kit_libs_macos_video = "sha256-6qtw+NSwfGWXQmNBH5kPg45oqvd/oAH5sYA2nz4iHPM=";
    media_kit_libs_windows_video = "sha256-6qtw+NSwfGWXQmNBH5kPg45oqvd/oAH5sYA2nz4iHPM=";
    tentacle = "sha256-30a4Vn8wL0TdboSYPm1W+hRqXSsuID0gNOVnNe3KmPE=";
  };
}
