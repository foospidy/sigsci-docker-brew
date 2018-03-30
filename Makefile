OS=$(shell uname -s)

install:
ifeq ($(OS), Darwin)
	brew install shellcheck
else
	# for travis-ci
	apt-get install shellcheck
endif

lint:
	shellcheck sigsci_osx.sh

run:
ifeq ($(OS), Darwin)
	./sigsci_osx.sh
endif

stop:
	docker-machine stop sigsci

start:
	docker-machine start sigsci

reset:
	docker-machine stop sigsci
	docker-machine start sigsci
