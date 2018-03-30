# https://github.com/foospidy/sigsci-docker-brew

FROM alpine:latest

LABEL MAINTAINER foospidy

RUN apk update && apk --no-cache add ca-certificates wget && update-ca-certificates

# Download Signal Sciences agent
RUN wget https://dl.signalsciences.net/sigsci-agent/sigsci-agent_latest.tar.gz && \
    tar -xzf sigsci-agent_latest.tar.gz && \
    rm sigsci-agent_latest.tar.gz

# Clean up
RUN rm -rf /var/cache/apk/*

ENTRYPOINT ["./sigsci-agent"]