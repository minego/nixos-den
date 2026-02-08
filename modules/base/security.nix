{
	flake.modules.nixos.base = {
		security = {
			sudo = {
				wheelNeedsPassword	= false;
				extraConfig = ''
                   Defaults    env_keep+=SSH_AUTH_SOCK
                   '';
			};

			polkit.enable			= true;
			pam.loginLimits = [
				{
					domain			= "*";
					item			= "nofile";
					type			= "hard";
					value			= 128000;
				}
				{
					domain			= "*";
					item			= "nofile";
					type			= "soft";
					value			= 20480;
				}
				{
					domain			= "m";
					item			= "rtprio";
					type			= "-";
					value			= "98";
				}
				{
					domain			= "m";
					item			= "nice";
					type			= "-";
					value			= -20;
				}
			];
		};
	};
}
