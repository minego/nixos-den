{
	den.aspects.agrajag.nixos = {
		fileSystems."/boot" = {
			device			= "/dev/disk/by-uuid/10EB-18AC";
			fsType			= "vfat";
			options			= [ "noatime" ];
		};

		fileSystems."/" = {
			device			= "/dev/disk/by-uuid/6ef2b006-2215-4291-a446-90b3bf9aaabc";
			fsType			= "ext4";
		};

		boot.initrd.luks.devices."luks-cdb4caa5-84d0-4273-a1ce-d077376cfc46" = {
			device			= "/dev/disk/by-uuid/cdb4caa5-84d0-4273-a1ce-d077376cfc46";
			allowDiscards	= true;
		};
	};
}
