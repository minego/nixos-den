# Usage:
#
#	1. Add an entry in the main list below, and set the list of public keys
#	that should be allowed to decrypt it.
#
#	2. Create the actual encrypted file with:
#		`agenix -e "$name.age"
#
#	3. Add an entry to the host's `age.secrets` config:
#		"${name}" = {
#			file	= ../../secrets/${name}.age;
#			owner	= "root";
#			group	= "users";
#			mode	= "400";
#		};
#
#	4. Reference the resulting file where appropriate in the nix config:
#		config.age.secrets.${name}.path;

let
	hotblack						= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOfrwQzGDRICpbmMHns9QaAxjtEkG5IEzpAJBvdgEbB3";
	m_hotblack						= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWCk1KpqchVgLCWC711+F1fnRnp6so3FwLpPYG85xIi";

	dent							= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpnfpoW0qVQ52DgebLZiUt9XV+9tnRKqbJl3qTwNnAO";
	m_dent							= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHrr0jgE0HE25pM0Mpqz1H8Bu3VczJa1wSIcJVLbPtiL";

	zaphod2							= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjIL6OCooExk6DM8BjDLKLYD89VpCQJbxo1BD/vis2a";
	m_zaphod2						= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHOpMsaa0+ZPrF3dTHcXXXRiA/qfGYtF1wehO0UkEaWV";

	wonko							= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHcwfLfIzCwim+8lyWntQeX2S2pnvj6/DQl9KVbAiXNR";
	m_wonko							= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP6avo8bo4p2UsXer2yUPkS5s4E/m5fMkhX9WnzrffwJ";

	agrajag							= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGDpugZHA9KagfIIMAtxmffX5SMyowzmlg7FsG2jefo";
	m_agrajag						= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIEcebCWo0hCFtXGKPp+00b+yDIkxrFa56r9O3Qg9+oQ";

	dishoftheday					= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFfLHhmOFL67pFgfxT+FDNaKMizevvN2sQ7BN0y5uM9K";
	m_dishoftheday					= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICeEbhtPh89IAirnW03UmjH0F68Zwh+z2xHUwG7ztISb";

	hosts							= [ hotblack dent zaphod2 wonko agrajag dishoftheday ];
	users							= [ m_hotblack m_dent m_zaphod2 m_agrajag m_dishoftheday m_wonko ];
in
{
	"hotblack-cloudflare-user.age".publicKeys	= [ hotblack m_hotblack ];
	"hotblack-cloudflare-key.age".publicKeys	= [ hotblack m_hotblack ];

	"mosquitto.age".publicKeys					= users ++ hosts;
	"chromium-sync-oauth.age".publicKeys		= users ++ hosts;
}


