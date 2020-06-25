FROM redis:latest

COPY redis.conf /etc/redis/

WORKDIR /

EXPOSE 6379

CMD ["/bin/bash","-c","redis-server /etc/redis/redis.conf"]
