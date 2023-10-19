FROM golang:latest AS build
WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -o echo-boilerplate-app

FROM alpine:latest

WORKDIR /app

COPY --from=build /app/echo-boilerplate-app .

EXPOSE 1200

# Command to run the Go application.
CMD ["./echo-boilerplate-app"]
