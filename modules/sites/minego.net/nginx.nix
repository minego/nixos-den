# Main web page, and used for reverse proxy for other services
{
	flake.modules.nixos.sites_minego_net = { config, lib, ... }: {
		options.services.nginx = {
			hostname = lib.mkOption {
				type = lib.types.str;
			};

			sslCertificate = lib.mkOption {
				type = lib.types.str;
			};

			sslCertificateKey = lib.mkOption {
				type = lib.types.str;
			};
		};

		config = {
			services.nginx = rec {
				# Custom options, to be referenced in other parts of the config
				hostname				= "minego.net";
				sslCertificate			= "/var/lib/acme/${hostname}/fullchain.pem";
				sslCertificateKey		= "/var/lib/acme/${hostname}/key.pem";

				# Standard options
				enable					= true;

				recommendedProxySettings= true;
				recommendedTlsSettings	= true;
				recommendedGzipSettings	= true;
				# recommendedOptimisation	= true;
				recommendedBrotliSettings= true;

				# proxyResolveWhileRunning= true;
				# resolver.addresses		= [ "1.1.1.1" ];

				virtualHosts."${hostname}" = {
					forceSSL			= true;
					default				= true;
					root				= "/var/www/${hostname}";

					locations."/" = {
					};

					locations."/.videos/Movies/" = {
						alias			= "/data/Movies/";
						extraConfig		= "autoindex on;";
					};

					locations."/.videos/TV/" = {
						alias			= "/data/TV/";
						extraConfig		= "autoindex on;";
					};

					locations."/.videos/Audiobooks/" = {
						alias			= "/data/Audiobooks/";
						extraConfig		= "autoindex on;";
					};

					locations."/.videos/Downloads/" = {
						alias			= "/data/downloads/";
						extraConfig		= "autoindex on;";
					};

					serverAliases		= [
						"www.${hostname}"
						"micahgorrell.com"
						"www.micahgorrell.com"
					];

					sslCertificate		= sslCertificate;
					sslCertificateKey	= sslCertificateKey;
				};
			};

			age.secrets.hotblack-cloudflare-user = {
				file			= ./../../../secrets/hotblack-cloudflare-user.age;
				owner			= "root";
				group			= "users";
				mode			= "400";
			};
			age.secrets.hotblack-cloudflare-key = {
				file			= ./../../../secrets/hotblack-cloudflare-key.age;
				owner			= "root";
				group			= "users";
				mode			= "400";
			};

			security.acme = {
				acceptTerms			= true;
				defaults = {
					email			= "m@minego.net";
					credentialFiles	= {
						CLOUDFLARE_EMAIL_FILE	= config.age.secrets.hotblack-cloudflare-user.path;
						CLOUDFLARE_API_KEY_FILE	= config.age.secrets.hotblack-cloudflare-key.path;
					};

					# I don't know why, but the propagation check has been failing
					# since April 2025. So... Just give it some time instead.
					#
					# Manually checking does show the correct records, and waiting
					# does the trick too.
					#
					# My best theory is that cloudflare started wrapping the value
					# in quotes, which is handled just fine by let's encrypt but the
					# lego tool doesn't expect? I am not sure.
					extraLegoFlags = [
						"--dns.propagation-wait" "60s"
					];
					environmentFile = ./cloudflare.env;
					enableDebugLogs	= true;
				};

				certs."${config.services.nginx.hostname}" = {
					domain			= "*.${config.services.nginx.hostname}";
					dnsProvider		= "cloudflare";
					dnsResolver		= "1.1.1.1:53";

					group			= "nginx";
					extraDomainNames= [ "${config.services.nginx.hostname}" ];
				};
			};

			# Open ports
			networking.firewall.allowedTCPPorts = [ 80 443 ];
		};
	};
}

