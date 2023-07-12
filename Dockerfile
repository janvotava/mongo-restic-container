FROM alpine:latest AS restic

RUN apk add --update --no-cache mongodb-tools restic
