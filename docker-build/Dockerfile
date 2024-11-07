FROM alpine:latest

# Install necessary tools
RUN apk update && \
  apk add --no-cache \
  docker \
  docker-cli \
  docker-compose \
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

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh"]
CMD ["docker", "version"]
