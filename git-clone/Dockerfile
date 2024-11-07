FROM alpine/git:latest

# Create workspace directory
RUN mkdir -p /workspace

# Copy any necessary scripts
COPY clone.sh /usr/local/bin/clone.sh
RUN chmod +x /usr/local/bin/clone.sh

# Set the entrypoint to the clone script
ENTRYPOINT ["/usr/local/bin/clone.sh"]
