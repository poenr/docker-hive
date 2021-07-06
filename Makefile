current_branch := $(shell git rev-parse --abbrev-ref HEAD)
build:
	docker build -t harbor.software.dc/mpdata/hive:$(current_branch) ./
