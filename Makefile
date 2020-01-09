all: buildNodeFrontend getCMDDependencies embedFrontend getGoDependencies runUnitTests buildProject

runUnitTests:
	go test -v ./...

buildNodeFrontend:
	cd web && yarn install
	cd web && yarn build
	cd web && rm build/static/**/*.map

embedFrontend:
	cd cmd/golang-url-shortener && GO112MODULE=on packr2

getCMDDependencies:
	go get -v github.com/mattn/goveralls
	go get -v github.com/gobuffalo/packr/v2/packr2
	go get -v github.com/mitchellh/gox

getGoDependencies:
	go get -v ./...

buildProject:
	rm -rf releases
	mkdir releases
	CGO_ENABLED=0 gox -output="/releases/{{.Dir}}_{{.OS}}_{{.Arch}}/{{.Dir}}" -osarch="linux/amd64" -ldflags="-X github.com/aptdeco/golang-url-shortener/internal/util.ldFlagNodeJS=`node --version` -X github.com/aptdeco/golang-url-shortener/internal/util.ldFlagCommit=`git rev-parse HEAD` -X github.com/aptdeco/golang-url-shortener/internal/util.ldFlagYarn=`yarn --version` -X github.com/aptdeco/golang-url-shortener/internal/util.ldFlagCompilationTime=`TZ=UTC date +%Y-%m-%dT%H:%M:%S+0000`" ./cmd/golang-url-shortener
	find releases -maxdepth 1 -mindepth 1 -type d -exec cp config/example.yaml {}/config.yaml \;
	find releases -maxdepth 1 -mindepth 1 -type d -exec tar -cvjf {}.tar.bz2 {} \;
