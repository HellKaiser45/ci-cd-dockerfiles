FROM python:3.10-slim

# Install necessary dependencies
RUN pip install --no-cache-dir \
  requests \
  urllib3

# Create version directory
RUN mkdir -p /version

# Copy the version check script
COPY version_check.py /usr/local/bin/version_check.py
RUN chmod +x /usr/local/bin/version_check.py

# Set working directory
WORKDIR /version

# Set the entrypoint to run sysctl and then the script
ENTRYPOINT ["/bin/sh", "-c", "sysctl -w fs.inotify.max_user_watches=2099999999 && python /usr/local/bin/version_check.py"]
