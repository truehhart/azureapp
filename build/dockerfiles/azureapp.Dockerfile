FROM golang:1.19-alpine

WORKDIR /build
ADD ./src/app/ /build/
ADD ./src/app/assets /output/assets

RUN go mod download \
    && go build -o /output/app

FROM alpine:latest

WORKDIR /root/
COPY --from=0 /output/ ./

RUN apk --no-cache add ca-certificates

CMD ["./app"]