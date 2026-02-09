# Notification push service
{
	flake.modules.nixos.sites_minego_net = { config, lib, ... }: {
		options.services.ntfy-sh = {
			port							= lib.mkOption { type = lib.types.port; };
		};

		config = {
			services.ntfy-sh = {
				port						= 9191;
				enable						= true;

				settings = {
					base-url				= "https://ntfy.${config.services.nginx.hostname}";
					listen-http				= ":${toString config.services.ntfy-sh.port}";
					auth-file				= "/var/lib/ntfy-sh/users.db";
					behind-proxy			= true;
					enable-login			= true;
					auth-default-access		= "write-only";
				};
			};

			services.nginx.virtualHosts."ntfy.${config.services.nginx.hostname}" = {
				forceSSL					= true;

				locations."/" = {
					proxyPass				= "http://127.0.0.1:${toString config.services.ntfy-sh.port}";
					proxyWebsockets			= true;
					extraConfig				= "proxy_pass_header Authorization;";
				};

				sslCertificate				= config.services.nginx.sslCertificate;
				sslCertificateKey			= config.services.nginx.sslCertificateKey;
			};
		};
	};
}

