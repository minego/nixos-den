{
	den.default = {
		nixoso = { lib, ... }: {
			environment.etc.inputrc.source = lib.mkForce ./inputrc;
		};
	};
}
