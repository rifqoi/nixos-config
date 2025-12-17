{...}: {
  disko.devices = {
    disk.main = {
      device = "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank";
            };
          };
        };
      };
    };

    zpool.tank = {
      type = "zpool";
      options = {
        ashift = "12";
        autotrim = "on";
      };

      rootFsOptions = {
        compression = "zstd";
        acltype = "posixacl";
        xattr = "sa";
        relatime = "on";
        atime = "off";
      };

      datasets = {
        root = {
          type = "zfs_fs";
          mountpoint = "/";
        };

        nix = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options = {
            atime = "off";
          };
        };

        home = {
          type = "zfs_fs";
          mountpoint = "/home";
        };

        var = {
          type = "zfs_fs";
          mountpoint = "/var";
        };

        vm = {
          type = "zfs_fs";
          mountpoint = "/var/lib/vms";
          options = {
            recordsize = "1M";
            atime = "off";
          };
        };
      };
    };
  };
}
