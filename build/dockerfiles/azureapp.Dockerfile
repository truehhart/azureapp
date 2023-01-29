FROM golang:1.19-alpine

WORKDIR /build
ADD ./src/azureapp/ /build/
ADD ./src/azureapp/assets/ /output/assets/

RUN go mod download \
    && GOOS=linux GOARCH=amd64 go build -o /output/azureapp

FROM alpine:latest

WORKDIR /root/
COPY --from=0 /output/ ./

RUN apk --no-cache add ca-certificates

CMD ["./azureapp"]