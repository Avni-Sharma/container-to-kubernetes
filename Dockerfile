FROM alpine:latest

RUN apk add --no-cache git make musl-dev go

# Configure Go
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

#Include curl command
RUN apk add --update \
    curl \
    && rm -rf /var/cache/apk/*

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

WORKDIR /go/src/firstApp
COPY . /go/src/firstApp
RUN  go build -o /go/bin/firstApp /go/src/firstApp

#ENTRYPOINT ["/go/bin/firstApp"]
