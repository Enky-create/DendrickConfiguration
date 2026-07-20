{ self, inputs, ... }: {
  flake.nixosModules.android-flash-drivers = { config, pkgs, inputs, ... }:
{

  # --- adb/fastboot: доступ к устройству без sudo, нужные udev-правила ---
  programs.adb.enable = true;
  users.users.vadim.extraGroups = [ "adbusers" ]; # замените "vadim" на своё имя пользователя, если другое

  # --- эмуляция aarch64: pmbootstrap собирает/распаковывает chroot под ARM
  #     на вашем x86_64 хосте через QEMU + binfmt_misc ---
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  environment.systemPackages = with pkgs; [
    # pmbootstrap сам по себе (если он у вас через pip/git — можно убрать)
    pmbootstrap

    # инструменты для прошивки/общения с устройством
    android-tools     # adb, fastboot
    usbutils          # lsusb — уже есть у вас в systemPackages
    dtc               # device-tree compiler, нужен pmbootstrap-у для сборки dtb

    # для распаковки/работы с образами
    dosfstools        # mkfs.vfat
    gptfdisk          # sgdisk, для GPT-разметки
    parted
    util-linux        # losetup, fdisk — обычно уже есть в базовой системе
    unzip
    xz
    zstd

    # часто требуется pmbootstrap-у при сборке/апгрейде chroot'ов
    git
    openssl
    ccache
  ];

  # ускоряет qemu-user эмуляцию внутри chroot'ов pmbootstrap
  boot.kernelModules = [ "binfmt_misc" ];
  };
  }
