FROM golang:1.14-alpine as build

RUN apk add -U git gcc libc-dev

ENV ICINGADB_VERSION=1.0.0-rc1

RUN git clone https://github.com/Icinga/icingadb.git -b "v${ICINGADB_VERSION}" /icingadb

WORKDIR /icingadb

# We need an redis for this
#RUN go test -v ./...

RUN go build -o icingadb .

FROM alpine

COPY --from=build /icingadb/icingadb /usr/local/bin/icingadb

COPY --from=build /icingadb/etc/schema /schema
