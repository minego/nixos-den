{
	flake.modules.nixos.software_base = {host, ... }: {
		nixpkgs.hostPlatform = host.system;
	};
}
