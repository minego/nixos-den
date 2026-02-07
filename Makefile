HOSTNAME	:= $(shell hostname -s)
UNAME_S		:= $(shell uname -s)
UNAME_M		:= $(shell uname -m)
HOST		:= $(shell hostname)

FLAKES		:= $(wildcard deps/*/flake.nix)
FLAKE_DIRS	:= $(dir $(FLAKES))

TOOL		:= nh os
ARGS		:= ./

# First, so that it is the default target
.PHONY: all
all:
	@echo "Cowardly refusing to run. Try again with 'switch' or 'test'"

# Update related targets
################################################################################
$(FLAKE_DIRS):
	@echo "Updating flake $@"
	@(cd $@ && git pull && nix flake update)
	@(cd $@ && git add flake.lock && git commit -m "Updates" && git push) || true
	@(git add $@ && git commit -m "Updated submodule: $@") || true

$(FLAKES): $(FLAKE_DIRS)

.PHONY: dep-branches
dep-branches:
	@(git submodule init && git submodule update)
	@(cd deps/nixvim			&& git switch main		)
	@(cd deps/swapmods			&& git switch main		)
	@(cd deps/mackeys			&& git switch main		)
	@(cd deps/chrkbd			&& git switch main		)
	@(cd deps/osk				&& git switch main		)

.PHONY: git-updates
git-update:
	@git pull

# The `update` target will do:
#	- Update all git submodules
#	- Update the flake for each dependency that has a flake.nix
#	- Update the main flake
#	- Show a `git status`
.PHONY: update
update: git-update dep-branches $(FLAKES)
	@echo "Updating flake ."
	@nix flake update
	@git status

# Build helpers
################################################################################
.PHONY: build
build:
	@$(TOOL) build $(ARGS)

.PHONY: build-remote
build-remote: remote-setup
	@$(TOOL) build $(ARGS) $(REMOTE_ARGS)

.PHONY: build-vm
build-vm:
	@$(TOOL) build-vm $(ARGS) --hostname $(HOSTNAME)

.PHONY: build-vm-remote
build-vm-remote: remote-setup
	@$(TOOL) build-vm $(ARGS) $(REMOTE_ARGS) --hostname $(HOSTNAME)

.PHONY: switch
switch:
	@$(TOOL) switch $(ARGS)

.PHONY: switch-remote
switch-remote: remote-setup
	@$(TOOL) switch $(ARGS) $(REMOTE_ARGS)

.PHONY: boot
boot:
	@$(TOOL) boot $(ARGS)

.PHONY: boot-remote
boot-remote: remote-setup
	@$(TOOL) boot $(ARGS) $(REMOTE_ARGS)

.PHONY: rollback
rollback:
	@$(TOOL) switch $(ARGS) --rollback

.PHONY: repl
repl:
	nix repl --expr "builtins.getFlake \"${PWD}\""

.PHONY: repl-host
repl-host:
	nix repl ".#nixosConfigurations.\"${HOST}\""

.PHONY: repl-hosts
repl-hosts:
	nix repl ".#nixosConfigurations"

.PHONY: remote-setup
remote-setup:
ifeq ($(origin REMOTE_HOST), undefined)
	@echo "The REMOTE_HOST option is required; example:"
	@echo
	@echo "   make switch REMOTE_HOST=m@dent"
	@echo
	@echo
	@false
endif
REMOTE_ARGS := --build-host ${REMOTE_HOST} --use-substitutes --sudo

.PHONY: check
check:
	@nix flake check $(ARGS)

.PHONY: test
test: check
	@$(TOOL) dry-build $(ARGS)

.PHONY: clean
clean:
	@true

# Run this when /boot is too full
.PHONY: clean-generations
clean-generations:
	sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +3
	sudo /run/current-system/bin/switch-to-configuration switch

# Deps
################################################################################

.PHONY: why-depends
why-depends:
ifndef PKG
	$(error Run as: 'PKG=moo make why-depends' to check what depends on 'nixpkgs#moo')
endif
	nix why-depends .#nixosConfigurations.${HOSTNAME}.config.system.build.toplevel nixpkgs#${PKG}

# One offs, machine specific things, images, etc
################################################################################

# Build an image for the phone
marvin-image:
	nix build ./#marvin-image $(ARGS)

# Build an image for the steam deck
wonko-installer:
	nix build .#nixosConfigurations.wonko.config.formats.install-iso $(ARGS)

wonko-image:
	nix build .#nixosConfigurations.wonko.config.formats.raw-efi $(ARGS)

