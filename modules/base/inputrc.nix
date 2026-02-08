{
	flake.modules.nixos.base = { lib, ... }: {
		environment.etc.inputrc.source = lib.mkForce ./inputrc;
	};
}
