FROM golang:1.21.0 as build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /echo-boilerplate-app
RUN go test -v ./...

FROM gcr.io/distroless/base-debian11
WORKDIR /
COPY --from=build /echo-boilerplate-appp /echo-boilerplate-app
ENV PORT 1200
USER nonroot:nonroot
CMD [/echo-boilerplate-app]
