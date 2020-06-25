FROM ubuntu:latest AS stage-1

COPY main.go /
COPY go.mod /
COPY go.sum /

COPY Makefile /

WORKDIR /

RUN /bin/bash -c "apt-get update && \
apt-get install -y make gcc wget tar gzip && \
wget -P / 'https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz' && \
tar -C /usr/local -xzf /go1.14.4.linux-amd64.tar.gz"

ENV PATH "$PATH:/usr/local/go/bin"

RUN /bin/bash -c "make build"

FROM ubuntu:latest AS stage-2

COPY --from=stage-1 /demo.bin /

ENV EMO_APP_ADDR 10.0.0.2
ENV DEMO_REDIS_ADDR 10.0.0.3:6379

EXPOSE 8080

CMD ["/bin/bash","-c","/demo.bin"]
