{ minego, ... }: {
	minego.networking.provides = {
		# Enable Network Manager
		networkManager.nixos = { lib, ... }: {
			networking.networkmanager = {
				enable									= true;
				wifi.powersave							= true;
			};

			# Default to using DHCP, but using NM means the user can override
			# as they want, including connecting to wifi networks.
			networking.useDHCP							= lib.mkDefault true;

			# Disable the applet, because the DMS menu is nicer
			programs.nm-applet.enable					= lib.mkForce false;
			systemd.user.services.app-nm-applet.enable	= lib.mkForce false;
			systemd.user.services.nm-applet.enable		= lib.mkForce false;

			# Prevent failig to do a switch because networkmanager takes too long
			systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
		};

		# Enable DHCP, without network manager
		dhcp.nixos = { lib, ... }: {
			systemd.network = {
				enable					= true;
				networks."10-enp2s0" = {
					matchConfig.Name	= "enp2s0";
					networkConfig.DHCP	= "yes";
				};
			};
			networking.useDHCP			= lib.mkForce false;

			# This is required for VMs using just static DHCP, or DNS will not
			# function at all.
			system.nssDatabases.hosts	= (lib.mkOrder 301 [ "dns" ]);
		};

		tailscale = {
			provides = {
				client = {
					includes = [ minego.networking._.tailscale ];
					nixos = { lib, ... }: {
						services.tailscale.useRoutingFeatures = lib.mkForce "client";
					};
				};

				server = {
					includes = [ minego.networking._.tailscale ];
					nixos = { lib, ... }: {
						services.tailscale.useRoutingFeatures = lib.mkForce "server";
					};
				};

				both = {
					includes = [ minego.networking._.tailscale ];
					nixos = { lib, ... }: {
						services.tailscale.useRoutingFeatures = lib.mkForce "both";
					};
				};
			};

			nixos = { lib, config, pkgs, ... }: {
				services.tailscale = {
					enable					= lib.mkDefault true;
					openFirewall			= true;

					# Default to client, use the 'server' or 'both' aspect to
					# override.
					useRoutingFeatures		= lib.mkDefault "client";
				};

				systemd.services.tailscale-autoconnect = {
					enable					= config.services.tailscale.enable;
					description				= "Automatic connection to Tailscale";

					# make sure tailscale is running before trying to connect to tailscale
					after					= [ "network-pre.target" "tailscaled.service" ];
					wants					= [ "network-pre.target" "tailscaled.service" ];
					wantedBy				= [ "multi-user.target" ];

					# set this service as a oneshot job
					serviceConfig.Type		= "oneshot";

					script = ''
						# wait for tailscaled to settle
						sleep 2
						
						# check if we are already authenticated to tailscale
						status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
						if [ "$status" = "Running" ]; then
							echo "Already connected"
							exit 0
						fi

						if [ "$status" = "NeedsLogin" ]; then
							echo "Login is required; Run 'sudo tailscale up' manually once."
							exit 0
						fi
						
						${pkgs.tailscale}/bin/tailscale up ${lib.escapeShellArgs config.services.tailscale.extraUpFlags}
						'';
				};
			};
		};
	};
}
