FROM golang:1.19-alpine

WORKDIR /build
COPY src/app/ /build/

RUN go mod download \
    && go build -o /output/app \
    && cp -r /build/assets /output/assets

FROM alpine:latest

WORKDIR /root/
COPY --from=0 /output/ ./

RUN apk --no-cache add ca-certificates

CMD ["./app"]