FROM golang:latest
WORKDIR /app

RUN apt-get update && apt-get install -y git 
RUN git clone https://github.com/arkadhyaksa-ep/go-echo-boilerplate.git .

COPY go.mod go.sum ./
RUN go mod download

RUN go build -o echo-boilerplate-app

EXPOSE 1200

CMD ["./echo-boilerplate-app"]
