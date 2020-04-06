FROM golang:1.14-alpine as build

RUN apk add -U git gcc libc-dev

ENV ICINGADB_VERSION=1.0.0-rc1

RUN git clone https://github.com/Icinga/icingadb.git -b "v${ICINGADB_VERSION}" /icingadb

WORKDIR /icingadb

# We need an redis for this
#RUN go test -v ./...

RUN go build -o icingadb .

FROM alpine

RUN apk add -U bash shadow mysql-client netcat-openbsd \
 && rm -rf /var/cache/apk

RUN groupadd -g 1000 icingadb \
 && useradd -g 1000 -u 1000 -c "IcingaDB system user" -s /bin/false -d /var/lib/icingadb -m icingadb \
 && mkdir /etc/icingadb \
 && chown 1000:1000 /etc/icingadb

COPY --from=build /icingadb/icingadb /usr/local/bin/icingadb.bin
COPY --from=build /icingadb/etc/schema /schema
COPY --from=build /icingadb/icingadb.ini /etc/icingadb/icingadb.example.ini

COPY scripts/ /usr/local/bin/

USER icingadb
ENTRYPOINT ["docker-entrypoint"]
CMD ["icingadb"]
