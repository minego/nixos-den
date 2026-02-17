# Secrets Management
{
	flake.modules.nixos.sites_minego_net = { config, ... }: let
		virtualHost = {
			forceSSL					= true;

			locations."/" = {
				proxyPass				= "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
				proxyWebsockets			= true;
				extraConfig				= "proxy_pass_header Authorization;";
			};

			sslCertificate				= config.services.nginx.sslCertificate;
			sslCertificateKey			= config.services.nginx.sslCertificateKey;
		};
	in {
		services.vaultwarden = {
			enable						= true;
			dbBackend					= "sqlite";
			domain						= "bitwarden.minego.net";

			config = {
				DATA_FOLDER				= "/var/lib/vaultwarden";
				ROCKET_ADDRESS			= "127.0.0.1";
				ROCKET_PORT				= 8222;
			};
		};

		services.nginx.virtualHosts."bitwarden.${config.services.nginx.hostname}"	= virtualHost;
		services.nginx.virtualHosts."vaultwarden.${config.services.nginx.hostname}"	= virtualHost;
		services.nginx.virtualHosts."secrets.${config.services.nginx.hostname}"		= virtualHost;
	};
}

