{
	minego.ssh.provides = {
		client.nixos = { pkgs, lib, ... }: {
			programs.ssh = {
				startAgent							= lib.mkDefault true;
				extraConfig							= "AddKeysToAgent yes";
			};
			programs.mosh.enable					= true;

			environment.systemPackages = with pkgs; [
				sshfs
			];
		};
	};
}
