FROM alpine:3.16.2

RUN apk update && \
    apk upgrade && \
    apk add unbound wget && \
    rm -rf /var/cache/apk/*


RUN wget https://www.internic.net/domain/named.root -qO- | tee /etc/unbound/root.hints

COPY unbound.conf /etc/unbound/unbound.conf

EXPOSE 53

CMD ["/usr/sbin/unbound", "-d", "-v", "-c", "/etc/unbound/unbound.conf"]
