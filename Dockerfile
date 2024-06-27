# Use the Kali Linux base image
FROM kalilinux/kali-rolling

# Install necessary packages
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    novnc \
    websockify \
    supervisor \
    wget \
    fakeroot

# Set up VNC server
RUN mkdir -p ~/.vnc && \
    echo "erokomo" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Set up the supervisor to manage the VNC server and noVNC
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose necessary ports
EXPOSE 8080

# Start supervisor
CMD ["/usr/bin/supervisord"]
