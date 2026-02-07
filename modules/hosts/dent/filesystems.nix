{
	den.aspects.dent.nixos = {
		fileSystems."/boot" = {
			device			= "/dev/disk/by-uuid/8CC6-BDDD";
			fsType			= "vfat";
			options			= [ "noatime" ];
		};

		fileSystems."/" = {
			device			= "/dev/disk/by-uuid/51345dbe-c749-4043-b347-4231ab92c799";
			fsType			= "ext4";
		};

		boot.initrd.luks.devices = {
			"luks-3d83c353-b63b-413c-8f84-6a84ace5569a" = {
				device			= "/dev/disk/by-uuid/3d83c353-b63b-413c-8f84-6a84ace5569a";
				allowDiscards	= true;
			};

			"luks-d81962c8-e3d0-422b-8ff1-918452b9857f" = {
				device			= "/dev/disk/by-uuid/d81962c8-e3d0-422b-8ff1-918452b9857f";
				allowDiscards	= true;
			};
		};
	};
}
