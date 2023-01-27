FROM golang:1.19-alpine

WORKDIR /build
ADD ./src/azureapp/ /build/
ADD ./src/azureapp/assets/ /output/assets/

RUN go mod download \
    && go build -o /output/azureapp \
    && cp -r /build/assets /output/

FROM alpine:latest

WORKDIR /root/
COPY --from=0 /output/ ./

RUN apk --no-cache add ca-certificates

CMD ["./azureapp"]