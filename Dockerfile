FROM golang:latest as build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /echo-boilerplate-app

FROM alpine:latest
WORKDIR /
COPY --from=build /echo-boilerplate-appp /echo-boilerplate-app
ENV PORT 1200

CMD [/echo-boilerplate-app]
