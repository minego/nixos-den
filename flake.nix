{
	description		= "Micah's NixOS config";
	outputs			= inputs: inputs.flake-parts.lib.mkFlake
		{ inherit inputs; }
		(inputs.import-tree ./modules);

	inputs = {
		nixpkgs.url			= "github:NixOS/nixpkgs/nixos-unstable";

		flake-parts.url		= "github:hercules-ci/flake-parts";
		import-tree.url		= "git+https://tangled.org/oeiuwq.com/import-tree";
		den.url				= "git+https://tangled.org/oeiuwq.com/den";
		flake-aspects.url	= "git+https://tangled.org/oeiuwq.com/flake-aspects";
		nixos-hardware.url	= "github:nixos/nixos-hardware";
		nixvim.url			= "git+https://codeberg.org/minego/nixvim";

		mackeys.url			= "git+https://codeberg.org/minego/mackeys";
		swapmods.url		= "git+https://codeberg.org/minego/swapmods";
		chrkbd.url			= "git+https://codeberg.org/minego/chrkbd";
		osk.url				= "git+https://codeberg.org/minego/qs-osk";

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
	};
}
