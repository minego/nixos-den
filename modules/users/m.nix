{ den, minego, ... }: {
	den.aspects.m = {
		includes = [
			den.primary-user
			minego.shell
			minego.apps._.coreutils
			minego.apps._.dev
		];

		nixos.users.users.m.extraGroups = [
			"adb"
			"docker"
			"wireshark"
			"video"
			"input"
			"dialout"
			"media"

			"kvm"
			"libvirtd"
			"docker"
		];
	};

	den.hosts.x86_64-linux.agrajag.users.quasi		= { };
}
