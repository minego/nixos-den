{ lib, config, ... }: let
	top = config;
in {
	flake.modules.nixos = {
		hardware_network_tailscale = { lib, config, pkgs, ... }: {
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

		hardware_network_tailscale_client = {
			imports = with top.flake.modules.nixos; [
				hardware_network_tailscale
			];

			services.tailscale.useRoutingFeatures = lib.mkForce "client";
		};

		hardware_network_tailscale_server = {
			imports = with top.flake.modules.nixos; [
				hardware_network_tailscale
			];

			services.tailscale.useRoutingFeatures = lib.mkForce "server";
		};

		hardware_network_tailscale_both = {
			imports = with top.flake.modules.nixos; [
				hardware_network_tailscale
			];

			services.tailscale.useRoutingFeatures = lib.mkForce "both";
		};
	};
}
