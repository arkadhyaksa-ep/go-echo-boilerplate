FROM golang:latest as build
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./
RUN go build -o /echo-boilerplate-app

EXPOSE 1200

CMD [/echo-boilerplate-app]
