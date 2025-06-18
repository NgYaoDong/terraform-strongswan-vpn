FROM alpine:latest

LABEL maintainer="Ng Yao Dong <ngyaodong@gmail.com>"
LABEL description="Docker image for building and running the StrongSwan VPN server."
LABEL version="1.0"

# Install StrongSwan and necessary tools
RUN apk update && \
    apk add --no-cache strongswan tpm2-tss iproute2 bash && \
    rm -f /etc/init.d/strongswan-starter

# Expose necessary ports for StrongSwan
EXPOSE 500 4500

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
