{ inputs, lib, config, self, ... }:
let
	inherit (lib) mkOption types;
in {
	options = let
		baseHostModule = { config, ... }: {
			options = {
				name = mkOption {
					type = types.str;
				};

				primaryUser = mkOption {
					type = types.str;
					default = "m";
				};

				system = mkOption {
					type = types.str;
					default = "x86_64-linux";
				};

				unstable = lib.mkOption {
					type = types.bool;
					default = true;
				};

				modules = lib.mkOption {
					type = with types; listOf deferredModule;
					default = [ ];
				};

				nixpkgs = lib.mkOption {
					type = types.pathInStore;
				};

				pkgs = lib.mkOption {
					type = types.pkgs;
				};

				# Contains the final package for this configuration
				package = lib.mkOption {
					type = types.package;
				};

				displays = mkOption {
					type = types.lazyAttrsOf displayType;
				};

				primaryDisplay = mkOption {
					type = displayType;
				};

				ignorePowerButton = lib.mkOption {
					type = types.bool;
					default = true;
				};

				colors = mkOption {
							default = {
								light = {
									black	= "000000";
									red		= "ff2a6d";
									green	= "bcea3b";
									yellow	= "faff00";
									blue	= "02a9ea";
									magenta	= "A61B47";
									cyan	= "05d9e8";
									white	= "999999";
									grey	= "0f0f0f";
								};

								dark = {
									black	= "222222";
									red		= "D9245D";
									green	= "96BA2F";
									yellow	= "D5D900";
									blue	= "0285B8";
									magenta	= "8C173C";
									cyan	= "04ACB8";
									white	= "ffffff";
									grey	= "090909";
								};
							};

							type = types.submodule {
								options = {
									light	= colorsOption;
									dark	= colorsOption;
								};
							};
						};

			};
			config = {
				nixpkgs = if config.unstable then
					inputs.nixpkgs
				else
					inputs.nixpkgs-stable;

				pkgs = import config.nixpkgs {
					inherit (config) system;

					config.allowUnfree = true;
				};
			};
		};

		displayType = types.submodule (
			{ name, config, ... }: {
				options = {
					name = mkOption {
						default		= name;
						readOnly	= true;
					};
					primary = mkOption {
						type		= types.bool;
						default		= false;
					};
					refresh = mkOption {
						type		= types.float;
						default		= 60.0;
					};
					width = mkOption {
						type		= types.int;
						default		= 1920;
					};
					height = mkOption {
						type		= types.int;
						default		= 1080;
					};
					x = mkOption {
						type		= types.int;
						default		= 0;
					};
					y = mkOption {
						type		= types.int;
						default		= 0;
					};
					scaling = mkOption {
						type		= types.float;
						default		= 1.0;
					};
					roundScaling = mkOption {
						type		= types.int;
						default		= builtins.ceil config.scaling;
					};
					vrr = mkOption {
						type		= types.enum [ true false "on-demand" ];
						default		= false;
					};
				};
			}
		);

		colorsOption = mkOption {
			type = types.submodule {
				options = {
					black	= mkOption { type = types.str; };
					red		= mkOption { type = types.str; };
					green	= mkOption { type = types.str; };
					yellow	= mkOption { type = types.str; };
					blue	= mkOption { type = types.str; };
					magenta	= mkOption { type = types.str; };
					cyan	= mkOption { type = types.str; };
					white	= mkOption { type = types.str; };
					grey	= mkOption { type = types.str; };
				};
			};
		};

		hostTypeNixos = types.submodule [
			baseHostModule
			({ name, ... }: {
				modules = [
				];
				package = self.nixosConfigurations.${name}.config.system.build.toplevel;
			})
		];

#		hostTypeHomeManager = types.submodule [
#			baseHostModule
#			({ name, ... }: {
#				modules = [
#					config.flake.modules.homeManager.core
#					({ pkgs, ... }: {
#						nix.package = pkgs.nix;
#					})
#				];
#				package = self.homeConfigurations.${name}.activationPackage;
#			})
#		];
    in {
		nixosHosts	= mkOption { type = types.attrsOf hostTypeNixos; };
#		homeHosts	= mkOption { type = types.attrsOf hostTypeHomeManager; };
    };

	config = {
		flake = {
			nixosConfigurations = let
				mkHost = hostname: options: options.nixpkgs.lib.nixosSystem {
					inherit (options) system modules;

					specialArgs.inputs = inputs;
					specialArgs.host = options;
				};
			in lib.mapAttrs mkHost config.nixosHosts;

#			homeConfigurations = let
#				mkHost = configName: options: inputs.home-manager.lib.homeManagerConfiguration {
#					extraSpecialArgs = {
#						inherit configName inputs;
#	
#						nhSwitchCommand = "nh home switch --configuration ${configName}";
#					};
#	
#					inherit (options) pkgs modules;
#				};
#			in lib.mapAttrs mkHost config.homeHosts;
		};

		perSystem = { pkgs, lib, system, ... }: {
			checks = let
				filterSystem = lib.filterAttrs (n: cfg: cfg.system == system);

				extractChecks = name: configs: pkgs.symlinkJoin {
					name = "${name}-checks";
					paths = lib.pipe configs [
						filterSystem
						(lib.mapAttrsToList (_: cfg: cfg.package))
					];
				};
			in lib.mapAttrs extractChecks {
				nixos-hosts = config.nixosHosts;
#				home-hosts = config.homeHosts;
			};
		};
	};
}

