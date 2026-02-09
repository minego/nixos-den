{
	flake.modules.nixos.sites_minego_net = { config, lib, ... }: {
		options.services.mosquitto = {
			port							= lib.mkOption { type = lib.types.port; };
			internalURL						= lib.mkOption { type = lib.types.str;  };
		};

		config = {
			services.mosquitto = rec {
				port						= 1883;
				internalURL					= "http://127.0.0.1:${lib.toString port}";

				enable						= true;
				listeners = [{
					acl						= [ "pattern readwrite #" ];
					address					= "0.0.0.0";
					port					= config.services.mosquitto.port;

					users.m = {
						acl					= [ "readwrite #" ];
						passwordFile		= config.age.secrets.mosquitto.path;
					};
				}];
			};

			networking.firewall = {
				allowedTCPPorts				= [ config.services.mosquitto.port ];
			};

			age.secrets.mosquitto = {
				file			= ./../../secrets/mosquitto.age;
				owner			= "root";
				group			= "users";
				mode			= "440";
			};
		};
	};
}

