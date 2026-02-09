# Usenet Downloader
{
	flake.modules.nixos.sites_minego_net = { config, pkgs, lib, ... }: {
		options.services.sabnzbd = {
			port							= lib.mkOption { type = lib.types.port; };
			publicURL						= lib.mkOption { type = lib.types.str;  };
			internalURL						= lib.mkOption { type = lib.types.str;  };
		};

		config = {
			services.sabnzbd = rec {
				port						= 8080;
				internalURL					= "http://127.0.0.1:${toString port}";
				publicURL					= "http://sabnzbd.${config.services.nginx.hostname}";

				enable						= true;
				group						= "media";
				# configFile					= "/var/lib/sabnzbd/sabnzbd.ini";

				secretFiles					= [ "/var/lib/sabnzbd/secrets.ini" ];

				settings = {
					misc = {
						port				= port;
						email_to			= "m@minego.net";
						host_whitelist		= "hotblack,sabnzbd.minego.net";
						url_base			= "/sabnzbd";
						admin_dir			= "/var/lib/sabnzbd/admin";
						complete_dir		= "/data/downloads/complete";
						download_dir		= "/data/downloads/incomplete";
						reject_duplicate_files = true;
						deobfuscate_final_filenames = true;
						cache_limit			= "100M";
						bandwidth_max		= "62M";
					};

					categories = {
						tv = {
							name			= "tv";
							order			= 0;
							script			= "Default";
							dir				= "tv";
						};
						movies = {
							name			= "movies";
							order			= 0;
							script			= "Default";
							dir				= "movies";
						};
						reader = {
							name			= "reader";
							order			= 0;
							script			= "Default";
							dir				= "reader";
						};
					};

					servers = {
						usenetserver = {
							enable			= true;
							required		= true;
							displayname		= "usenetserver";
							name			= "news.usenetserver.com";
							host			= "news.usenetserver.com";
							port			= 8080;
							timeout			= 120;
							connections		= 100;
							ssl				= true;
							ssl_verify		= "strict";
						};
						verycouch = {
							enable			= false;
							name			= "verycouch";
							displayname		= "news.verycouch.com";
							host			= "news.verycouch.com";
							port			= 9999;
							timeout			= 60;
							connections		= 2;
							ssl				= true;
							ssl_verify		= "strict";
							retention		= 5000;
						};
					};
				};
			};

			networking.firewall.allowedTCPPorts = [ 8080 9090 ];

			environment.systemPackages = with pkgs; [
				par2cmdline
			];

			# Wait until after nginx to start, and restart on failure

			systemd.services.sabnzbd = {
				after						= [ "network.target" "nginx.service" ];
				serviceConfig = {
					Restart					= "always";
					RestartSec				= 3;
				};
			};


			services.nginx.virtualHosts."sabnzbd.${config.services.nginx.hostname}" = {
				forceSSL					= true;

				locations."/" = {
					proxyPass				= config.services.sabnzbd.internalURL;
					proxyWebsockets			= true;
					extraConfig				= "proxy_pass_header Authorization;";
				};

				sslCertificate				= config.services.nginx.sslCertificate;
				sslCertificateKey			= config.services.nginx.sslCertificateKey;
			};
		};
	};
}
