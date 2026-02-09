# Music Assistant reverse proxy
{
	flake.modules.nixos.sites_minego_net = { config, lib, ... }: {
		options.music-assistant = {
			publicURL						= lib.mkOption { type = lib.types.str;  };
			internalURL						= lib.mkOption { type = lib.types.str;  };
		};

		config = {
			music-assistant = {
				publicURL					= "https://music.${config.services.nginx.hostname}";
				internalURL					= "http://172.31.4.201:8095";
			};

			services.nginx.virtualHosts."music.${config.services.nginx.hostname}" = {
				forceSSL					= true;

				locations."/" = {
					proxyPass				= config.music-assistant.internalURL;
					proxyWebsockets			= true;

					# Do NOT enable this, because it turns on X-Forwarded-For which
					# causes 400 errors
					recommendedProxySettings= false;
					extraConfig				= ''
						resolver 8.8.8.8;
						proxy_set_header Host $host;
						proxy_set_header X-Real-IP $remote_addr;
						'';
				};

				extraConfig = ''
					proxy_buffering off;
					'';

				sslCertificate				= config.services.nginx.sslCertificate;
				sslCertificateKey			= config.services.nginx.sslCertificateKey;
			};
		};
	};
}

