FROM golang:1.21-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git
RUN go install github.com/hashicorp/http-echo@latest

FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /go/bin/http-echo /usr/local/bin/http-echo
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/http-echo"]
