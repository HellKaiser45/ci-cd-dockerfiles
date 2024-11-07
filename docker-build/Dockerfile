FROM docker:latest

# Install additional tools
RUN apk add --no-cache \
  curl \
  jq \
  git \
  bash

# Copy build scripts
COPY build_and_push.sh /usr/local/bin/build_and_push.sh
RUN chmod +x /usr/local/bin/build_and_push.sh

# Copy dockerd entrypoint
COPY dockerd-entrypoint.sh /usr/local/bin/dockerd-entrypoint.sh
RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

# Set up Docker socket and startup
VOLUME /var/lib/docker
EXPOSE 2375

ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh"]
CMD ["docker", "version"]
