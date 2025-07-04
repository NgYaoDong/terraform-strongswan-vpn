### Dockerfile for image: ngyaodong/strongswan:latest
FROM ubuntu:22.04

LABEL maintainer="Ng Yao Dong <ngyaodong@gmail.com>"
LABEL description="Docker image for building and running the StrongSwan VPN server using Ubuntu 22.04."
LABEL version="1.0"

# Install StrongSwan and necessary tools
RUN apt-get update && \
    apt-get install -y strongswan strongswan-pki libcharon-extra-plugins libcharon-extauth-plugins libstrongswan-extra-plugins libtss2-tcti-tabrmd0 charon-systemd strongswan-swanctl && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -f /etc/init.d/strongswan-starter

# Expose necessary ports for StrongSwan
EXPOSE 500 4500

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
