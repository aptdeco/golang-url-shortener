FROM golang:1.12-buster as builder
ENV GO111MODULE=on
WORKDIR /go/src/github.com/aptdeco/golang-url-shortener/
COPY . .
RUN go mod tidy

RUN apt update && apt install -y nodejs npm

RUN npm install -g yarn

RUN make

# upx stuff
FROM gruebel/upx:latest as upx
COPY --from=builder /releases/golang-url-shortener_linux_amd64/golang-url-shortener /golang-url-shortener.org
RUN upx --best --lzma -o /golang-url-shortener /golang-url-shortener.org

FROM debian:buster
RUN useradd --create-home app
WORKDIR /home/app
COPY --from=upx /golang-url-shortener .
COPY config/example.yaml ./config.yaml
RUN chown -R app: .
USER app

EXPOSE 8080

VOLUME ["/data"]

CMD ["/home/app/golang-url-shortener"]
