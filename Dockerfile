FROM alpine:3.19

# Create a non-root user
RUN addgroup -S unbound && adduser -S unbound -G unbound

# Install packages and fetch root hints in one layer
RUN apk update && \
    apk upgrade && \
    apk add --no-cache unbound bind-tools wget && \
    wget https://www.internic.net/domain/named.root -qO /etc/unbound/root.hints && \
    chown -R unbound:unbound /etc/unbound && \
    rm -rf /var/cache/apk/*

# Copy configuration
COPY --chown=unbound:unbound unbound.conf /etc/unbound/unbound.conf

# Set proper permissions
RUN chmod 644 /etc/unbound/unbound.conf /etc/unbound/root.hints

# Switch to non-root user
USER unbound

# Expose both UDP and TCP
EXPOSE 53/udp 53/tcp

# Add health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD dig @127.0.0.1 -p 53 google.com || exit 1

# Run unbound
CMD ["/usr/sbin/unbound", "-d", "-v", "-c", "/etc/unbound/unbound.conf"]
