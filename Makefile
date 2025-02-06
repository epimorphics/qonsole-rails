.PHONY: auth clean gem publish test vars

NAME?=qonsole_rails
OWNER?=epimorphics
VERSION?=$(shell /usr/bin/env ruby -e 'require "./lib/${NAME}/version" ; puts QonsoleRails::VERSION')
PAT?=$(shell read -p 'Github access token:' TOKEN; echo $$TOKEN)

AUTH=${HOME}/.gem/credentials
GEM=${NAME}-${VERSION}.gem
GPR=https://rubygems.pkg.github.com/${OWNER}
SPEC=${NAME}.gemspec

all: publish

${AUTH}:
	@mkdir -p ${HOME}/.gem
	@echo '---' > ${AUTH}
	@echo ':github: Bearer ${PAT}' >> ${AUTH}
	@chmod 0600 ${AUTH}

${GEM}: ${SPEC} ./lib/${NAME}/version.rb
	gem build ${SPEC}

auth: ${AUTH}

build: gem

clean:
	@rm -rf ${GEM}

gem: ${GEM}
	@echo ${GEM}

lint:
	@bundle install
	@echo "Running rubocop..."
	@bundle exec rubocop

publish: ${AUTH} ${GEM}
	@echo Publishing package ${NAME}:${VERSION} to ${OWNER} ...
	@gem push --key github --host ${GPR} ${GEM}
	@echo Done.

realclean: clean
	@rm -rf ${AUTH}

tags:
	@echo version=${VERSION}

test:
	@bundle install
	@bundle exec rake test

vars:
	@echo "GEM"	= ${GEM}
	@echo "GPR"	= ${GPR}
	@echo "NAME = ${NAME}"
	@echo "OWNER = ${OWNER}"
	@echo "SPEC = ${SPEC}"
	@echo "VERSION = ${VERSION}"

