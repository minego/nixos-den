let
	module = { lib, pkgs, ... }: {
		programs.ssh = {
			startAgent							= lib.mkDefault true;
			extraConfig							= "AddKeysToAgent yes";
		};
		programs.mosh.enable					= true;

		environment.systemPackages = with pkgs; [
			sshfs
		];
	};
in {
	flake.modules.nixos.software		= module;
	flake.modules.nixos.software_ssh	= module;
}
