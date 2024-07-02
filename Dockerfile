# Use Kali Linux as the base image
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
    fakeroot \
    metasploit-framework \
    sudo \
    apache2

# Set up VNC server
RUN mkdir -p /root/.vnc && \
    echo "erokomo" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Copy the supervisor configuration file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose necessary ports
EXPOSE 8080
EXPOSE 5901
EXPOSE 80

# Start supervisor
CMD ["/usr/bin/supervisord"]
