GOPATH := $(shell go env | grep GOPATH | sed 's/GOPATH="\(.*\)"/\1/')
PATH := $(GOPATH)/bin:$(PATH)
export $(PATH)
export GO111MODULE=on

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build_frontend:
	cd web && yarn install
	cd web && yarn build
	cd web && rm build/static/**/*.map

get_cmd_deps:
	go get -v github.com/mattn/goveralls
	go get -v github.com/gobuffalo/packr/v2/packr2
	go get -v github.com/mitchellh/gox

embed_frontend:
	cd cmd/golang-url-shortener && packr2

build_internal:
	CGO_ENABLED=0 gox -output="releases/{{.Dir}}_{{.OS}}_{{.Arch}}/{{.Dir}}" -osarch="linux/amd64" -ldflags="-X github.com/aptdeco/golang-url-shortener/internal/util.ldFlagNodeJS=`node --version` -X github.com/aptdeco/golang-url-shortener/internal/util.ldFlagCommit=`git rev-parse HEAD` -X github.com/aptdeco/golang-url-shortener/internal/util.ldFlagYarn=`yarn --version` -X github.com/aptdeco/golang-url-shortener/internal/util.ldFlagCompilationTime=`TZ=UTC date +%Y-%m-%dT%H:%M:%S+0000`" ./cmd/golang-url-shortener
	find releases -maxdepth 1 -mindepth 1 -type d -exec cp config/example.yaml {}/config.yaml \;

build: build_frontend get_cmd_deps embed_frontend build_internal ## Builds the application.

clean: ## Cleans up generated files/folders from the build.
	/bin/rm -rfv "data/" "releases/" "cmd/golang-url-shortener/packrd" "coverage.out"

test: ## Test all of the go files and generate a Code Coverage report.
	@go test ./... -coverprofile=coverage.out
	@go tool cover -html=coverage.out