.PHONY: all fmt update switch gc

all: update fmt switch

HOSTNAME := $(shell scutil --get LocalHostName)

fmt:
	(fd -e nix -x nixfmt && fd -e nix -x alejandra -q)
	(prettier . -w)

update:
	(nix flake update)

switch:
	(nix run nix-darwin -- switch --flake .)

build:
	(nom build '.#darwinConfigurations.${HOSTNAME}.system')

gc:
	(sudo nix-collect-garbage -d && sudo nix-store --gc && sudo nix-store --optimise)
