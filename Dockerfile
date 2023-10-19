FROM golang:latest as build
WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN go build -o echo-boilerplate-app

FROM alpine:latest
WORKDIR /

COPY --from=build /app/echo-boilerplate-app /echo-boilerplate-app

EXPOSE 1200

CMD ["/echo-boilerplate-app"]
