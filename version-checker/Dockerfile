FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install Python and pip
RUN apt-get update && apt-get install -y \
  python3 \
  python3-pip \
  && rm -rf /var/lib/apt/lists/* \
  && ln -s /usr/bin/python3 /usr/bin/python

# Install necessary Python dependencies
RUN pip3 install --no-cache-dir \
  requests \
  urllib3

# Create version directory
RUN mkdir -p /version

# Copy the version check script
COPY version_check.py /usr/local/bin/version_check.py
RUN chmod +x /usr/local/bin/version_check.py

# Set working directory
WORKDIR /version

# Set the entrypoint to run the script with python3
ENTRYPOINT ["/usr/bin/python3", "/usr/local/bin/version_check.py"]
