# Example to create a bios compatible gpt partition
{ lib, ... }:
{
  boot.loader.grub.devices = [ "/dev/sda" ];
  fileSystems = {
    "/".neededForBoot = true;
    "/boot".neededForBoot = true;
  };
  disko.devices = {
    disk = {
#       # dev/disk/by-uuid doesn't work and errors out with error:
#       # Error: Could not stat device /dev/disk/by-uuid/1d6f10ce-5dde-44b0-bceb-6f865f5de8f0 - No such file or directory.
#       # device = lib.mkDefault "/dev/disk/by-uuid/1d6f10ce-5dde-44b0-bceb-6f865f5de8f0";
      sda = {
        device = lib.mkDefault "/dev/disk/by-id/A5F8287A-4665-4D26-B0FB-86C18B7B45AA";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
# {
#   boot.loader.grub.devices = [ "/dev/sda" ];
#   disko.devices = {
#     disk.disk1 = {
#       # dev/disk/by-uuid doesn't work and errors out with error:
#       # Error: Could not stat device /dev/disk/by-uuid/1d6f10ce-5dde-44b0-bceb-6f865f5de8f0 - No such file or directory.
#       # device = lib.mkDefault "/dev/disk/by-uuid/1d6f10ce-5dde-44b0-bceb-6f865f5de8f0";
# 
#       device = lib.mkDefault "/dev/sda";
#       type = "disk";
#       content = {
#         type = "gpt";
#         partitions = {
#           esp = {
#             name = "ESP";
#             start = "1MiB";
#             end = "1G";
#             type = "EF00";
#             content = {
#               type = "filesystem";
#               format = "vfat";
#               mountpoint = "/boot";
#             };
#           };
#           root = {
#             name = "root";
#             size = "100%";
#             content = {
#               type = "lvm_pv";
#               vg = "pool";
#             };
#           };
#         };
#       };
#     };
#     lvm_vg = {
#       pool = {
#         type = "lvm_vg";
#         lvs = {
#           root = {
#             size = "100%FREE";
#             content = {
#               type = "filesystem";
#               format = "ext4";
#               mountpoint = "/";
#               mountOptions = [
#                 "defaults"
#               ];
#             };
#           };
#         };
#       };
#     };
#   };
#   fileSystems = {
#     "/".neededForBoot = true;
#     "/boot".neededForBoot = true;
#   };
# }

# {
#   boot.loader.grub.devices = [ "/dev/sda" ];
#   disko.devices = {
#     disk = {
#       sda = {
#         type = "disk";
#         device = "/dev/sda";
#         content = {
#           type = "gpt";
#           partitions = {
#             sda1 = {
#               size = "1M";
#               content = {
#                 type = "filesystem";
#                 format = "ext4";
#               };
#             };
#             sda2 = {
#               size = "1G";
#               type = "EF00";
#               content = {
#                 type = "filesystem";
#                 format = "ext4";
#                 mountpoint = "/boot";
#               };
#             };
#             sda3 = {
#               size = "100%";
#               content = {
#                 type = "filesystem";
#                 format = "ext4";
#                 mountpoint = "/";
#               };
#             };
#           };
#         };
#       };
#     };
#   };
# }
