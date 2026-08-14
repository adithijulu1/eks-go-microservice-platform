FROM golang:1.22-alpine AS builder

WORKDIR /app
COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /bin/service ./cmd/service

FROM alpine:3.19
RUN adduser -D -u 1000 appuser
COPY --from=builder /bin/service /bin/service
USER appuser
EXPOSE 8080
ENTRYPOINT ["/bin/service"]
