{
	description		= "Micah's NixOS config";

	outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

	inputs = {
		nixpkgs = {
			url = "github:NixOS/nixpkgs/nixos-unstable";
		};

		# Flakes needed for using the dendritic pattern
		flake-parts = {
			url = "github:hercules-ci/flake-parts";
		};

		import-tree = {
			url = "git+https://tangled.org/oeiuwq.com/import-tree";
		};

		# nix-made (Home Manager alternative)
		nix-maid = {
			url = "github:viperML/nix-maid";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# My own flakes
		nixvim = {
			url = "git+https://codeberg.org/minego/nixvim";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		mackeys = {
			url = "git+https://codeberg.org/minego/mackeys";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		swapmods = {
			url = "git+https://codeberg.org/minego/swapmods";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		chrkbd = {
			url = "git+https://codeberg.org/minego/chrkbd";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		osk = {
			url = "git+https://codeberg.org/minego/qs-osk";
			inputs.nixpkgs.follows = "nixpkgs";
		};


		# Hardware specific flakes
		nixos-hardware = {
			url = "github:nixos/nixos-hardware";
		};

		jovian-nixos = {
			url = "github:Jovian-Experiments/Jovian-NixOS";
			inputs.nixpkgs.follows = "nixpkgs";
		};


		# Software I use
		agenix = {
			url = "github:ryantm/agenix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-your-shell = {
			url	= "github:MercuryTechnologies/nix-your-shell";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		zsh-vi-mode = {
			url = "github:jeffreytse/zsh-vi-mode";
			flake = false;
		};

		nix-gaming = {
			url = "github:fufexan/nix-gaming";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.flake-parts.follows = "flake-parts";
		};

		niri = {
			url = "github:YaLTeR/niri";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		niri-config = {
			url = "github:sodiboo/niri-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		dms = {
			url = "github:AvengeMedia/DankMaterialShell";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		quickshell = {
			url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-index-database = {
			url = "github:nix-community/nix-index-database";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
}
