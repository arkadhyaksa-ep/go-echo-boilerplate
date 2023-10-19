FROM golang:latest AS build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /echo-boilerplate-app

EXPOSE 1200

CMD ["./echo-boilerplate-app"]
